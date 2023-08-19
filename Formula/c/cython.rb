class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/7f/a2/fd5ced5dd33597ef291861bfadd46820de417b41bcb6ca2fa0b5f6fa8152/Cython-3.0.0.tar.gz"
  sha256 "350b18f9673e63101dbbfcf774ee2f57c20ac4636d255741d76ca79016b1bd82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39fcf7bcb4edbb65bd933f0a23e8b1ef1af737afd24273c2ca009e8476960688"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd141d90b535a6876ed7e298551044703644be5b1b3ab8a47a64618c03e910ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb53c0aa363994e523d0cc7c31b3af83bfef73dab468ced620a3e4d9a73ae99b"
    sha256 cellar: :any_skip_relocation, ventura:        "30fd13c838a2077488a5b35c2624b48c125ab4ed18d69f9f1ef46ab1a379dd23"
    sha256 cellar: :any_skip_relocation, monterey:       "b10acf4855126d0ce1fdfacdaa8eff1197a6dd17946fa61f3975c9bd2550ea25"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1b5ca5340438dbc430010fa859ca11021e63efe5a07ac1c6404dc71c825a9b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b9dc62d41c487a129885aa844e965b7bd03846db4c7b8f9265692c31cad7708"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python@3.11"

  def python3
    "python3.11"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)
    system python3, "-m", "pip", "install", *std_pip_args(prefix: libexec), "."

    bin.install (libexec/"bin").children
    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])
  end

  test do
    ENV.prepend_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    phrase = "You are using Homebrew"
    (testpath/"package_manager.pyx").write "print '#{phrase}'"
    (testpath/"setup.py").write <<~EOS
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    EOS
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
