class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/3c/14/41440102691264714148c55c29e7220cbd7ee11c2c06617693377ccabb94/jc-1.15.6.tar.gz"
  sha256 "249ea24e16e324eab35caae2b9ddd31eaf3e0820ef46d587a4fcfd30a9532c17"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "94746819a6038789fa25b500a8c2dd64b9080b396796fb23e69397f55b60f5fd"
    sha256 cellar: :any_skip_relocation, big_sur:       "6ed3658511927c0a7d3c2d9f2ca3ab6b23aa91bae01d4523ca1da5cee37986e9"
    sha256 cellar: :any_skip_relocation, catalina:      "b92b36f428ee87fd7f7235318d33d00c13cdc9f0aa66f1d56cf27a7d7c375aa4"
    sha256 cellar: :any_skip_relocation, mojave:        "f91594ede4ff7bf770bac6279220d2d06517750b345b4cde1eec4e704d3087bf"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/83/59/4f576abb336d30b3d47061717224be714a9dc39c774061c34cb41c1795cf/ruamel.yaml-0.17.10.tar.gz"
    sha256 "106bc8d6dc6a0ff7c9196a47570432036f41d556b779c6b4e618085f57e39e67"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/b7/81/c04fb9be62657d4dce8aa2d99fde258a3af1cd77ec72af525593e9560127/ruamel.yaml.clib-0.2.4.tar.gz"
    sha256 "f997f13fd94e37e8b7d7dbe759088bb428adc6570da06b64a913d932d891ac8d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jc/man/jc.1.gz"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
