class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/3d/8f/d9ac8adbbc13e43c4c8bcc50128c9fef7a04e9bbe0b7a5d5aaeb95b97573/jc-1.17.3.tar.gz"
  sha256 "0ded7234ec0ab648724b1bff78ef71c0b078feed462f2bd2a3e34f3cdf040728"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a03c34cbc14c2d0a0fe8de9f89def99cbf034cf3145ded59f98c16675d85928a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a03c34cbc14c2d0a0fe8de9f89def99cbf034cf3145ded59f98c16675d85928a"
    sha256 cellar: :any_skip_relocation, monterey:       "f3225bb91496fe42657949513089e3d8ee1d1cd67e058f4f26edc606bb25c443"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3225bb91496fe42657949513089e3d8ee1d1cd67e058f4f26edc606bb25c443"
    sha256 cellar: :any_skip_relocation, catalina:       "f3225bb91496fe42657949513089e3d8ee1d1cd67e058f4f26edc606bb25c443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b4a92ad105a1adcfab06c4668f4e34ca3003f024f6ac103ca576e2d76c91abe"
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
