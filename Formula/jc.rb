class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/0f/90/e2764686d6969a959a93ae3f42d2dff2f2e39e6284753c17ca5d442f49a3/jc-1.17.5.tar.gz"
  sha256 "1e3cffd298ffb766d6e56c7595c0eb7913aa3625f9cb6db7b45447fe3ce21c05"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73406daaa115958774006127ad6a2bcfc55994b58acd15aefd450cab66e7d2ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73406daaa115958774006127ad6a2bcfc55994b58acd15aefd450cab66e7d2ba"
    sha256 cellar: :any_skip_relocation, monterey:       "fc3132b22f87e6fd11be7e69c6ae425185b15cdabfc362c7de587db78739cf05"
    sha256 cellar: :any_skip_relocation, big_sur:        "fc3132b22f87e6fd11be7e69c6ae425185b15cdabfc362c7de587db78739cf05"
    sha256 cellar: :any_skip_relocation, catalina:       "fc3132b22f87e6fd11be7e69c6ae425185b15cdabfc362c7de587db78739cf05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc34f0c244ad5e9e773c52f58069f6b77f59b3d3d62d6d4018a64c39c916df7"
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
