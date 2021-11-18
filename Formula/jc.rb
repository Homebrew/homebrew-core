class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/59/31/dddcca4dc264e26bcb9f563f1604f2322e4e0da137bef36ac06e854647b2/jc-1.17.2.tar.gz"
  sha256 "c59fa13d260c15e498a65f56df67fcbc2981d4bf9e64bfd6097496595e0248c9"
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
    url "https://files.pythonhosted.org/packages/4d/15/7fc04de02ca774342800c9adf1a8239703977c49c5deaadec1689ec85506/ruamel.yaml-0.17.17.tar.gz"
    sha256 "9751de4cbb57d4bfbf8fc394e125ed4a2f170fbff3dc3d78abf50be85924f8be"
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
