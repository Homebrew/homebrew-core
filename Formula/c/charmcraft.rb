class Charmcraft < Formula
  include Language::Python::Virtualenv

  desc "Tool to build charms and publish them on Charmhub"
  homepage "https://charmhub.io"
  # Switch back to PyPI source when fixed: https://github.com/canonical/charmcraft/issues/1579
  url "https://github.com/canonical/charmcraft/archive/refs/tags/3.0.0.tar.gz"
  sha256 "cf6b957588b2a385355005a207708a96cba60a2a27a6678d53d50dddb7512a9c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b08079f51bd2f49def8624e024f48fef74cddbf2e215182b792f0bb3b0a62526"
    sha256 cellar: :any,                 arm64_ventura:  "8ec1cd2f9c1de134be477fc35eb9e9c892c5bad7241dd4b4df0bfb1275683ea0"
    sha256 cellar: :any,                 arm64_monterey: "e95691eec5745aa5c1f0732d7a4c1a6215b50e11867d40a9845fcf6e30f7d8e1"
    sha256 cellar: :any,                 sonoma:         "e2228ed0b9e5c09a00a530f544d35baaf05cbf55f17ad32d0f9df2d80e788fa8"
    sha256 cellar: :any,                 ventura:        "14721b970a5cf3bbf431a094eabe0c7e49d1d0b947c611a910978f61f2b5232c"
    sha256 cellar: :any,                 monterey:       "f94ef0ed7bea9a25f758c2bba891562cb3b6ae3fcaa4252df1937fc62b9bae4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683892ba4c1b916bb1506d5ba3e6638cabf7c66bd42417f6a6433dc3e0b3625c"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libgit2"
  depends_on "libsodium"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "craft-application" do
    url "https://files.pythonhosted.org/packages/1a/38/61b8cb1f1d42579ae22ad4c158a0d75b1cec7bd0ada2393fa969bafdc01a/craft-application-2.4.0.tar.gz"
    sha256 "fbcb02722857745ddeb0677f870fcd34ed71bbf142bf187dccbcc78638d45720"
  end

  resource "craft-archives" do
    url "https://files.pythonhosted.org/packages/f6/66/90a253f7d787800902ec412c7b9e25f4a06d2593214ebc16da57d259d19b/craft-archives-1.1.3.tar.gz"
    sha256 "2efd153df09870c4d5e851e5bd05c6dc1824e973852b83c6218b97d2362035a5"
  end

  resource "craft-cli" do
    url "https://files.pythonhosted.org/packages/9d/36/47163ccdb62ba207fd8336f7c0d30f57ef34d52a3cdd4ce71aaffe5467a7/craft-cli-2.5.1.tar.gz"
    sha256 "c961f8683bf4b6d0d5c0a798def401bd4b62c912c8fc2222d13e38ced0976c4f"
  end

  resource "craft-grammar" do
    url "https://files.pythonhosted.org/packages/41/c3/e008b986b5fac41286b93e129059addb27deee7dfa32d3756b416b24d8d3/craft-grammar-1.2.0.tar.gz"
    sha256 "2f770f986c74e89247b31b9df18221f7c79d1423aef4a34268d0f9a47ace63da"
  end

  resource "craft-parts" do
    url "https://files.pythonhosted.org/packages/af/30/22154fdfc6ec43cdce792855fe7708239ebae2afba922c0159ad7f16f745/craft-parts-1.29.0.tar.gz"
    sha256 "09958d5c5802cf48fd9d7d189f5c30bf7a4721d0b668bd14e47bee32edd25a5b"
  end

  resource "craft-providers" do
    url "https://files.pythonhosted.org/packages/d7/c1/8b75707587ac6bf403482298febcc0eb170d2bd5b902449145a8b6c37c31/craft-providers-1.23.1.tar.gz"
    sha256 "60dd086f638a5de2930068839b5f7cd52c661f083e154db9e1deb65279da6c56"
  end

  resource "craft-store" do
    url "https://files.pythonhosted.org/packages/c4/c4/5033f4deebe022b6b3ae96a75c254280362d437a1822c5ffa73a38a30ee1/craft-store-2.6.1.tar.gz"
    sha256 "30b6b8c5deca963e320af604904c5fbf92d1cb884a2f1dd3c9d0958dac2adde0"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/3d/ad/2371116b22d616c194aa25ec410c9c6c37f23599dcd590502b74db197584/httplib2-0.22.0.tar.gz"
    sha256 "d7a10bc5ef5ab08322488bde8c726eeee5c8618723fdb399597ec58f3d82df81"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/76/21/7a0b24fae849562397efd79da58e62437243ae0fd0f6c09c6bc26225b75c/humanize-4.9.0.tar.gz"
    sha256 "582a265c931c683a7e9b8ed9559089dea7edcf6cc95be39a3cbc2c5d5ac2bcfa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a0/fc/c4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547/importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/4d/c5/3f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9be/jsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/ae/6c/bd2cfc6c708ce7009bdb48c85bb8cad225f5638095ecc8f49f15e8e1f35e/keyring-24.3.1.tar.gz"
    sha256 "c3327b6ffafc0e8befbdb597cacdb4928ffe5c1212f7645f186e6d9957a898db"
  end

  resource "launchpadlib" do
    url "https://files.pythonhosted.org/packages/e1/61/cf604b4248ccb707c433f9905a8d18943667a1823cf4d3712bd5587db790/launchpadlib-1.11.0.tar.gz"
    sha256 "01898c937477b0c64a75338adb0977028d7346a8a019eb023cf68fed99850146"
  end

  resource "lazr-restfulclient" do
    url "https://files.pythonhosted.org/packages/ea/a3/45d80620a048c6f5d1acecbc244f00e65989914bca370a9179e3612aeec8/lazr.restfulclient-0.14.6.tar.gz"
    sha256 "43f12a1d3948463b1462038c47b429dcb5e42e0ba7f2e16511b02ba5d2adffdb"
  end

  resource "lazr-uri" do
    url "https://files.pythonhosted.org/packages/a6/db/310eaccd3639f5a8a6011c3133bb1cac7fd80bb46f8a50406df2966302e4/lazr.uri-1.0.6.tar.gz"
    sha256 "5026853fcbf6f91d5a6b11ea7860a641fe27b36d4172c731f4aa16b900cf8464"
  end

  resource "macaroonbakery" do
    url "https://files.pythonhosted.org/packages/4b/ae/59f5ab870640bd43673b708e5f24aed592dc2673cc72caa49b0053b4af37/macaroonbakery-1.3.4.tar.gz"
    sha256 "41ca993a23e4f8ef2fe7723b5cd4a30c759735f1d5021e990770c8a0e0f33970"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/df/ad/7905a7fd46ffb61d976133a4f47799388209e73cbc8c1253593335da88b4/more-itertools-10.2.0.tar.gz"
    sha256 "8fccb480c43d3e99a00087634c06dd02b0d50fbf088b380de5a41a015ec239e1"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/36/86/b585f53236dec60aba864e050778b25045f857e17f6e5ea0ae95fe80edd2/overrides-7.7.0.tar.gz"
    sha256 "55158fa3d93b98cc75299b1e67078ad9003ca27945c76162c1c0766d6f91820a"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/96/dc/c1d911bf5bb0fdc58cc05010e9f3efe3b67970cef779ba7fbc3183b987a8/platformdirs-4.2.0.tar.gz"
    sha256 "ef0cc731df711022c174543cb70a9b5bd22e5a9337c8624ef2c2ceb8ddad8768"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d2/e5/7e22ca7201a6b1040aae7787d0fe6cd970311da376a86fdafa5182be1d1b/protobuf-5.26.1.tar.gz"
    sha256 "8ca2a1d97c290ec7b16e4e5dff2e5ae150cc1582f55b5ab300d45cb0dfa90e51"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/6f/3a/1a057845b787469aa8c4ff2c126d5110d616223c82e74561b8ae56b46ec7/pydantic-1.10.15.tar.gz"
    sha256 "ca832e124eda231a60a041da4f013e3ff24949d94a01154b137fc2f2a43c3ffb"
  end

  resource "pydantic-yaml" do
    url "https://files.pythonhosted.org/packages/9e/e7/30713a0fae04001f8886b0219cad667b0fbf56149f4ea3ee5a84e8e0c9e7/pydantic_yaml-0.11.2.tar.gz"
    sha256 "19c8f3c9a97041b0a3d8fc06ca5143ff71c0846c45b39fde719cfbc98be7a00c"
  end

  resource "pygit2" do
    url "https://files.pythonhosted.org/packages/f0/5e/6e05213a9163bad15489beda5f958500881d45889b0df01d7b8964f031bf/pygit2-1.14.1.tar.gz"
    sha256 "ec5958571b82a6351785ca645e5394c31ae45eec5384b2fa9c4e05dde3597ad6"
  end

  resource "pymacaroons" do
    url "https://files.pythonhosted.org/packages/37/b4/52ff00b59e91c4817ca60210c33caf11e85a7f68f7b361748ca2eb50923e/pymacaroons-0.13.0.tar.gz"
    sha256 "1e6bba42a5f66c245adf38a5a4006a99dcc06a0703786ea636098667d42903b8"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
  end

  resource "pyrfc3339" do
    url "https://files.pythonhosted.org/packages/00/52/75ea0ae249ba885c9429e421b4f94bc154df68484847f1ac164287d978d7/pyRFC3339-1.1.tar.gz"
    sha256 "81b8cbe1519cdb79bed04910dd6fa4e181faf8c88dff1e1b987b5f7ab23a5b1a"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/90/26/9f1f00a5d021fff16dee3de13d43e5e978f3d58928e129c3a62cf7eb9738/pytz-2024.1.tar.gz"
    sha256 "2a29735ea9c18baf14b448846bde5a48030ed267578472d8955cd0e7443a9812"
  end

  resource "pyxdg" do
    url "https://files.pythonhosted.org/packages/b0/25/7998cd2dec731acbd438fbf91bc619603fc5188de0a9a17699a781840452/pyxdg-0.28.tar.gz"
    sha256 "3267bb3074e934df202af2ee0868575484108581e6f3cb006af1da35395e88b4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/59/d7/48b862b8133da2e0ed091195028f0d45c4d0be0f7f23dbe046a767282f37/referencing-0.34.0.tar.gz"
    sha256 "5773bd84ef41799a5a8ca72dc34590c041eb01bf9aa02632b4a973fb0181a844"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "requests-unixsocket" do
    url "https://files.pythonhosted.org/packages/c3/ea/0fb87f844d8a35ff0dcc8b941e1a9ffc9eb46588ac9e4267b9d9804354eb/requests-unixsocket-0.3.0.tar.gz"
    sha256 "28304283ea9357d45fff58ad5b11e47708cfbf5806817aa59b2a363228ee971e"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/55/ba/ce7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5e/rpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/d6/4f/b10f707e14ef7de524fe1f8988a294fb262a29c9b5b12275c7e188864aed/setuptools-69.5.1.tar.gz"
    sha256 "6c1fccdac05a97e598fb0ae3bbed5904ccb317337a51139dcd51453611bbb987"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "snap-helpers" do
    url "https://files.pythonhosted.org/packages/50/2a/221ab0a9c0200065bdd8a5d2b131997e3e19ce81832fdf8138a7f5247216/snap-helpers-0.4.2.tar.gz"
    sha256 "ef3b8621e331bb71afe27e54ef742a7dd2edd9e8026afac285beb42109c8b9a9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "types-deprecated" do
    url "https://files.pythonhosted.org/packages/27/10/d9e72aedcd94fba94e511eebb03bcbd2b535e7e1c48e4416367682cd1c4e/types-Deprecated-1.2.9.20240311.tar.gz"
    sha256 "0680e89989a8142707de8103f15d182445a533c1047fd9b7e8c5459101e9b90a"
  end

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/0a/3c/6f4c97d9eb2b58f57fc595c105ae0a53a851747cddfb7df30f3d7192c837/types-PyYAML-6.0.12.20240311.tar.gz"
    sha256 "a9e0f0f88dc835739b0c1ca51ee90d04ca2a897a71af79de9aec5f38cb0a5342"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/f3/b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2/typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/0c/39/64487bf07df2ed854cc06078c27c0d0abc59bd27b32232876e403c333a08/urllib3-1.26.18.tar.gz"
    sha256 "f8ecc1bba5667413457c529ab955bf8c67b45db799d159066261719e328580a0"
  end

  resource "wadllib" do
    url "https://files.pythonhosted.org/packages/35/07/040cc4cc736cdf25873848bd4c717cc25e257196a7c11f42b3a09617a961/wadllib-1.3.6.tar.gz"
    sha256 "acd9ad6a2c1007d34ca208e1da6341bbca1804c0e6850f954db04bdd7666c5fc"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3e/ef/65da662da6f9991e87f058bc90b91a935ae655a16ae5514660d6460d1298/zipp-3.18.1.tar.gz"
    sha256 "2884ed22e7d8961de1c9a05142eb69a247f120291bc0206a00a7642f09b5b715"
  end

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_CHARMCRAFT"] = version
    virtualenv_install_with_resources
  end

  test do
    system bin/"charmcraft", "version"
    system bin/"charmcraft", "help"
    system bin/"charmcraft", "init", "--author", "Foo Bar", "-p", testpath/"charm"
    assert_predicate testpath/"charm/charmcraft.yaml", :exist?
  end
end
