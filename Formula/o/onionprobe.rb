class Onionprobe < Formula
  include Language::Python::Virtualenv

  desc "Test and monitoring tool for Tor Onion Services"
  homepage "https://tpo.pages.torproject.net/onion-services/onionprobe/"
  url "https://files.pythonhosted.org/packages/30/d0/6441b228ce174481ace50dec6a19ce6298eebdb35d06f40f7b1de66f51c4/onionprobe-1.4.1.tar.gz"
  sha256 "45c12c89829e344422974aa9d56cc653d1e20a2f225e73ee18aeb995ca47a2be"
  license "GPL-3.0-or-later"
  revision 4
  head "https://gitlab.torproject.org/tpo/onion-services/onionprobe.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ef708b4830dcb88a943f0195399e42fa7205767120f10b40aaa7e8f6c1e649a"
    sha256 cellar: :any,                 arm64_sequoia: "c60241f3136f07ab6b58162bb6a972772307f6734f5354d91abe735fa57bc840"
    sha256 cellar: :any,                 arm64_sonoma:  "c5e0bccca5f32bb4dc3aae6afaf8ded18a4b3a8f4fc718a9107af9307326de9a"
    sha256 cellar: :any,                 sonoma:        "3943e953f309fd8fce62d9ddf826e8801cb002889ae491bd15cf79bf11247fcb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3228c686541b84be207909c917285e545b608f0fed4ad9dc4a8960f6e77b8e90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9c512220b17db1fac0235573106677d205b8f8092d0f63c70037446d0ec64e9d"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "tor"

  pypi_packages exclude_packages: %w[certifi cryptography]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/1b/fb/d9aa83ffe43ce1f19e557c0971d04b90561b0cfd50762aafb01968285553/prometheus_client-0.25.0.tar.gz"
    sha256 "5e373b75c31afb3c86f1a52fa1ad470c9aace18082d39ec0d2f918d11cc9ba28"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "stem" do
    url "https://files.pythonhosted.org/packages/94/c6/b2258155546f966744e78b9862f62bd2b8671b422bb9951a1330e4c8fd73/stem-1.8.2.tar.gz"
    sha256 "83fb19ffd4c9f82207c006051480389f80af221a7e4783000aedec4e384eb582"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
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
