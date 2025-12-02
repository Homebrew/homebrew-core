class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/29/17/55fc687ba986f2210298fa2f60fec265fa3004c3f9a1e958ea1fe2d4e061/cython-3.2.2.tar.gz"
  sha256 "c3add3d483acc73129a61d105389344d792c17e7c1cee24863f16416bd071634"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f3a2b7cab6b4890d7b7604decc51dbdcd63d4b7af5c159236ae5def9910593ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "095d13507fbb041c5c888778c9ba29f2b89218196615ac1c6375d5940c9e9d13"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1013ebf1a65647a2d0247da1f2d2352a694372f9512d382ad2549ed3133b045"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c81205cfaf878f5b62378ff5dfc19da8d4f5ce82ad2558574a857c21612a797"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08d5816cbfa701b94dace7dbe18a72fd1d195db9e820fb554ab4eb65809bea6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95c4669838fcad4d4740be2d0e90475aaf55549c21ab036472fe3114a7bd82d2"
  end

  keg_only <<~EOS
    this formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install cython
  EOS

  depends_on "python-setuptools" => [:build, :test]
  depends_on "python@3.14"

  def python3
    "python3.14"
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
