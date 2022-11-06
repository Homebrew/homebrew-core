class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/00/df/223017f2565336078c872f700ebe1c893a051e4d7b472fd0b68289ab3acb/ptpython-3.0.20.tar.gz"
  sha256 "eafd4ced27ca5dc370881d4358d1ab5041b32d88d31af8e3c24167fe4af64ed6"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fc45a7a29722a71a40baae07edb163c7dd123f35ab63dd213f40be6d18d23293"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05cc373abe49122d27cba62ebb57c893c5b2576f5e5cec22a2d373351f37dc67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c25f4dfeebb3d42c72b45471e2da55bb8e0feeca9d3c0e1cb7b227e8e6b5ec8d"
    sha256 cellar: :any_skip_relocation, monterey:       "3f8f3eb07c8bcad3b755c4c6022124e8d8c42d21252fa38eb2571984d8ad3c2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "227e6d49b251ecd0ca473f9fd12b5d6b5dafa67db38274b8ced16e41980de282"
    sha256 cellar: :any_skip_relocation, catalina:       "a36aa79b5c45151126e8882341cccda04b830f648f1dc23bf1083823ac57b74c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b0912da9db6a512c7561329ec44329f710ddfb05cf41809b4ed93fcce20acd8"
  end

  depends_on "python@3.11"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/c2/25/273288df952e07e3190446efbbb30b0e4871a0d63b4246475f3019d4f55e/jedi-0.18.1.tar.gz"
    sha256 "74137626a64a99c8eb6ae5832d99b3bdd7d29a3850fe2aa80a4126b2a7d949ab"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/e2/d9/1009dbb3811fee624af34df9f460f92b51edac528af316eb5770f9fbd2e1/prompt_toolkit-3.0.32.tar.gz"
    sha256 "e7f2129cba4ff3b3656bbdda0e74ee00d2f874a8bcdb9dd16f5fec7b3e173cae"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e0/ef/5905cd3642f2337d44143529c941cc3a02e5af16f0f65f81cbef7af452bb/Pygments-2.13.0.tar.gz"
    sha256 "56a8508ae95f98e2b9bdf93a6be5ae3f7d8af858b43e02c5a2ff083726be40c1"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
