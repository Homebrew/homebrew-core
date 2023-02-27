class Prowler < Formula
  include Language::Python::Virtualenv

  desc "Open Source Security tool to perform Cloud Security best practices"
  homepage "https://prowler.pro/"
  url "https://files.pythonhosted.org/packages/ac/9a/fcff7d1ffe0701b579076b91f3c3304618195fbd41348fef20f20cde902d/prowler-3.2.4.tar.gz"
  sha256 "9e9cd14ce987d2843445d598cb26138b7728dc4e7cc5ba29be081154c229c71b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8f2cc577aeaa6274dba0083c60f80191b0c04a47c5e9a478c52a6b12cd2c4a1e"
    sha256 cellar: :any,                 arm64_monterey: "815d07eeb6b88d816c7e9daac108c0360ae9dd5607b936152e84df6895acfafb"
    sha256 cellar: :any,                 arm64_big_sur:  "e15459e692119c346bb74316b23d1878810fdb43fdaed2418d2397ee08f9f37c"
    sha256 cellar: :any,                 ventura:        "c8e44c681cdee470808b7a2e45d86a234d10334f860fa6cdd6057a3cb0856334"
    sha256 cellar: :any,                 monterey:       "e7773691b600a51736bc86927a4f76eb8062c702128a6d5d2b302938d67cb18b"
    sha256 cellar: :any,                 big_sur:        "67299f3c4deff900f5c03fdef5a79ec1932c25bb6082ae785f5db5ce7a97cfb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6f987d002d327eca31fe26428fa16d8e679d331db0b3fba17b3f02e9bcca92d"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "about-time" do
    url "https://files.pythonhosted.org/packages/1c/3f/ccb16bdc53ebb81c1bf837c1ee4b5b0b69584fd2e4a802a2a79936691c0a/about-time-4.2.1.tar.gz"
    sha256 "6a538862d33ce67d997429d14998310e1dbfda6cb7d9bbfbf799c4709847fece"
  end

  resource "alive-progress" do
    url "https://files.pythonhosted.org/packages/ad/a5/56836ee0292a042b701a0a5fb866d46e9d87a0c1dbf07b71885e4ad52673/alive-progress-3.0.1.tar.gz"
    sha256 "3245114253b6adb4b38f2a2a1828edfcd9e8c012f7e30a5cef1932ca7344eb44"
  end

  resource "arnparse" do
    url "https://files.pythonhosted.org/packages/bd/42/949284e998282b167e273872fa9c39b06d41a6055163c30aa2daaeee76a0/arnparse-0.0.2.tar.gz"
    sha256 "cb87f17200d07121108a9085d4a09cc69a55582647776b9a917b0b1f279db8f8"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/3e/71/f6f71a276e2e69264a97ad39ef850dca0a04fce67b12570730cb38d0ccac/azure-common-1.1.28.zip"
    sha256 "4ac0cd3214e36b6a1b6a442686722a5d8cc449603aa833f3f0f40bda836704a3"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/0e/53/8983f401b153a5d8482880b3155cac7d8f313a3c69a01fdb4442f635fc1a/azure-core-1.26.3.zip"
    sha256 "acbd0daa9675ce88623da35c80d819cdafa91731dee6b2695c64d7ca9da82db4"
  end

  resource "azure-identity" do
    url "https://files.pythonhosted.org/packages/fa/d7/a7402d68d1975d869ce3ba7b6e11983310c12ff8793f0ebf01cd7ca1f398/azure-identity-1.12.0.zip"
    sha256 "7f9b1ae7d97ea7af3f38dd09305e19ab81a1e16ab66ea186b6579d85c1ca2347"
  end

  resource "azure-mgmt-authorization" do
    url "https://files.pythonhosted.org/packages/7b/39/46adcbabc61a6d91f8514b46a2b64cfba365170325a6c38c31e2c1567090/azure-mgmt-authorization-3.0.0.zip"
    sha256 "0a5d7f683bf3372236b841cdbd4677f6b08ed7ce41b999c3e644d4286252057d"
  end

  resource "azure-mgmt-core" do
    url "https://files.pythonhosted.org/packages/ae/18/6f79cfddbf08f233de5a51961323c0b1b2174e06ae9460988091fd012043/azure-mgmt-core-1.3.2.zip"
    sha256 "07f4afe823a55d704b048d61edfdc1318c051ed59f244032126350be95e9d501"
  end

  resource "azure-mgmt-security" do
    url "https://files.pythonhosted.org/packages/a5/e7/5242104430b1b8337e7c2e91a09981985c4eab6dca663ddaafd6118a0a16/azure-mgmt-security-3.0.0.zip"
    sha256 "bcba7cef857f6b02a2d98afeb07f9871b1628fa33d8861ab1387e732e7db3f84"
  end

  resource "azure-mgmt-storage" do
    url "https://files.pythonhosted.org/packages/83/9d/f486f601c9902bce42ea77adfa6f81895535adfb3eadc1f8522b1abbd44b/azure-mgmt-storage-21.0.0.zip"
    sha256 "6eb13eeecf89195b2b5f47be0679e3f27888efd7bd2132eec7ebcbce75cb1377"
  end

  resource "azure-mgmt-subscription" do
    url "https://files.pythonhosted.org/packages/84/67/14b19a006e13d86f05ee59faf78c39dc443d4fd6967344e9c94f688949c1/azure-mgmt-subscription-3.1.1.zip"
    sha256 "4e255b4ce9b924357bb8c5009b3c88a2014d3203b2495e2256fa027bf84e800e"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/43/20/cdd33ec1fdb22f5374332172c2be941e5bc598ef624ce2ccc49ba93569d5/azure-storage-blob-12.15.0.zip"
    sha256 "f8b8d582492740ab16744455408342fb8e4c8897b64a8a3fc31743844722c2f2"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/7b/e2/791d051eb96f60a79388a0c99073f7d74914095b0967104af051037b876c/boto3-1.26.79.tar.gz"
    sha256 "73d7bd1f16118ef0dfe936e0420cd76b02d1aedb75330ebda51168458ab752ac"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/1c/5c/345187635651290397d511e8ce279b74e3718d7f556b6abad4b469b80c4c/botocore-1.29.79.tar.gz"
    sha256 "c7ded44062bed3b928944cfb09e1578ed3fed0e4c98de4f233f3c2056a8d491e"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-plugins" do
    url "https://files.pythonhosted.org/packages/5f/1d/45434f64ed749540af821fd7e42b8e4d23ac04b1eda7c26613288d6cd8a8/click-plugins-1.1.1.tar.gz"
    sha256 "46ab999744a9d831159c3411bb0c79346d94a444df9a3a3742e9ed63645f264b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
  end

  resource "detect-secrets" do
    url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
    sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  end

  resource "grapheme" do
    url "https://files.pythonhosted.org/packages/ce/e7/bbaab0d2a33e07c8278910c1d0d8d4f3781293dfbc70b5c38197159046bf/grapheme-0.6.0.tar.gz"
    sha256 "44c2b9f21bbe77cfb05835fec230bd435954275267fea1858013b102f8603cca"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "msal" do
    url "https://files.pythonhosted.org/packages/06/ec/002278ed40a1ec6c85f72330cac2699dc7e9b3a36af686783c0fd8d05c7a/msal-1.21.0.tar.gz"
    sha256 "96b5c867830fd116e5f7d0ec8ef1b238b4cda4d1aea86d8fecf518260e136fbf"
  end

  resource "msal-extensions" do
    url "https://files.pythonhosted.org/packages/33/5e/2e23593c67df0b21ffb141c485ca0ae955569203d7ff5064040af968cb81/msal-extensions-1.0.0.tar.gz"
    sha256 "c676aba56b0cce3783de1b5c5ecfe828db998167875126ca4b47dc6436451354"
  end

  resource "msgraph-core" do
    url "https://files.pythonhosted.org/packages/35/94/e2a15b577044b6b0e4b610a26fcd4439863d8d21bda419e0fd24580316cd/msgraph-core-0.2.2.tar.gz"
    sha256 "147324246788abe8ed7e05534cd9e4e0ec98b33b30e011693b8d014cebf97f63"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "portalocker" do
    url "https://files.pythonhosted.org/packages/1f/f8/969e6f280201b40b31bcb62843c619f343dcc351dff83a5891530c9dd60e/portalocker-2.7.0.tar.gz"
    sha256 "032e81d534a88ec1736d03f780ba073f047a06c478b06e2937486f334e955c51"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/28/59/5d2fc3499d9ce8ce48ee7e00f043d5cc429a9198bd96c3512809428ade15/pydantic-1.10.5.tar.gz"
    sha256 "9e337ac83686645a46db0e825acceea8e02fca4062483f40e9ae178e8bd1103a"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/75/65/db64904a7f23e12dbf0565b53de01db04d848a497c6c9b87e102f74c9304/PyJWT-2.6.0.tar.gz"
    sha256 "69285c7e31fc44f68a1feb309e948e0df53259d579295e6cfe2b1792329f05fd"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "shodan" do
    url "https://files.pythonhosted.org/packages/fd/e3/8a76f8cb021d712ba966f7385d3635165a70222e5ca1a92a8887470dd1a0/shodan-1.28.0.tar.gz"
    sha256 "18bd2ae81114b70836e0e3315227325e14398275223998a8c235b099432f4b0b"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "XlsxWriter" do
    url "https://files.pythonhosted.org/packages/6a/31/f94f5707827ecd84f3fa03e55e263b9aeddb7da4ae0f7f1541e214e81b15/XlsxWriter-3.0.8.tar.gz"
    sha256 "ec77335fb118c36bc5ed1c89e33904d649e4989df2d7980f7d6a9dd95ee5874e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ens_rd2022_aws", shell_output("#{bin}/prowler aws --list-compliance")
    assert_match "rds", shell_output("#{bin}/prowler aws --list-services")

    assert_match "NoCredentialsError -- Unable to locate credentials",
      shell_output("#{bin}/prowler aws --quick-inventory 2>&1", 1)

    assert_match "Prowler #{version}", shell_output("#{bin}/prowler -v")
  end
end
