class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/84/4d/b720d6000f4ca77f030bd70f12550820f0766b568e43f11af7f7ad9061aa/cython-3.0.11.tar.gz"
  sha256 "7146dd2af8682b4ca61331851e6aebce9fe5158e75300343f80c07ca80b1faff"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bc62954851e489e13a2c6a483cf9805c8133cb6d37513f1aafbd5c25f974f81d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "614b56056f50a8483393d4f45de1b58defbe00eedb7a56ac1cbe61fe85a74992"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b373aaa583724d98f23575a625645e26356673e7d17d176524fe79caaccfcc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5d9da57f53e7b66d23dfde15ace02024e928c33e1adef41904dee339876e97e9"
    sha256 cellar: :any_skip_relocation, ventura:       "a5ec0991915cda4c7ff191742ce6fde844f8e01d61dfcdcca06618a9f8a14a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aafe30d15cdf5b3e89c8c2da7f2ef3034de76f965d255ebb72037698a3c358bc"
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
