class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/5b/5b/6cba7123a089c4174f944dd05ea7984c8d908aba8746a99f2340dde8662f/Cython-0.29.12.tar.gz"
  sha256 "20da832a5e9a8e93d1e1eb64650258956723940968eb585506531719b55b804f"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c7e9402ad5b6779a133c85430cac8fffe9c88a50f23e9e5890be0d06f2a7179" => :mojave
    sha256 "e2e723cdde4abaa9acf0e73f1a3ca580a0e3d4befa3f7514259da785b33d50ca" => :high_sierra
    sha256 "0a7496cf61713e51c99c44c1191f8238bc08794d5e574ef35fdba94eece0bb55" => :sierra
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python"

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system "python3", "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("python3 -c 'import package_manager'")
  end
end
