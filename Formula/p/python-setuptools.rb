class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
  sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3f1216774825c551075a7a28ca8c7412e56ddb635f495275e5c231801d3a5abd"
  end

  depends_on "python@3.14" => [:build, :test]
  depends_on "python@3.12" => :test # keep on oldest python to support (externally managed and not EOL)

  def pythons
    deps.filter_map { |dep| dep.to_formula if dep.name.start_with?("python@") }
  end

  def install
    odie "Need exactly 2 python dependencies!" if pythons.count != 2
    oldest_python, python = pythons.sort_by(&:version)
    python_exe = python.opt_libexec/"bin/python"
    system python_exe, "-m", "pip", "install", *std_pip_args, "."

    # Pure python setuptools installation can be used on different Python versions
    site_packages = prefix/Language::Python.site_packages(python_exe)
    python.versioned_formulae.each do |extra_python|
      next if extra_python.version < oldest_python.version

      # Cannot use Python.site_packages as that requires formula to be installed
      extra_site_packages = lib/"python#{extra_python.version.major_minor}/site-packages"
      site_packages.find do |path|
        next unless path.file?

        target = extra_site_packages/path.relative_path_from(site_packages)
        target.dirname.install_symlink path
      end
    end

    # Ensure uniform bottles
    setuptools_site_packages = site_packages/"setuptools"
    inreplace_files = %W[
      #{setuptools_site_packages}/_distutils/compilers/C/unix.py
      #{setuptools_site_packages}/_vendor/platformdirs/unix.py
    ] + setuptools_site_packages.glob("_vendor/platformdirs-*dist-info/METADATA")
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX
    inreplace setuptools_site_packages/"_vendor/platformdirs/macos.py", "/opt/homebrew", HOMEBREW_PREFIX
  end

  test do
    pythons.each do |python|
      system python.opt_libexec/"bin/python", "-c", "import setuptools"
    end
  end
end
