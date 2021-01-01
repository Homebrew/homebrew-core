class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/28/da/b60b06b0158a6e651706facfc500b2b61bf21046530889ee9c6815de8b31/jc-1.14.0.tar.gz"
  sha256 "562d9c2fdd44786b88ddac879617c4c7eeb0e05b854fc4743c7394e7a756a6c5"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ff41c2b25d668eb53b205f2647d21d80ab5937c89fccc17d792adbf1c43666da" => :big_sur
    sha256 "48882549e16ca4736e5571ea0d84e2a6adef1b1cef6a7116eb4691b95abaca0c" => :arm64_big_sur
    sha256 "313688f0f20b532ca13557cfc17646733742138f140b17453c7485a32f1f2048" => :catalina
    sha256 "fe818b492817a0d857121ca5170ce693c141c796d4c4fd7b99f172fe5077a5ae" => :mojave
    sha256 "bd3fe1005d4773d72ce992685c86fbe5114d3660638c26bb024fc0be45aec0e7" => :high_sierra
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
