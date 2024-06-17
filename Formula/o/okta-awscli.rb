class OktaAwscli < Formula
  include Language::Python::Virtualenv

  desc "Okta authentication for awscli"
  homepage "https://github.com/okta-awscli/okta-awscli"
  url "https://files.pythonhosted.org/packages/ed/2c/153d8ba330660d756fe6373fb4d1c13b99e63675570042de45aedf300bb7/okta-awscli-0.5.5.tar.gz"
  sha256 "a8b1277914b992fc24e934edaf1947291723ce386f2191a8952e7c008f2e77fa"
  license "Apache-2.0"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2f26c5e6e675f2dd53aaf61b862157fb9a6c8acfc2e34b943f37d90a7e57bb8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d94cc1b9c367d4861a7a4f5f4194a1024314765bfd3d939da032c8345bcf25c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf04a7cf4dbdf8bcc82e2f1853391e8610dda00bb93c0a0c5caca2785a78fc40"
    sha256 cellar: :any_skip_relocation, sonoma:         "a284d80bbfbb2e12670637e8898e91dad9d60649786fb0841ce5810850354f87"
    sha256 cellar: :any_skip_relocation, ventura:        "ec7e0a8843263b1b9963da41dea0ca50a7ed92cd5a06f8d264492b8a3fcbf8d8"
    sha256 cellar: :any_skip_relocation, monterey:       "19ab6ca92784b1c3e7c4171ca7a4a0a4f262caf0737e0beed3ff0f527d4d6772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2cc5a9804f0f35d8afb320e66b37e0fbf8f9c2172e20b25d6d3e275720c79fda"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/f2/09/fe22f1a2704edbf370ffa0093e23ffb3fb78704f2e65989d0ba79a41687d/boto3-1.34.110.tar.gz"
    sha256 "83ffe2273da7bdfdb480d85b0705f04e95bd110e9741f23328b7c76c03e6d53c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/68/21/3186c501d87a83dcc1b3df12c9112ee494033c1ed7c051e72414ba6a3212/botocore-1.34.110.tar.gz"
    sha256 "b2c98c40ecf0b1facb9e61ceb7dfa28e61ae2456490554a16c8dbf99f20d6a18"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/fd/1d/a0f55c373f80437607b898956518443b9edd435b5a226392a9ef11d79fa0/configparser-7.0.0.tar.gz"
    sha256 "af3c618a67aaaedc4d689fd7317d238f566b9aa03cae50102e92d7f0dfe78ba0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/86/ec/535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392db/requests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/83/bc/fb0c1f76517e3380eb142af8a9d6b969c150cfca1324cea7d965d8c66571/s3transfer-0.10.1.tar.gz"
    sha256 "5683916b4c724f799e600f41dd9e10a9ff19871bf87623cc8f491cb4f5fa0a19"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/dc/2e/f07c5391802a08c442ac5b80e254e92354a91f8eb85de6cef40b883c8b3e/validators-0.28.1.tar.gz"
    sha256 "5ac88e7916c3405f0ce38ac2ac82a477fcf4d90dbbeddd04c8193171fc17f7dc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/okta-awscli 2>&1", 1)
      ERROR - The app-link is missing. Will try to retrieve it from Okta
      ERROR - No profile found. Please define a default profile, or specify a named profile using `--okta-profile`
    EOS
  end
end
