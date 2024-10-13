class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/aa/a7/881b66594477795314e4a5029f098eb78cf21c843b63bed8d3c7cfcf5fe4/onionprobe-1.2.0.tar.gz"
  sha256 "65ef77047e2cb24de999dcfeeb759de04f6ec952612a5aa9225dc92488696dc5"
  license "GPL-3.0-or-later"
  revision 2
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "b5e363cb777fbfc7c9ff562a7ec80a06014827dae3ff21872f2d02b37b522712"
    sha256 cellar: :any,                 arm64_sonoma:   "cdfb9df372d603f79f0199b34dd52ea56b50c3eeac82fcaf6425195a34e6f84f"
    sha256 cellar: :any,                 arm64_ventura:  "fdd9303588a11d041e0a0202671e3bca24b7187f9fbbcb481c03f858cbd1757e"
    sha256 cellar: :any,                 arm64_monterey: "f22fc97215648f8c1f40b226da21455a8e8b966d3f7ce71c07b25c90b6c49a66"
    sha256 cellar: :any,                 sonoma:         "ac2bcab751cdc96cdfc977052fecd30f1af16c9cf743631cb672f4c5876a675b"
    sha256 cellar: :any,                 ventura:        "9f2092d7199e249b619af17c3d6e999daaa56ffc17c4cdc918ce9335c7630e20"
    sha256 cellar: :any,                 monterey:       "6d4e949031d9edc6587c68e63dda4093ed16d78e7c015b1a8500f94e987c3cb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb0a88926a5dc48d6ebbf856441556d1b36787ffa442d09c87a1d3491b4a0e58"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"
  depends_on "tor"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/3d/39/3be07741a33356127c4fe633768ee450422c1231c6d34b951fee1458308d/prometheus_client-0.20.0.tar.gz"
    sha256 "287629d00b147a32dcb2be0b9df905da599b2d82f80377083ec8463309a4bb89"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/onionprobe --version")

    output = shell_output("#{bin}/onionprobe -e 2gzyxa5ihm7nsggfxnu52rck2vv4rvmdlkiu3zzui5du4xyclen53wid.onion 2>&1")
    assert_match "Status code is 200", output
  end
end
