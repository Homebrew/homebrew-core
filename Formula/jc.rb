class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/05/90/0b16cc7c290e838dcf2d1236e25ed0aff73f8a6803714a1ea5d6db202cd2/jc-1.16.2.tar.gz"
  sha256 "6c434a286c3a1cf0af35c7e1ae5a4fcb8be9585171a85605dbaea689380d2def"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fba2bbe08d25cd802a1a9ce0977da12a0c91968251e8e43a9d9fa94ad19beed2"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9f12665257c306ac7a0e1c316fd9aae0363083494274e6d44ef8af143f24440"
    sha256 cellar: :any_skip_relocation, catalina:      "48b6c13cf967d281f034ecebaf11976ed3a99f8fa027aec117775f5317355155"
    sha256 cellar: :any_skip_relocation, mojave:        "a9a7332f540b4cf566a8535404104d24f9ac20bce0c1cebd9597fac76209994e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99a55014beaee3b2e78016e57a0363a0f04b3c4e2de1a0e905ddd2d1344922fa"
  end

  depends_on "python@3.9"

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
