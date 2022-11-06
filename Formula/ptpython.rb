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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32825de5d071845115558f57de21b2318d8da73cc9c6920cdaafc2669355f2a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ece3f47a0eaf377a1c1a088f74a86791eb636315ebfaed54b01f8be1c13a8761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "438056e36eeefefdbe804d950c8861e9178db01fea6df670f83c506a8b7eb0c5"
    sha256 cellar: :any_skip_relocation, monterey:       "54b237dc070385bbf7ab6fec1f1590440feb3d46ae506efd6cabfd9b048dbe37"
    sha256 cellar: :any_skip_relocation, big_sur:        "916a01805966942286942293e9e3b77c23bd8db91be83803cdcd8c5c5c7a7b20"
    sha256 cellar: :any_skip_relocation, catalina:       "3cbe9de5e60de6754eba2e1631759df14aa6e536e25b44d4665e16841124923e"
    sha256 cellar: :any_skip_relocation, mojave:         "4b2f693efede4f086e5b9042d2a24b5f1bc691f79c7f63dda3f925402356c392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bddea40c1f3d5b943d062c90caf7888f381f2c51bef077dc6aee2d3f5f233c7"
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
