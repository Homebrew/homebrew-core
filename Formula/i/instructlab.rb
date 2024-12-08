class Instructlab < Formula
  include Language::Python::Virtualenv

  desc "Use a novel synthetic data-based alignment tuning method for LLMs"
  homepage "https://github.com/instructlab/instructlab"
  url "https://github.com/instructlab/instructlab/releases/download/v0.21.2/instructlab-0.21.2.tar.gz"
  sha256 "99c2ba360214005088f6ee1a94d60fb89c622e78e5b6c1d8df2f67b8cbf36fd3"
  license "Apache-2.0"

  depends_on "ccache" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.11"

  def fix_dylib_paths(target_files: nil)
    require "macho"

    dylibs_path = libexec/"lib/python3.11/site-packages/PIL/.dylibs"
    files_to_process = target_files || dylibs_path.glob("*.dylib")

    files_to_process.each do |dylib|
      next unless dylib.exist?

      macho = MachO.open(dylib)

      new_id = "@loader_path/#{dylib.basename}"
      macho.change_dylib_id(new_id)

      macho.dylib_load_commands.each do |cmd|
        old_path = cmd.name.to_s
        next unless old_path.include?("PIL/.dylibs")

        new_path = "@loader_path/#{File.basename(old_path)}"
        macho.change_install_name(old_path, new_path)
      end

      macho.write!

      MachO.codesign!(dylib)

      validation_output = `otool -L #{dylib}`
      if validation_output.include?("@loader_path/#{dylib.basename}")
        ohai "Successfully fixed and validated: #{dylib.basename}"
      else
        opoo "Validation failed for: #{dylib.basename}. Please check manually using `otool -L #{dylib}`."
      end
    end
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    odie "This tool only supports Apple Silicon (M1/M2/M3) systems. Installation aborted." unless Hardware::CPU.arm?

    venv = virtualenv_create(libexec, "python3.11", system_site_packages: false)
    system libexec/"bin/python", "-m", "ensurepip"
    system libexec/"bin/python", "-m", "pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/python", "-m", "pip", "cache", "remove", "llama_cpp_python"
    venv.pip_install_and_link buildpath
    system libexec/"bin/python", "-m", "pip", "install", "-r", buildpath/"requirements.txt"

    # Replace universal binaries with native slices.
    deuniversalize_machos
  end

  def post_install
    # Fix dynamic library paths in PIL dependencies
    fix_dylib_paths(target_files: [libexec/"lib/python3.11/site-packages/PIL/.dylibs/libpng16.16.dylib"])

    # Installation success message
    ohai "✅ InstructLab has been installed successfully."
    ohai "Next Steps:"
    ohai "  Run `ilab config init` to initialize your configuration."
    ohai "Use `ilab --help` to get started."
  end

  test do
    # check dylibs
    dylibs_path = libexec/"lib/python3.11/site-packages/PIL/.dylibs"

    dylib_path = dylibs_path/"libpng16.16.dylib"
    if dylib_path.exist?
      otool_output = shell_output("otool -L #{dylib_path}")
      assert_match "@loader_path/libpng16.16.dylib", otool_output, "Incorrect or missing path in dylib linkage"
    end
    # Verify installation and functionality of the CLI tool
    assert_match "Usage:", shell_output("#{bin}/ilab --help")
  end
end
