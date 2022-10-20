class OscCli < Formula
  include Language::Python::Virtualenv

  desc "Official Outscale CLI providing connectors to Outscale API"
  homepage "https://github.com/outscale/osc-cli"
  url "https://files.pythonhosted.org/packages/e2/d3/2ff474be2543a868df1415f7a722d1b28016ee521982268e00b575adf0b9/osc-sdk-1.8.0.tar.gz"
  sha256 "a4184cf708f1b42017d40b441463c87dbdfba5a6b6660a032e7cdc250ac3bea5"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32417d2f2c88dc1690341db7838b2ae380e25aca2a849ca7c3744ca659d0b141"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d338e458b7184eead64e45060a043c257df86ce6934b432c8c59ae61f42b916"
    sha256 cellar: :any_skip_relocation, monterey:       "b79f941d9c366b15699946917b44f8875463a1acccfb49d58a4abc209c30141b"
    sha256 cellar: :any_skip_relocation, big_sur:        "be5591b09025c454abf09b390da55dfa218e1b5c0d763a158115bbd95de58e2e"
    sha256 cellar: :any_skip_relocation, catalina:       "39cb5bbf36b5cf582aa571c73f86f8a299b4987bc5f83029d352de7ac86f7259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf3c9cea4f1264a10f4335a2d567d763387354cf33ccbceacf8736b38c86721b"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
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
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
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
          "region_name": "eu-west-2"
        }
      }
    EOS

    str = shell_output("#{bin}/osc-cli api ReadVms 2>&1 >/dev/null", 1)
    match = "raise OscApiException(http_response)"
    assert_match match, str
  end
end
