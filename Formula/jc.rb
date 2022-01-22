class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/bb/8e/53b53da44626c695fd522a1bacf59dca1c85921873637bc3f1de23e0e0bb/jc-1.18.1.tar.gz"
  sha256 "a115b590c110b7e795c986356f28701d11f3946c7406bebda11feb692a012c29"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69eafcb3dc46c65d6938ac9ca6eeebefe22380652d809f28c6cf1c9d951cfd83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a14ee11d9b35c69d409c53e2d53de5df2d5fad0a9c865324aac791848cce2f62"
    sha256 cellar: :any_skip_relocation, monterey:       "18a512344d6f59c096aa1dc0e46f3d46e0c0b9f74f67ad1ba9fdbacc74bd194f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ae8e8dd91105fac4766eb66062f771f7c0cd88c8dbec68c02eb856d7017805a"
    sha256 cellar: :any_skip_relocation, catalina:       "e5c548190f6e33342656af9154eb54a026d9efc618cd41ec3da6751dfe804de5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d42a88969adbffb8533b86a09022f4af021f6d57783a742d904b66b5cf56f18"
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
