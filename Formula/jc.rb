class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/f9/85/56bbbcb3f77ea788c9a47df38f74e3951cf672c4d399ce78ccab9aea3875/jc-1.14.3.tar.gz"
  sha256 "fce0d6f02556e815ef6b0847e8b697b32e177089673bd61b9d48dc4f64f32585"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "96c3888568a2789546a3be8562b2306597f35e0b9919cecc1476b9ff07c17925"
    sha256 cellar: :any_skip_relocation, big_sur:       "2cd733c855d652097873d6a91e462171cdae1c14530454b1ffe4ff37ce82fb13"
    sha256 cellar: :any_skip_relocation, catalina:      "b1a2fe86d7cb212534015437d94bc137774e4bf89fc260886095afaa5ad80d9d"
    sha256 cellar: :any_skip_relocation, mojave:        "2f76c0e5dd7e88fd5c5c9fda8a5e216612d7c99277e5c89c0097f6c6711bf530"
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
