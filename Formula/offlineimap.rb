class Offlineimap < Formula
  include Language::Python::Virtualenv

  desc "Synchronizes emails between two repositories"
  homepage "https://github.com/OfflineIMAP/offlineimap3"
  url "https://github.com/OfflineIMAP/offlineimap3/archive/v8.0.0.tar.gz"
  sha256 "5d40c163ca2fbf89658116e29f8fa75050d0c34c29619019eee1a84c90fcab32"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/OfflineIMAP/offlineimap3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab3fae7e96d819b5a576dab660a43438c93ad4f8f0137e29dc07f93add6d76c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35280d4036bda75925c508f8edcf53e7b9431165071a1391b5fc024fe527f374"
    sha256 cellar: :any_skip_relocation, monterey:       "99a7aabd972badba906e4430609217c5f03f5267cc76d4eb349ca327487ba549"
    sha256 cellar: :any_skip_relocation, big_sur:        "e53430590b20390cae4f5c291ed585fca5ecb23d06a6d47e27213bc66af76098"
    sha256 cellar: :any_skip_relocation, catalina:       "c204ddc3b02a6f1bfd747610baa696d70ed02710e336f902f7d53a4610325632"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad8cd71fc09acdcf59cdcc3ddb58e500e032c33975e61b3c5296122a08b4f4d8"
  end

  depends_on "python@3.10"

  uses_from_macos "krb5"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/92/3c/34f8448b61809968052882b830f7d8d9a8e1c07048f70deb039ae599f73c/decorator-5.1.0.tar.gz"
    sha256 "e59913af105b9860aa2c8d3272d9de5a56a4e608db9a2f167a8480b323d529a7"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/a5/26/256fa167fe1bf8b97130b4609464be20331af8a3af190fb636a8a7efd7a2/distro-1.6.0.tar.gz"
    sha256 "83f5e5a09f9c5f68f60173de572930effbcc0287bb84fdc4426cb4168c088424"
  end

  resource "gssapi" do
    url "https://files.pythonhosted.org/packages/e4/4d/03fcc6a2d052920336069df97866d7b506556ed9f3a5ee2ca1e0cbad45d4/gssapi-1.7.2.tar.gz"
    sha256 "748efbcf7cfb31183cd75e5314493e79fe3521b3ec00d090a77e23f7c75fa59d"
  end

  resource "imaplib2" do
    url "https://files.pythonhosted.org/packages/e4/1a/4ccb857f4832d2836a8c996f18fa7bcad19bfdf1a375dfa12e29dbe0e44a/imaplib2-3.6.tar.gz"
    sha256 "96cb485b31868a242cb98d5c5dc67b39b22a6359f30316de536060488e581e5b"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/38/2e/32172e8418f2ba284cee4fd67cb547d39a7debb3eed37d514da173786112/portalocker-2.3.2.tar.gz"
    sha256 "75cfe02f702737f1726d83e04eedfa0bda2cc5b974b1ceafb8d6b42377efbd5f"
  end

  resource "rfc6555" do
    url "https://files.pythonhosted.org/packages/f6/4b/24f953c3682c134e4d0f83c7be5ede44c6c653f7d2c0b06ebb3b117f005a/rfc6555-0.1.0.tar.gz"
    sha256 "123905b8f68e2bec0c15f321998a262b27e2eaadea29a28bd270021ada411b67"
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
