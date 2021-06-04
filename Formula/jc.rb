class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/63/27/61bd99eb1ac86a187b55bcb81b0619d94d9c80724035796857e236e9e7a2/jc-1.15.5.tar.gz"
  sha256 "50862ddd7473c89b42ad84c63d7b56941c87982a14611e42e55549f7bf75ca61"
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
    url "https://files.pythonhosted.org/packages/62/cf/148028462ab88a71046ba0a30780357ae9e07125863ea9ca7808f1ea3798/ruamel.yaml-0.17.4.tar.gz"
    sha256 "44bc6b54fddd45e4bc0619059196679f9e8b79c027f4131bb072e6a22f4d5e28"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
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
