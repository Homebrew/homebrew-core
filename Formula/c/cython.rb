class Cython < Formula
  desc "Compiler for writing C extensions for the Python language"
  homepage "https://cython.org/"
  url "https://files.pythonhosted.org/packages/5b/d3/bb000603e46144db2e5055219bbddcf7ab3b10012fcb342695694fb88141/cython-3.1.1.tar.gz"
  sha256 "505ccd413669d5132a53834d792c707974248088c4f60c497deb1b416e366397"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cf7c98505aaf21e380629590010aa0f3ef60a5a3fedcb7a48f73aa0c0f837393"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "133a74a0e78c35709444d4d5ff3e0c823546ee96088bad7f6e231c4ffa2b4283"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ac6aec182f253e6943d95e304357b879dd36bbd0044c226a984740894791429"
    sha256 cellar: :any_skip_relocation, sonoma:        "7f2beab53b6769fee72ad394c476904ebb065ab535d95bed63e8961d929801f2"
    sha256 cellar: :any_skip_relocation, ventura:       "43ca32fffe5b4edc178df6d10f8f300819c8d4222869ea580b52b7e829cb9b7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "260aec6bc16a6adec1764f81af0131a3e097f71eba51fa2611f624a0df766c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c85c7499237dd93f3f4db4cc358f6eb872751ef64647deac70977ce6224cb55"
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
