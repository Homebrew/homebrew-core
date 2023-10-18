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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4709f43b926d374d1860141f7775788992b42a62a9c1ef5b7980ed6f688af833"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8fbc9ec6cfdc54f128bfa251834d419f473a4a41848e317b9aac76e3b76eb77"
    sha256 cellar: :any_skip_relocation, ventura:        "6ed0df431c2bf11fe15c9f7b950ffa83bd1d83e58607d837ebfa0b0d0d6395bd"
    sha256 cellar: :any_skip_relocation, monterey:       "5dd577cd3836fef6243cf75e7042bae8cc132b716b7c3b7cf4621a0643fdee39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0989a516c22bd501011ca86e6a119f1f011f8d3c2b9b3e77e309a74f65b2424"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "tor"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/f5/05/aee33352594522c56eb4a4382b5acd9a706a030db9ba2fc3dc38a283e75c/prometheus_client-0.17.1.tar.gz"
    sha256 "21e674f39831ae3f8acde238afd9a27a37d0d2fb5a28ea094f0ce25d2cbf2091"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
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
