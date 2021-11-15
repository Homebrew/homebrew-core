class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/5f/90/0183a0bef6b05fd1a68234ea99dab72bde092f4cd83d8b52ad630b26f94a/jc-1.17.1.tar.gz"
  sha256 "946586414bd845c3d50000834d7625c7a057c982a3ceca7ab6edddc7d6a8fb75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03a321152fbe7eba06b103cd5354519713ad64f170c416083bf7169ca73f745a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03a321152fbe7eba06b103cd5354519713ad64f170c416083bf7169ca73f745a"
    sha256 cellar: :any_skip_relocation, monterey:       "fc12659d81cf1c566af9a5af6ea6135fc841c57bfa81ad1257f2208538f3d10a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc12659d81cf1c566af9a5af6ea6135fc841c57bfa81ad1257f2208538f3d10a"
    sha256 cellar: :any_skip_relocation, catalina:       "fc12659d81cf1c566af9a5af6ea6135fc841c57bfa81ad1257f2208538f3d10a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "431a05abea89d4783c8bb138d753f242909a453e93dd23b6a7e250ff124d8025"
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
