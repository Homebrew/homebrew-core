class Offlineimap < Formula
  include Language::Python::Virtualenv

  desc "Synchronizes emails between two repositories"
  homepage "https://github.com/OfflineIMAP/offlineimap3"
  url "https://github.com/OfflineIMAP/offlineimap3/archive/refs/tags/v8.0.2.tar.gz"
  sha256 "c299cbbab92d48215ea37ec06ec68699d17e59ab97a1b98e792f75e0a507b306"
  license "GPL-2.0-or-later"
  head "https://github.com/OfflineIMAP/offlineimap3.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47c364fb81fe40a2118707e9bf9b7761a05733a925167597e2696fd1b98a0f07"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "47c364fb81fe40a2118707e9bf9b7761a05733a925167597e2696fd1b98a0f07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47c364fb81fe40a2118707e9bf9b7761a05733a925167597e2696fd1b98a0f07"
    sha256 cellar: :any_skip_relocation, sonoma:        "01573f83d5463c999e6340dd61caaf870acb6f710aa164f32a718b92e101f89d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01573f83d5463c999e6340dd61caaf870acb6f710aa164f32a718b92e101f89d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01573f83d5463c999e6340dd61caaf870acb6f710aa164f32a718b92e101f89d"
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
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
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
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
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
    log_path File::NULL
    error_log_path File::NULL
  end

  test do
    system bin/"offlineimap", "--version"
  end
end
