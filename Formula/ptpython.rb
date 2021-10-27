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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ece3f47a0eaf377a1c1a088f74a86791eb636315ebfaed54b01f8be1c13a8761"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "438056e36eeefefdbe804d950c8861e9178db01fea6df670f83c506a8b7eb0c5"
    sha256 cellar: :any_skip_relocation, monterey:       "54b237dc070385bbf7ab6fec1f1590440feb3d46ae506efd6cabfd9b048dbe37"
    sha256 cellar: :any_skip_relocation, big_sur:        "916a01805966942286942293e9e3b77c23bd8db91be83803cdcd8c5c5c7a7b20"
    sha256 cellar: :any_skip_relocation, catalina:       "3cbe9de5e60de6754eba2e1631759df14aa6e536e25b44d4665e16841124923e"
    sha256 cellar: :any_skip_relocation, mojave:         "4b2f693efede4f086e5b9042d2a24b5f1bc691f79c7f63dda3f925402356c392"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bddea40c1f3d5b943d062c90caf7888f381f2c51bef077dc6aee2d3f5f233c7"
  end

  depends_on "python@3.10"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/ac/11/5c542bf206efbae974294a61febc61e09d74cb5d90d8488793909db92537/jedi-0.18.0.tar.gz"
    sha256 "92550a404bad8afed881a137ec9a461fed49eca661414be45059329614ed0707"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/5e/61/d119e2683138a934550e47fc8ec023eb7f11b194883e9085dca3af5d4951/parso-0.8.2.tar.gz"
    sha256 "12b83492c6239ce32ff5eed6d3639d6a536170723c6f3f1506869f1ace413398"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/b4/56/9ab5868f34ab2657fba7e2192f41316252ab04edbbeb2a8583759960a1a7/prompt_toolkit-3.0.20.tar.gz"
    sha256 "eb71d5a6b72ce6db177af4a7d4d7085b99756bf656d98ffcc4fecd36850eea6c"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
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
