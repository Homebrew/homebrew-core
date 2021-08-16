class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/bb/1a/70b410cc4b88c5f5b969fab6eb351eccefd785329f28d6efc8bd07aa151f/jc-1.16.1.tar.gz"
  sha256 "42cacd058baed7692f5644c8eb4b8ea120969420675d86c2d26b224df79cb169"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b9f8276a4e94f464dcd71e687e02635f8b93679fbd7897bad0f83debf6e33aa1"
    sha256 cellar: :any_skip_relocation, big_sur:       "1097379cd2764a042d73781e1a419acd33863c08b4e9d4f045d4ae91bbf80774"
    sha256 cellar: :any_skip_relocation, catalina:      "4903ad32d09dff2c009bba304783167bb92873014c23d3a3ede92109d7e6d660"
    sha256 cellar: :any_skip_relocation, mojave:        "881b22acd422ef4b6d6fb4ba912d03beb88924b15865fa0717f5f3f04829cb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14acf5a1e6695470a073a055c4931540215a974b98cadef00fde6858cd549447"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/83/59/4f576abb336d30b3d47061717224be714a9dc39c774061c34cb41c1795cf/ruamel.yaml-0.17.10.tar.gz"
    sha256 "106bc8d6dc6a0ff7c9196a47570432036f41d556b779c6b4e618085f57e39e67"
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
