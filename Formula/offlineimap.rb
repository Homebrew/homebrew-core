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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d4165e941468399fa4990253ebc0a2f2eb7d7af8e88da8862b9c8c433f667e59"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f25420ab2c8efe5c0b5ac9223d1e49de090c3e5d5d7274ef11ed627114f4610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c26406e257f2211984f3e92e9c09f20c6c385fb7b1944ba87272d67a155ffb3"
    sha256 cellar: :any_skip_relocation, ventura:        "4e78e8faee9f701117fe5fac7e19a5bae79bad80ce5f5fc4cb3c4db6ef2877ca"
    sha256 cellar: :any_skip_relocation, monterey:       "04b485b04b07a1cca16998214493d1694c7b4c385be249690cc1d0a3d7c636fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1eb38896c12bd4dca38c8499e989b016831e16b3a2dcd532c8137cda027861a0"
    sha256 cellar: :any_skip_relocation, catalina:       "b3b0e6de67b3b9f32ede8cbc78d1af4872df68cbfac59dde180b6174a7b99fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d1d86aadc53a67390d6077c40de359b8d9bf67a06be8119d856c7dcd4f6a109"
  end

  depends_on "python-certifi"
  depends_on "python@3.11"

  uses_from_macos "krb5"

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/4b/89/eaa3a3587ebf8bed93e45aa79be8c2af77d50790d15b53f6dfc85b57f398/distro-1.8.0.tar.gz"
    sha256 "02e111d1dc6a50abb8eed6bf31c3e48ed8b0830d1ea2a1b78c61765c2513fdd8"
  end

  resource "gssapi" do
    url "https://files.pythonhosted.org/packages/27/71/5110b5af9354e5eb66a30dbaa6bac2a5e3013057120544830a849dbd087b/gssapi-1.8.2.tar.gz"
    sha256 "b78e0a021cc91158660e4c5cc9263e07c719346c35a9c0f66725e914b235c89a"
  end

  resource "imaplib2" do
    url "https://files.pythonhosted.org/packages/e4/1a/4ccb857f4832d2836a8c996f18fa7bcad19bfdf1a375dfa12e29dbe0e44a/imaplib2-3.6.tar.gz"
    sha256 "96cb485b31868a242cb98d5c5dc67b39b22a6359f30316de536060488e581e5b"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/a6/5c/57ef8091f9f1d01bf5413fcd0fd1f2f255f45536e42bfd34bc45b6cc2786/portalocker-2.6.0.tar.gz"
    sha256 "964f6830fb42a74b5d32bce99ed37d8308c1d7d44ddf18f3dd89f4680de97b39"
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
