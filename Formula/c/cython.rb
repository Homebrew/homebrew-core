class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/a7/f6/d762df1f436a0618455d37f4e4c4872a7cd0dcfc8dec3022ee99e4389c69/cython-3.1.4.tar.gz"
  sha256 "9aefefe831331e2d66ab31799814eae4d0f8a2d246cbaaaa14d1be29ef777683"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9bad722f83c356020e597fc17d523292b041238c2f6594e67e28adf8276dddf8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4588c04df9f54b41a6eb21fa9f64cc193f1d147f26773c3e6f6241f175d031ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38d316e16acfbc8fcdd6173b3a70462b9fdca535676427830635ea39e5731553"
    sha256 cellar: :any_skip_relocation, sonoma:        "dbf2ef8b9722d589c36e398abd02bc3f5703d9210c03e87b5cf5331640b993a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2ad3fddab620092e3755e85fed1e7c825bf1a0f6d8e52b77d90abd99aba25122"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09ffc5aa327c0a08681b74073ddce14f803a927073181ade42a426cdb4ee9ab1"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.13"

  def python3
    "python3.13"
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
    (testpath/"setup.py").write <<~PYTHON
      from distutils.core import setup
      from Cython.Build import cythonize

      setup(
        ext_modules = cythonize("package_manager.pyx")
      )
    PYTHON
    system python3, "setup.py", "build_ext", "--inplace"
    assert_match phrase, shell_output("#{python3} -c 'import package_manager'")
  end
end
