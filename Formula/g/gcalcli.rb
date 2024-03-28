class Gcalcli < Formula
  include Language::Python::Virtualenv

  desc "Easily access your Google Calendar(s) from a command-line"
  homepage "https://github.com/insanum/gcalcli"
  url "https://files.pythonhosted.org/packages/e8/d9/9d1f03b9b47c3082bf664a2f789a3aded0674dca9e0b894540d754b937cc/gcalcli-4.3.0.tar.gz"
  sha256 "d00081460276027196e8fb957880b29ba4f22ea43136f9e232a9408016abc110"
  license "MIT"
  revision 6
  head "https://github.com/insanum/gcalcli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae95e0f7cae814d88512624914db7e363773d1417145a1219292f20a7c43dcd4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85c2b388bc5e4ce6c99e6c47d4ce989cae40b838454b18ca83f2c2898dc113dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aba06f94c7a1b61e5daa14a0dc846f590f8ea18edd48463127a749568cb625b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "d3b6b5bf1565f2e4a2d1f512a1abfc4efd0c6c3da10e97113bbd441b1e3207db"
    sha256 cellar: :any_skip_relocation, ventura:        "6ea05bad0d736dc06ba26c082f92817e299048ef72a3851469d765261886543c"
    sha256 cellar: :any_skip_relocation, monterey:       "06c51ec681a912ee5f4a0c1353a495f667a9caa98fdab1233bfe6fc820e98ea3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1535bd3438d95af783b6b0bf9a90ed7edb1d8c70946e8fbf861ef11dfb95872c"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/10/21/1b6880557742c49d5b0c4dcf0cf544b441509246cdd71182e0847ac859d5/cachetools-5.3.2.tar.gz"
    sha256 "086ee420196f7b2ab9ca2db2520aca326318b68fe5ba8bc4d49cca91add450f2"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/58/e2/c2ce7bf379a7200ecab7de2cbf17dcbb3fe2ab5085925dfe6797e263a475/google-api-core-2.17.1.tar.gz"
    sha256 "9df18a1f87ee0df0bc4eea2770ebc4228392d8cc4066655b320e2cfccb15db95"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/e4/6c/6258d89feb950462d44a868b0aa58034f5cd00a10bd99fc1f379ef9494fb/google-api-python-client-2.118.0.tar.gz"
    sha256 "ebf4927a3f5184096647be8f705d090e7f06d48ad82b0fa431a2fe80c2cbe182"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/9a/15/ac42556763c08e1b1821a7e55f3a93982c50ca7f25adf8f61a01dd2ed98b/google-auth-2.28.1.tar.gz"
    sha256 "34fc3046c257cedcf1622fc4b31fc2be7923d9b4d44973d481125ecc50d83885"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/56/be/217a598a818567b28e859ff087f347475c807a5649296fb5a817c58dacef/google-auth-httplib2-0.2.0.tar.gz"
    sha256 "38aa7badf48f974f1eb9861794e9c0cb2a0511a4ec0679b1f886d108f5640e05"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/4a/5f/eb12d721b45d20a977289d674e179995a0ddab1684d2c61b29a63d43a5f1/googleapis-common-protos-1.62.0.tar.gz"
    sha256 "83f0ece9f94e5672cced82f592d2a5edf527a96ed1794f0bab36d5735c996277"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/5e/d8/65adb47d921ce828ba319d6587aa8758da022de509c3862a70177a958844/protobuf-4.25.3.tar.gz"
    sha256 "25b5d0b42fd000320bd7830b349e3b696435f3b329810427a6bcce6a5492cc5c"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ce/dc/996e5446a94627fe8192735c20300ca51535397e31e7097a3cc80ccf78b7/pyasn1-0.5.1.tar.gz"
    sha256 "6d391a96e59b23130a5cfa74d6fd7f388dbbe26cc8f1edf39fdddf08d9d6676c"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/37/fe/65c989f70bd630b589adfbbcd6ed238af22319e90f059946c26b4835e44b/pyparsing-3.1.1.tar.gz"
    sha256 "ede28a1a32462f5a9705e07aea48001a08f7cf81a021585011deba701581a0db"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/gcalcli --client-id=foo --client-secret=bar --noauth_local_webserver list", "foo")
    assert_match "Go to the following link in your browser:", output
  end
end
