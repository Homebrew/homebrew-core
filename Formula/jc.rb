class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/0d/ef/6df160feb676fb385129cf92461f4cbe8ad9bc3b35b0377d468f048956d9/jc-1.17.4.tar.gz"
  sha256 "f8c662eec683717e91226b9ea1331549fdfdef125cf61a6a5f9c59b37e7407c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc6c8f5cee0f18c56e911fb013a7595c016dd73a76d673270817880e6cee9c8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc6c8f5cee0f18c56e911fb013a7595c016dd73a76d673270817880e6cee9c8b"
    sha256 cellar: :any_skip_relocation, monterey:       "18dfb467d7a5e04aaae6726b9eed5051ee804c940fdb09a656492b0a46dce8a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "18dfb467d7a5e04aaae6726b9eed5051ee804c940fdb09a656492b0a46dce8a7"
    sha256 cellar: :any_skip_relocation, catalina:       "18dfb467d7a5e04aaae6726b9eed5051ee804c940fdb09a656492b0a46dce8a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c90bd9bc57fd4af8b373360a322f36867d0a6980669a8ae2649c1d4ea6764c"
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
