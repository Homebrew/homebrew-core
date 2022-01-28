class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/39/96/f0c4f5a619fc9e51feb321c9e77302118d06c7558c0c4ff5f02906cb0036/jc-1.18.2.tar.gz"
  sha256 "1b2af09a3881e65722a112dae2877a01fd3fe4a40144cc3033ebcae78c13619a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a7157fffa1a719ffe2fb00e3643dcee0ccb8406e605c2cc4347c107629564a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "650b2eb961fe10f246cbabe75dcc251ae16802792527bff86b0ad89588c4c50c"
    sha256 cellar: :any_skip_relocation, monterey:       "7ec7633eb27696d5bdd406f734e23b700e1feade47c8e74c0fd4d49bc7726b9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7c26694f396db9aa2fbe634ec15dbde21f7cffb3abb5d40a40b8bd87f54e0b0"
    sha256 cellar: :any_skip_relocation, catalina:       "0904b6564b580ee58da11cb1b6f2653cdd74bd7f4d89f98435d9d8252201d76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1a161970e8cf06125418b6e70f55bc54e6e58b24787385ca966fe2e4d811b983"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/94/9c/cb656d06950268155f46d4f6ce25d7ffc51a0da47eadf1b164bbf23b718b/Pygments-2.11.2.tar.gz"
    sha256 "4e426f72023d88d03b2fa258de560726ce890ff3b630f88c21cbb8b2503b8c6a"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/2d/b1/b672cbe8be9ea09d85d2be8c3693811362295aa8483849e85b41caaadb85/ruamel.yaml-0.17.20.tar.gz"
    sha256 "4b8a33c1efb2b443a93fcaafcfa4d2e445f8e8c29c528d9f5cdafb7cc9e4004c"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/8b/25/08e5ad2431a028d0723ca5540b3af6a32f58f25e83c6dda4d0fcef7288a3/ruamel.yaml.clib-0.2.6.tar.gz"
    sha256 "4ff604ce439abb20794f05613c374759ce10e3595d1867764dd1ae675b85acbd"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
