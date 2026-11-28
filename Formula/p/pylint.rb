class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://pylint.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/8f/d7/bfea980ba1ea5666c7f774627f3a7159b98a21426a081dd2f05db8eb93b3/pylint-4.1.4.tar.gz"
  sha256 "4c9176dc6c9f1b98b742195f01899b290369d5a27b4b41d1014c17f2f96b26f1"
  license "GPL-2.0-or-later"

  bottle do
    manifest_sha256 "87205312962dd3b231ee27ad69beee4c1c3aa6df93d7ed7b2b56b85972d55629"
    sha256 cellar: :any_skip_relocation, all: "d5a9e5535f98f2135ecdfd347a4fca59ba7768cab7fe293223706a938782664e"
  end

  depends_on "rust" => :build # for `isort`
  depends_on "python@3.15"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/2d/87/5732fa68bf100a095cfcbd108f919220d995db99e1a7502b8119a869fd62/astroid-4.3.4.tar.gz"
    sha256 "d515a105722b72098bbe82d430d65e635f742b6cbac3bdfaf8b7c188b87c5e39"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/81/e1/56027a71e31b02ddc53c7d65b01e68edf64dea2932122fe7746a516f75d5/dill-0.4.1.tar.gz"
    sha256 "423092df4182177d4d8ba8290c8a5b640c66ab35ec7da59ccfa00f6fa3eea5fa"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/da/cf/068066b8fdab91cd40bcd63e483137908710a3d25a4d3a01b538be45d9d6/isort-9.0.2.tar.gz"
    sha256 "d2298980ce44350f11d9d24c8150eaef1883431ec203dddbb4e9b5c3ceb54c70"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/d0/6f/43edf3be2748d0e40974a5ee046a8bb4c9961a4bdd3e7d5c6dcbf32d1af6/mypy_extensions-1.2.0.tar.gz"
    sha256 "c6e275a07f1c2fc096b62940452d0eaa3f3af7de45d704787866240a7c6d5a51"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/08/72/fc01563df95c189a9f65850096bdc205bc2fe37da6c740cd64afaf18d07e/tomlkit-0.15.2.tar.gz"
    sha256 "83e32755ba1d20d9340bd069ee97e9f6232ba2346b63ffcba425de01f7e327a6"
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
