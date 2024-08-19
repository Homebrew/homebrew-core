class Offlineimap < Formula
  include Language::Python::Virtualenv

  desc "Synchronizes emails between two repositories"
  homepage "https://github.com/OfflineIMAP/offlineimap3"
  url "https://github.com/OfflineIMAP/offlineimap3/archive/refs/tags/v8.0.0.tar.gz"
  sha256 "5d40c163ca2fbf89658116e29f8fa75050d0c34c29619019eee1a84c90fcab32"
  license "GPL-2.0-or-later"
  revision 2
  head "https://github.com/OfflineIMAP/offlineimap3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccb4479d4be8fdf3b4b15b9f91e1b6adc8cbb30f18189bf8d4cbfe3c7013b8b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24480ffd04cc2282d8a3f4d763830341ed778850d8663862a8f37f29254e4058"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19cd11b4864737a1ae8f75048927607a13473d32eab8cfdf9e19b65c4d4d3e3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "baf304b663b31078537c1866cf63eaabd4643a3a411559fef5b956f5b96f6b31"
    sha256 cellar: :any_skip_relocation, ventura:        "e608ef6c6e7aab63c97e00037550751930ed800f8f4d6ce4a78bb7da59eaa0da"
    sha256 cellar: :any_skip_relocation, monterey:       "63950ac1e3a2128c00f023a6bbdec721ccb09400e95af2f8cdec2e9dca19d344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b766baf87346f866beb069dcab5196176bfc24dea657ee1b42ea32e5422dc445"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  uses_from_macos "krb5"

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "gssapi" do
    url "https://files.pythonhosted.org/packages/13/e7/dd88180cfcf243be62308707cc2f5dae4c726c68f30b9367931c794fda16/gssapi-1.8.3.tar.gz"
    sha256 "aa3c8d0b1526f52559552bb2c9d2d6be013d76a8e5db00b39a1db5727e93b0b0"
  end

  resource "imaplib2" do
    url "https://files.pythonhosted.org/packages/e4/1a/4ccb857f4832d2836a8c996f18fa7bcad19bfdf1a375dfa12e29dbe0e44a/imaplib2-3.6.tar.gz"
    sha256 "96cb485b31868a242cb98d5c5dc67b39b22a6359f30316de536060488e581e5b"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/ed/d3/c6c64067759e87af98cc668c1cc75171347d0f1577fab7ca3749134e3cd4/portalocker-2.10.1.tar.gz"
    sha256 "ef1bf844e878ab08aee7e40184156e1151f228f103aa5c6bd0724cc330960f8f"
  end

  resource "rfc6555" do
    url "https://files.pythonhosted.org/packages/f6/4b/24f953c3682c134e4d0f83c7be5ede44c6c653f7d2c0b06ebb3b117f005a/rfc6555-0.1.0.tar.gz"
    sha256 "123905b8f68e2bec0c15f321998a262b27e2eaadea29a28bd270021ada411b67"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
  end

  # Support python 3.12
  patch do
    url "https://github.com/OfflineIMAP/offlineimap3/commit/b0c75495db9e1b2b2879e7b0500a885df937bc66.patch?full_index=1"
    sha256 "6f22557b8d3bfabc9923e76ade72ac1d671c313b751980493f7f05619f57a8f9"
  end

  patch do
    url "https://github.com/OfflineIMAP/offlineimap3/commit/a1951559299b297492b8454850fcfe6eb9822a38.patch?full_index=1"
    sha256 "64065e061d5efb1a416d43e9f6b776732d9b3b358ffcedafee76ca75abd782da"
  end

  patch do
    url "https://github.com/OfflineIMAP/offlineimap3/commit/4601f50d98cffcb182fddb04f8a78c795004bc73.patch?full_index=1"
    sha256 "a38595f54fa70d3cdb44aec2f858c256265421171a8ec331a34cbe6041072954"
  end

  def install
    virtualenv_install_with_resources

    etc.install "offlineimap.conf", "offlineimap.conf.minimal"
  end

  def caveats
    <<~EOS
      To get started, copy one of these configurations to ~/.offlineimaprc:
      * minimal configuration:
          cp -n #{etc}/offlineimap.conf.minimal ~/.offlineimaprc

      * advanced configuration:
          cp -n #{etc}/offlineimap.conf ~/.offlineimaprc
    EOS
  end

  service do
    run [opt_bin/"offlineimap", "-q", "-u", "basic"]
    run_type :interval
    interval 300
    environment_variables PATH: std_service_path_env
    log_path "/dev/null"
    error_log_path "/dev/null"
  end

  test do
    system bin/"offlineimap", "--version"
  end
end
