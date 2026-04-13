class Cyan < Formula
  include Language::Python::Virtualenv

  desc "iOS app injector and modifier"
  homepage "https://github.com/asdfzxcvbn/pyzule-rw"
  url "https://github.com/asdfzxcvbn/pyzule-rw/archive/refs/tags/v1.4.4.tar.gz"
  sha256 "fa2ce2a9a715ef9691f77a293ad58a61a6daf170896aebf32024c0ee797fc4a4"
  license "Unlicense"
  head "https://github.com/asdfzxcvbn/pyzule-rw.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3aaa04dcb1c17fb7c594bf66255d9657bad473ad3192f2f953a459a6ef117555"
    sha256 cellar: :any,                 arm64_sequoia: "2afe45a12098c644a1783fde362b37338ef093eae02f027c69594827cc988df2"
    sha256 cellar: :any,                 arm64_sonoma:  "8704c006c8abc7cb5f92f02a6fc45ffae48b99098de33cbfc0cf3d0c5aa7d955"
    sha256 cellar: :any,                 sonoma:        "eb51d22bf9f8d1ca28278c1873893b47b1f50ebca6c9cab061561beda3cc6f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "739a405a26eaad070e1b0fc5094a8140db6d947492d8772f901ad45a90ab9114"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on arch: :x86_64 # insert_dylib does not support Linux arm64
    depends_on "llvm"
  end

  def install
    venv = virtualenv_create(libexec, "python3.14")
    venv.pip_install buildpath
    bin.install_symlink libexec/"bin/cyan"
    bin.install_symlink libexec/"bin/cgen"

    site_packages = libexec/Language::Python.site_packages("python3.14")

    # Keep only tool binaries for the current OS/architecture pair.
    tools_system = OS.mac? ? "Darwin" : "Linux"
    tools_arch = if OS.mac?
      Hardware::CPU.arm? ? "arm64" : "x86_64"
    else
      Hardware::CPU.arm? ? "aarch64" : "x86_64"
    end
    tools_root = site_packages/"cyan/tools"
    tools_root.children.each do |system_dir|
      next unless system_dir.directory?
      next if system_dir.basename.to_s == tools_system

      rm_r system_dir
    end

    current_system_dir = tools_root/tools_system
    current_system_dir.children.each do |arch_dir|
      next unless arch_dir.directory?
      next if arch_dir.basename.to_s == tools_arch

      rm_r arch_dir
    end

    if OS.linux?
      tools_dir = current_system_dir/tools_arch
      rm tools_dir/"lipo"
      tools_dir.install_symlink Formula["llvm"].opt_bin/"llvm-lipo" => "lipo"
    end
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/cyan --version")

    # Generate a .cyan configuration file and verify it's a valid zip
    system bin/"cgen", "-o", testpath/"test.cyan", "-n", "TestApp", "-v", "1.0"
    assert_path_exists testpath/"test.cyan"
    assert_match "config.json", shell_output("zipinfo -1 #{testpath}/test.cyan")
  end
end
