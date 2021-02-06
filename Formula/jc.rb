class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/8d/29/86df73f51b814001b4145550bfa0bacc7ff6e76706fb347748c158e93363/jc-1.14.2.tar.gz"
  sha256 "e872986ba158b83ebaca204ab2f249e8dadb4b4761925cccaf090d61f391cd2d"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2dd7f9b8ebf3e1bd248c70d5c37536edaa211066f87149b9b334998c8319d10b"
    sha256 cellar: :any_skip_relocation, big_sur:       "a25ee1525851783426dd349304fc17c4ba253ea94afe2491b998ebfc48a8af57"
    sha256 cellar: :any_skip_relocation, catalina:      "c64f06e2c16d01d2ec7c8cada2594af5c14893413affe2ee054eef60efc59141"
    sha256 cellar: :any_skip_relocation, mojave:        "14421f56a7db47dc027a0b65ce5bfd468fcf822a5eb2f7f8775069809f965526"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/e1/86/8059180e8217299079d8719c6e23d674aadaba0b1939e25e0cc15dcf075b/Pygments-2.7.4.tar.gz"
    sha256 "df49d09b498e83c1a73128295860250b0b7edd4c723a32e9bc0d295c7c2ec337"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/17/2f/f38332bf6ba751d1c8124ea70681d2b2326d69126d9058fbd9b4c434d268/ruamel.yaml-0.16.12.tar.gz"
    sha256 "076cc0bc34f1966d920a49f18b52b6ad559fbe656a0748e3535cf7b3f29ebf9e"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "[{\"header1\": \"data1\", \"header2\": \"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
