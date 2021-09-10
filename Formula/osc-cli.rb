class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https://github.com/outscale/osc-cli"
  url "https://files.pythonhosted.org/packages/8c/29/cf68365132a0ac906278abdc704569ce8f1ba4c609a2067cd00c5ed22271/osc-sdk-1.6.tar.gz"
  sha256 "fb312c82c73ed4eba7bbb3a028e4d2f53e00e28c576ff2f638258f27a855e7e7"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f988fcbfdc3d68c240a83d507d8ae548b4411afdc418f468276fcdfd1c3b89ff"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa37225fd72496c7872b08a69c39f027a4d37ec9a810dd5ccbe1ce270b2a5b55"
    sha256 cellar: :any_skip_relocation, catalina:      "aa37225fd72496c7872b08a69c39f027a4d37ec9a810dd5ccbe1ce270b2a5b55"
    sha256 cellar: :any_skip_relocation, mojave:        "aa37225fd72496c7872b08a69c39f027a4d37ec9a810dd5ccbe1ce270b2a5b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76cf5ec7e2a32e0ce9531a178c53f8a1f56005e10c4de3806c5cccb8e54a2d15"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/5a/b7/205702f348aab198baecd1d8344a90748cb68f53bdcd1cc30cbc08e47d3e/fire-0.1.3.tar.gz"
    sha256 "c299d16064ff81cbb649b65988300d4a28b71ecfb789d1fb74d99ea98ae4d2eb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/52/2c/514e4ac25da2b08ca5a464c50463682126385c4272c18193876e91f4bc38/requests-2.21.0.tar.gz"
    sha256 "502a824f31acdacb3a35b6690b5fbf0bc41d63a24a45c4004352b0242707598e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/3c/1bb7ef6c435dea026f06ed9f3ba16aa93f9f4f5d3857a51a35dfa00882f1/urllib3-1.24.3.tar.gz"
    sha256 "2393a695cd12afedd0dcb26fe5d50d0cf248e5a66f75dbd89a3d4eb333a61af4"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/57/17/a6acddc5f5993ea6eaf792b2e6c3be55e3e11f3b85206c818572585f61e1/xmltodict-0.11.0.tar.gz"
    sha256 "8f8d7d40aa28d83f4109a7e8aa86e67a4df202d9538be40c0cb1d70da527b0df"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # we test the help wich is printed in stderr :(
    str = shell_output("#{bin}/osc-cli -- --help 2>&1 >/dev/null")
    assert_match "osc-cli SERVICE CALL [PROFILE] [ARGS ...] [--KWARGS ...]", str
    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    assert_match "No configuration file found in home folder", str

    mkdir testpath/".osc_sdk"
    (testpath/".osc_sdk/config.json").write <<~EOS
      {
        "default": {
          "access_key": "F4K4T706S9XKGEXAMPLE",
          "secret_key": "E4XJE8EJ98ZEJ18E4J9ZE84J19Q8E1J9S87ZEXAMPLE",
          "host": "outscale.com",
          "https": true,
          "method": "POST",
          "region": "eu-west-2"
        }
      }
    EOS

    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    match = "osc_sdk.sdk.OscApiException: Error --> status = 400, code = 4120, Reason = InvalidParameterValue"
    assert_match match, str
  end
end
