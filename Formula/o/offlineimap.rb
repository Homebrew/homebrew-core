class Offlineimap < Formula
  include Language::Python::Virtualenv

  desc "Synchronizes emails between two repositories"
  homepage "https://github.com/OfflineIMAP/offlineimap3"
  url "https://github.com/OfflineIMAP/offlineimap3/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "82ce54136465ea1cce62f4e961e8c155ac3eee2149fa812763629448902d7d69"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/OfflineIMAP/offlineimap3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "89057fbe4e4bd0da45e4b7b015e62e9d5f5b4944251b3f9b1d91370ae0e8644e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "89057fbe4e4bd0da45e4b7b015e62e9d5f5b4944251b3f9b1d91370ae0e8644e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "89057fbe4e4bd0da45e4b7b015e62e9d5f5b4944251b3f9b1d91370ae0e8644e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9888a2ec89503b3b0ccc2b6fea20251edfdf4d4c1f9f48e7bff8a0b14bd129e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9888a2ec89503b3b0ccc2b6fea20251edfdf4d4c1f9f48e7bff8a0b14bd129e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9888a2ec89503b3b0ccc2b6fea20251edfdf4d4c1f9f48e7bff8a0b14bd129e3"
  end

  depends_on "certifi"
  depends_on "python@3.14"

  uses_from_macos "krb5"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   "keyring"

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

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/cb/9c/a788f5bb29c61e456b8ee52ce76dbdd32fd72cd73dd67bc95f42c7a8d13c/jaraco_context-6.1.0.tar.gz"
    sha256 "129a341b0a85a7db7879e22acd66902fda67882db771754574338898b2d5d86f"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
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
