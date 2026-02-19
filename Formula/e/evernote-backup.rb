class EvernoteBackup < Formula
  include Language::Python::Virtualenv

  desc "Backup & export all Evernote notes and notebooks"
  homepage "https://github.com/vzhd1701/evernote-backup"
  url "https://files.pythonhosted.org/packages/77/09/021f30d5e05df5587f0621b4144b687d94af331fefa54f5a14b7cd2d80d1/evernote_backup-1.13.1.tar.gz"
  sha256 "564c39cd92633e9e9492346363bd3f85175c15a9f73d5c34d35835a2ef05e197"
  license "MIT"
  revision 4

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a2cd56aff30b3f5a29767f2bd5dbd630041b59f01faa236e1fd1c8e05d2f76bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "606c99385dd2737c635e64f4b1f6e5c98f8a6c53d4376c01adc5f55ddf1bc1eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "491dc145ffe1d9d2e3e7fff83437431b5ef71d706720c0ffa3148064e207e800"
    sha256 cellar: :any_skip_relocation, tahoe:         "093929e8f1eda46f58cebb7b344c7d60ccc117e1a4b6d621d4f9345c208097cb"
    sha256 cellar: :any_skip_relocation, sequoia:       "f561629b6acf9e912327d15ef906b4542ce103e8e8161d2120d1c8d7729fb96d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f48267cceebf144347a5b4d357cd65bfc810ab2ea2f6b31baaf80eff9aa50ba1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82d8dbbf369c581856bfdfc711f85d73f3c8e5e98d2b61d3508f1c0505b49582"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1afd5db279d948b37096cb11383384d345f1a666ed9d4f2cf0154906798dc87"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
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
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
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
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"evernote-backup", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/evernote-backup init-db 2>&1", 1)
    assert_match "Logging in to Evernote...", output
    assert_match "OAuth requires user input!", output

    assert_match version.to_s, shell_output("#{bin}/evernote-backup --version")
  end
end
