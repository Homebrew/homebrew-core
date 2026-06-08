class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/e4/b6/74d9a8a68b8067efce8d07707fe6a236324ee1e7808d2eb3646ec8517c7d/pylint-4.0.5.tar.gz"
  sha256 "8cd6a618df75deb013bd7eb98327a95f02a6fb839205a6bbf5456ef96afb317c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0dca7577ab14d501bddfc63c63bcfc56c872df55b7385d4d403712af1afd1cc8"
  end

  depends_on "python@3.14"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/07/63/0adf26577da5eff6eb7a177876c1cfa213856be9926a000f65c4add9692b/astroid-4.0.4.tar.gz"
    sha256 "986fed8bcf79fb82c78b18a53352a0b287a73817d6dbcfba3162da36667c49a0"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/bf/e3/e72b0b3a85f24cf5fc2cd8e92b996592798f896024c5cdf3709232e6e377/isort-8.0.0.tar.gz"
    sha256 "fddea59202f231e170e52e71e3510b99c373b6e571b55d9c7b31b679c0fed47c"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1b/04/fea538adf7dbbd6d186f551d595961e564a3b6715bdf276b477460858672/platformdirs-4.9.2.tar.gz"
    sha256 "9a33809944b9db043ad67ca0db94b14bf452cc6aeaac46a88ea55b26e2e9d291"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/c3/af/14b24e41977adb296d6bd1fb59402cf7d60ce364f90c890bd2ec65c43b5a/tomlkit-0.14.0.tar.gz"
    sha256 "cf00efca415dbd57575befb1f6634c4f42d2d87dbba376128adb42c121b87064"
  end

  def install
    virtualenv_install_with_resources

    inreplace libexec/"pyvenv.cfg", HOMEBREW_PREFIX, prefix
  end

  test do
    (testpath/"pylint_test.py").write <<~PYTHON
      print('Test file'
      )
    PYTHON
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
