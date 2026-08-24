class EvernoteBackup < Formula
  include Language::Python::Virtualenv

  desc "Backup & export all Evernote notes and notebooks"
  homepage "https://github.com/vzhd1701/evernote-backup"
  url "https://files.pythonhosted.org/packages/fe/fb/77e7a39fda8f28b795b91959b963afbbb137221b1d25408514ae0848bbb1/evernote_backup-1.14.0.tar.gz"
  sha256 "d62240730c6444072b2011aa5e63fbd15e2246959324fec3e58f86a3e313a962"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "717b1e25a39c57c663a448b9e68dde21c87c0d00796ffa10f84c7a801be4a72d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c992da3c269d8a6b2db6b31c136adc0d952dd9d7e5bdebb16c2d348e8547190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4383d62c091dfb2c459ac4d30853afccf7342833ee593bed8f0aef27618b59a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "61432071820483f114acfadcc3dd8614ce1955533fd6de1335532a69902ba16b"
    sha256 cellar: :any,                 arm64_linux:   "a1274c653e507e1d967e5040acf4d03fce729092bae8dfc026d9b9eae9324db8"
    sha256 cellar: :any,                 x86_64_linux:  "85513daf62f92c6e795863e04ea334107e9f2e4c7180b0eccfb58dcff0f694ad"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   %w[pycryptodome keyring]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/b9/9f/1f917934da4e07ae7715a982347e3c2179556d8a58d1108c5da3e8f09c76/click_option_group-0.5.7.tar.gz"
    sha256 "8dc780be038712fc12c9fecb3db4fe49e0d0723f9c171d7cda85c20369be693c"
  end

  resource "evernote-plus" do
    url "https://files.pythonhosted.org/packages/d8/e8/d43bebb6f532598c98a11d07d2c9a114bd11ba780dc40b1d74f7466926a9/evernote_plus-1.28.1.dev2.tar.gz"
    sha256 "fb5e2e6785814205e623bc70c3a1b5abb47dc90a3a7ff28b3d3b0dbc5fb31881"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/8e/a6/8452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5/pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "requests-sse" do
    url "https://files.pythonhosted.org/packages/a1/57/91c3be234a531164786622f74aed74610125cfa1a9e3b707df417479673e/requests_sse-0.5.1.tar.gz"
    sha256 "42df8ad8b8428a44b3f27d2501b68d3f2dd6eaa8cf4cc82e9e53cc3d18eea9cd"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "thrift" do
    url "https://files.pythonhosted.org/packages/33/1c/418058b4750176b638ab60b4d5a554a2969dcd2363ae458519d0f747adff/thrift-0.21.0.tar.gz"
    sha256 "5e6f7c50f936ebfa23e924229afc95eb219f8c8e5a83202dd4a391244803e402"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    without = %w[pycryptodome keyring] unless OS.mac?
    virtualenv_install_with_resources(without:)

    generate_completions_from_executable(bin/"evernote-backup", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/evernote-backup init-db 2>&1", 1)
    assert_match "Logging in to Evernote...", output
    assert_match "OAuth requires user input!", output

    assert_match version.to_s, shell_output("#{bin}/evernote-backup --version")
  end
end
