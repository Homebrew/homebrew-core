class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/76/6d/3510650186393a964cb594748e33c6edba23d261ea2e8b9e0dc78aa6d19e/jc-1.17.0.tar.gz"
  sha256 "b6c62020ad770ce4be249a7422044e7eac39130213b0ce63c80746087c34f5f2"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "950d2f985d3d11721a15c5b0e750f13d0400c02fb5a9cff97dbb8c3df68f3123"
    sha256 cellar: :any_skip_relocation, big_sur:       "13b96430280226ce2c59a63dc62db45b44b5ebb117d60c00f02527affbfc04c5"
    sha256 cellar: :any_skip_relocation, catalina:      "9db641ca35ab45421e6d5f00c27092375d973c2cfbd3104112cc719b718143d6"
    sha256 cellar: :any_skip_relocation, mojave:        "7b98e590f9094c97985ca3670047f5580a8a0c78559103e05c30dc32c7ccf935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5d407532c31f8049262f849864d91b3f1194ca6eaced271d7f39d3cbfdea281"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/71/81/f597606e81f53eb69330e3f8287e9b5a3f7ed0481824036d550da705cd82/ruamel.yaml-0.17.16.tar.gz"
    sha256 "1a771fc92d3823682b7f0893ad56cb5a5c87c48e62b5399d6f42c8759a583b33"
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
