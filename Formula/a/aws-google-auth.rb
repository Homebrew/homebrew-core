class AwsGoogleAuth < Formula
  include Language::Python::Virtualenv

  desc "Acquire AWS credentials using Google Apps"
  homepage "https://github.com/cevoaustralia/aws-google-auth"
  url "https://files.pythonhosted.org/packages/32/4c/3a1dd1781c9d3bb4a85921b3d3e6e32fc0f0bad61ace6a8e1bd1a59c5ba0/aws-google-auth-0.0.38.tar.gz"
  sha256 "7a044636df2f0ce6ceb01f8f57aba0b6a79ae58a91bef788b0ccc6474914e8ee"
  license "MIT"
  revision 10
  head "https://github.com/cevoaustralia/aws-google-auth.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "905278b5c626b804f42c611543def9fd30eabd77d6a2f0f814fc73ec618f2d2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3695bdb3ad7d3ae3f68b775a89bea34986db7b97f2bf0e506e2eee733d1bcf55"
    sha256 cellar: :any,                 arm64_monterey: "20360f27efd652c41a9c423ae14432ccc4f6cc99c65d3b3afaf97e5e1651faa8"
    sha256 cellar: :any_skip_relocation, sonoma:         "1b29cebeb9a79aaa6505820c1e40ee36cae451e2371288cff5b33d1dc953cb19"
    sha256 cellar: :any_skip_relocation, ventura:        "f678a56dcc3b76f82078504bf4d75b31eec0b02263d5029528f8716a5670edd2"
    sha256 cellar: :any,                 monterey:       "5521059aa9713610b436feb38692e2a02484c4d8ca502ff7b464369865543c09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69268e5c2d59ab06822ac6605ec8a275c15f72a01dd0856cb2833e65416de6de"
  end

  depends_on "certifi"
  depends_on "pillow"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "cryptography"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/46/6d/8f361c95d4f948dae469a3072cf998f62300ca3bc1a311c1c029a2793313/boto3-1.34.83.tar.gz"
    sha256 "9733ce811bd82feab506ad9309e375a79cabe8c6149061971c17754ce8997551"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0c/b8/6d1ec4802de76d21851784ca2b1d26575f193c31ebd194a196d08dac0d0d/botocore-1.34.83.tar.gz"
    sha256 "0f302aa76283d4df62b4fbb6d3d20115c1a8957fc02171257fc93904d69d5636"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/82/97/930be4777f6b08fc7c248d70c2ea8dfb6a75ab4409f89abc47d6cab37d39/configparser-6.0.1.tar.gz"
    sha256 "db45513e971e509496b150be31bd67b0e14ab20b78a383b677e4b158e2c682d8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/ff/877f1dbe369a2b9920e2ada3c9ab81cf6fe8fa2dce45f40cad510ef2df62/filelock-3.13.4.tar.gz"
    sha256 "d13f466618bfde72bd2c18255e269f72542c6e70e7bac83a0232d6b1cc5c8cf4"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/c9/60/e83781b07f9a66d1d102a0459e5028f3a7816fdd0894cba90bee2bbbda14/jaraco.context-5.3.0.tar.gz"
    sha256 "c2f67165ce1f9be20f32f650f25d8edfc1646a8aeee48ae06fb35f90763576d2"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/57/7c/fe770e264913f9a49ddb9387cca2757b8d7d26f06735c1bfbb018912afce/jaraco.functools-4.0.0.tar.gz"
    sha256 "c279cb24c93d694ef7270f970d499cab4d3813f4e08273f95398651a634f0925"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/18/ec/cc0afdcd7538d4942a6b78f858139120a8c7999e554004080ed312e43886/keyring-25.1.0.tar.gz"
    sha256 "7230ea690525133f6ad536a9b5def74a4bd52642abe594761028fc044d7c7893"
  end

  resource "keyrings-alt" do
    url "https://files.pythonhosted.org/packages/4f/55/7a52c9961f607353034945692c700ab648f18ea2ab2d509e248b24cb0a91/keyrings.alt-5.0.1.tar.gz"
    sha256 "cd372a1ec446a1bc5a90624a52c88e83b9330218e39047a6c9a48ae37d116745"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/ea/e2/3834472e7f18801e67a3cd6f3c203a5456d6f7f903cfb9a990e62098a2f3/lxml-5.2.1.tar.gz"
    sha256 "3f7765e69bbce0906a7c74d5fe46d2c7a7596147318dbc08e4a2431f3060e306"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/04/d3/c19d65ae67636fe63953b20c2e4a8ced4497ea232c43ff8d01db16de8dc0/tzlocal-5.2.tar.gz"
    sha256 "8d399205578f1a9342816409cc1e46a93ebd5755e39ea2d85334bea911bf0e6e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end
  end

  resource "secretstorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  # Drop distutils for 3.12: https://github.com/cevoaustralia/aws-google-auth/pull/277
  patch do
    url "https://github.com/cevoaustralia/aws-google-auth/commit/43720916af88d485a914c9d35288b23817e2ae3f.patch?full_index=1"
    sha256 "1ba699bbddb2e696282c4ccca693f99501b3e4b648252c890aab4ef98e668d85"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    auth_process = IO.popen "#{bin}/aws-google-auth"
    sleep 10
    Process.kill "TERM", auth_process.pid
    assert_match "AWS Region:", auth_process.read
  end
end
