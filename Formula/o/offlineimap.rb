class Offlineimap < Formula
  include Language::Python::Virtualenv

  desc "Synchronizes emails between two repositories"
  homepage "https://github.com/OfflineIMAP/offlineimap3"
  url "https://github.com/OfflineIMAP/offlineimap3/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "82ce54136465ea1cce62f4e961e8c155ac3eee2149fa812763629448902d7d69"
  license "GPL-2.0-or-later"
  head "https://github.com/OfflineIMAP/offlineimap3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f251f42c4fa68a9fbc3f3b8778f96d5b64753cd5f9c1ca0c3d8ed563239f3acf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f251f42c4fa68a9fbc3f3b8778f96d5b64753cd5f9c1ca0c3d8ed563239f3acf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f251f42c4fa68a9fbc3f3b8778f96d5b64753cd5f9c1ca0c3d8ed563239f3acf"
    sha256 cellar: :any_skip_relocation, sonoma:        "965d0ae92184e0f04e1739fef4fff253affbced651c03646b777d0b360d4c869"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "965d0ae92184e0f04e1739fef4fff253affbced651c03646b777d0b360d4c869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "965d0ae92184e0f04e1739fef4fff253affbced651c03646b777d0b360d4c869"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  uses_from_macos "krb5"

  pypi_packages exclude_packages: "certifi"

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "imaplib2" do
    url "https://files.pythonhosted.org/packages/e4/1a/4ccb857f4832d2836a8c996f18fa7bcad19bfdf1a375dfa12e29dbe0e44a/imaplib2-3.6.tar.gz"
    sha256 "96cb485b31868a242cb98d5c5dc67b39b22a6359f30316de536060488e581e5b"

    # Fix warnings with Python 3.12+.
    patch do
      url "https://github.com/jazzband/imaplib2/commit/da0097f6b421c4b826416ea09b4802c163391330.patch?full_index=1"
      sha256 "ff60f720cfc61bfee9eec0af4d79d307e3a8703e575a19c18d05ef3477cf3a64"
    end
  end

  resource "rfc6555" do
    url "https://files.pythonhosted.org/packages/f6/4b/24f953c3682c134e4d0f83c7be5ede44c6c653f7d2c0b06ebb3b117f005a/rfc6555-0.1.0.tar.gz"
    sha256 "123905b8f68e2bec0c15f321998a262b27e2eaadea29a28bd270021ada411b67"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/76/d9/bbbafc76b18da706451fa91bc2ebe21c0daf8868ef3c30b869ac7cb7f01d/urllib3-1.25.11.tar.gz"
    sha256 "8d7eaa5a82a1cac232164990f04874c594c9453ec55eef02eab885aa02fc17a2"
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
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    system bin/"offlineimap", "--version"
  end
end
