class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/84/4d/b720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aa/cython-3.0.11.tar.gz"
  sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c8f07d2cf12f082f39de2c90f9a0d6b9b72d66a319f24642bf67f7456c2d7f1f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "704cd1687d97983d9143c14af5d3070afdc206458f76d044a4161dc0432335ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1302e5ad351dddd4586ae07d8031f1e8b1a4c6892d85aaaf5b90518fe2d01f9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e61f43ad0501c0c4d6ea000f9c2d6682e4031f1604834d0175ffae3d16e9e7ec"
    sha256 cellar: :any_skip_relocation, ventura:        "eacc3cf1f723744c6c0188f15afb8c5d98e36a9eb540e3eef4dcd774314fd771"
    sha256 cellar: :any_skip_relocation, monterey:       "9fb3966784dd9ac4019f6fb61357b1b02c852e0b583c12e5637d37966543284c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d8f59aa74df8f2e14b46c4222c0e907b549efd491b87ed23bf13e8d1612fcb9a"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.12"

  def python3
    "python3.12"
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
