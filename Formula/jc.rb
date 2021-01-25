class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/e1/7f/eda44d7d881bd0356038382741bacd93ff93546c75a8a2af0271f882ff6e/jc-1.14.1.tar.gz"
  sha256 "b6bfde3079d4385a643d9eb31c1c554e122ac32e594318363306375b25269473"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "a25ee1525851783426dd349304fc17c4ba253ea94afe2491b998ebfc48a8af57" => :big_sur
    sha256 "2dd7f9b8ebf3e1bd248c70d5c37536edaa211066f87149b9b334998c8319d10b" => :arm64_big_sur
    sha256 "c64f06e2c16d01d2ec7c8cada2594af5c14893413affe2ee054eef60efc59141" => :catalina
    sha256 "14421f56a7db47dc027a0b65ce5bfd468fcf822a5eb2f7f8775069809f965526" => :mojave
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/29/60/8ff9dcb5eac7f4da327ba9ecb74e1ad783b2d32423c06ef599e48c79b1e1/Pygments-2.7.3.tar.gz"
    sha256 "ccf3acacf3782cbed4a989426012f1c535c9a90d3a7fc3f16d231b9372d2b716"
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
