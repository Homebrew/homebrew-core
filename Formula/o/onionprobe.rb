class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/9d/5f/c685af3ff4b8833f961ba27c12506c835150710ca84afd37847897be84d9/onionprobe-1.1.2.tar.gz"
  sha256 "200a31ab2c8b1f6bafec1828a4e3b374d01fc80a8fefd9f75698b70cb6d04903"
  license "GPL-3.0-or-later"
  revision 1
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "faf9724f520fe25602a63dc0eeee17091e7213fe26be1359d8c0be5d45dcb08d"
    sha256 cellar: :any,                 arm64_ventura:  "c0d0e3ed019f40004af5c7e8e85b85030e2f68da054474080a9e4105f95d8909"
    sha256 cellar: :any,                 arm64_monterey: "febf38067b2fddff2e8f2925b540d6b360e79e5e38471ced0a51416afcaf95a1"
    sha256 cellar: :any,                 sonoma:         "76a3dd7fbbf00dd77d495bdca9341c9354c394cb8c529c1a91ebd419b7d82ae6"
    sha256 cellar: :any,                 ventura:        "1e8a87eb802f01638808336971bd5b76abb79bc5becfd9721eb1cc4d65796729"
    sha256 cellar: :any,                 monterey:       "6d1c465db61749e27bfea9f3468c14b8b7b8b0a35bf3e7bf54de18eb0fd03170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "601b9287417aface80a01cf2d57fe44cf5e7d6abe2efb7d1a253629b084e4cf8"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "tor"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
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
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
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
