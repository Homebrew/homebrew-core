class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/aa/a7/881b66594477795314e4a5029f098eb78cf21c843b63bed8d3c7cfcf5fe4/onionprobe-1.2.0.tar.gz"
  sha256 "65ef77047e2cb24de999dcfeeb759de04f6ec952612a5aa9225dc92488696dc5"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fa47dfdbf20b8ce16af33bf25d736fe325c94ac229d2c204dee9d42f5f220e50"
    sha256 cellar: :any,                 arm64_ventura:  "aecd88c6792577c164b8f0249eca91a52189e452283829664a8355143d1e63d2"
    sha256 cellar: :any,                 arm64_monterey: "63828afc60cf78eab114ae8a9a4c5732264c0894492ced10138a05dd0524764c"
    sha256 cellar: :any,                 sonoma:         "95978575565bf1bbafff298b5df87ae0fbf2a2b70bc25baf0c8d654098f26c98"
    sha256 cellar: :any,                 ventura:        "56c4b4b0719895a42ad43e2de27f7c90db0c596fa3affee78a7ef63c704c67e4"
    sha256 cellar: :any,                 monterey:       "05af99247a980adf40c4793bfcc57f6decbc649f300d5b99946b51511d06ad2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7eaff246054a8f569b83bd3c1c5de206613ef61c03eddc6498997ae59786dc39"
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
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
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
