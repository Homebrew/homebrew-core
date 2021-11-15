class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https://github.com/outscale/osc-cli"
  url "https://files.pythonhosted.org/packages/7d/85/7682a1deb551d4350f47ccc5f99d333088f99edf376844f3c94581e26b8b/osc-sdk-1.7.0.tar.gz"
  sha256 "58e76cec711e12f24d31b86519485e24749c14269090317876e195d00ae4b945"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "08d9096ef7d4a12e2469671ccdf87c895c89fdac9cfbeb8dc3e9c0f71ae212e0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a27396f6b582aef25ab4eae8fe2e0c846cb6abb5c8d1b84b58502ce6d72a4dc3"
    sha256 cellar: :any_skip_relocation, monterey:       "672ee9b095c11394fee8c99565d4bfe3fbd47da181d17a5f9501265c643e166d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc7cfdf2b505aa6d0986304c8e250ad7cfe92f6fe2f408776a686d454e9c99ca"
    sha256 cellar: :any_skip_relocation, catalina:       "83603ad1d2f7b999043cbe5940ff8fd07eb32168655b3283fc47db8583293b06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c145906b08f8dd70efcc4b57396b4d7ea40be4afa35fccc8f91e95b164783e7f"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fire" do
    url "https://files.pythonhosted.org/packages/11/07/a119a1aa04d37bc819940d95ed7e135a7dcca1c098123a3764a6dcace9e7/fire-0.4.0.tar.gz"
    sha256 "c5e2b8763699d1142393a46d0e3e790c5eb2f0706082df8f647878842c216a62"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    # we test the help wich is printed in stderr :(
    str = shell_output("#{bin}/osc-cli -- --help 2>&1 >/dev/null")
    assert_match "osc-cli \e[4mSERVICE\e[0m \e[4mCALL\e[0m <flags>", str
    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    assert_match "No configuration file found in home folder", str

    mkdir testpath/".osc"
    (testpath/".osc/config.json").write <<~EOS
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
    match = "TypeError: OscApiException.__post_init__() missing 1 required positional argument: 'http_response'"
    assert_match match, str
  end
end
