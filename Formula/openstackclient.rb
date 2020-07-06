class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "OpenStack Client"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/56/e9/eb6e88074b8c1f20a622b7cc7f7d1e4be0e81ddf22ceb49949f414bd52c6/python-openstackclient-5.2.1.tar.gz"
  sha256 "7df547491f41f71f0b5f2c578a3837bbd6c93e5b3426d993b6fb85c1f48ae6e2"
  license "Apache-2.0"

  bottle do
    cellar :any
    sha256 "76bf0efebf0a8323b53693e09fbe1632b51b92b40380f571b971ec65b043ce80" => :catalina
    sha256 "e293198da3ea11c9f2645bb810ed18d9269423cce915146f3b04ffbd2c46810b" => :mojave
    sha256 "ec67e8a2c7674cab301b45c5240be5ad799390a99b2a5bd8f720401befed34da" => :high_sierra
  end

  depends_on "python@3.8"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/98/c3/2c227e66b5e896e15ccdae2e00bbc69aa46e9a8ce8869cc5fa96310bf612/attrs-19.3.0.tar.gz"
    sha256 "f7b7ce16570fe9965acd6d30101a28f62fb4a7f9e926b3bbc9b61f8b04247e72"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/34/18/8706cfa5b2c73f5a549fdc0ef2e24db71812a2685959cff31cbdfc010136/Babel-2.8.0.tar.gz"
    sha256 "1aac2ae2d0d8ea368fa90906567f5c08463d98ade155c0c4bfedd6a0f7160e38"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/b4/19/53433f37a31543364c8676f30b291d128cdf4cd5b31b755b7890f8e89ac8/certifi-2020.4.5.2.tar.gz"
    sha256 "5ad7e9a056d25ffa5082862e36f119f7f7cec6457fa07ee2f8c339814b80c9b1"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/c7/c4/38ea8a52809dd2fd7b6282d21bb17a5f3d13d79df57b53b96dddb41dc2b6/cliff-3.3.0.tar.gz"
    sha256 "611595ad7b4bdf57aa252027796dac3273ab0f4bc1511e839cce230a351cb710"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/bc/38/c622733aceaaca9b1fb91ccbf8e2455cb1742fac6fe3255543d0ea1ece37/cmd2-1.1.0.tar.gz"
    sha256 "d233b5ad4b9ee264a43fb14668f287d25f998f4b443a81b4efdfd292f1a77108"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/82/75/f2a4c0c94c85e2693c229142eb448840fba0f9230111faa889d1f541d12d/colorama-0.4.3.tar.gz"
    sha256 "e96da0d330793e2cb9485e9ddfd918d456036c7149416295932478192f4436a1"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/56/3b/78c6816918fdf2405d62c98e48589112669f36711e50158a0c15d804c30d/cryptography-2.9.2.tar.gz"
    sha256 "a0c30272fb4ddda5f5ffc1089d7405b7a71b0b0f51993cb4e5dbb4590b2fc229"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/a1/09/d463e1514308f0c04a46cdcc2502fb2d652f6b19659a403d0592ae6e6f6f/debtcollector-2.1.0.tar.gz"
    sha256 "a25fc6215560d81cb9f2a0b58d6c834f2a24010987027bde169599e138a205af"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/b5/02/9692c82808341747afc87a7c2b701c8eed76c05ec6bc98844c102a537de7/dogpile.cache-0.9.2.tar.gz"
    sha256 "bc9dde1ffa5de0179efbcdc73773ef0553921130ad01955422f2932be35c059e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/19/57503b5de719ee45e83472f339f617b0c01ad75cba44aba1e4c97c2b0abd/idna-2.9.tar.gz"
    sha256 "7588d1c14ae4c77d74036e8c22ff447b26d0fde8f007354fd48a7814db15b7cb"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz"
    sha256 "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/70/9f/6f0bfbb4cc1401ce994d336bcb4ed2aa924f395e7fd1926511c04a52eee1/jsonpatch-1.25.tar.gz"
    sha256 "ddc0f7628b8bfdd62e3cbfbc24ca6671b0b6265b50d186c2cf3659dc0f78fd6a"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz"
    sha256 "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/ba/b4/f9d85343fb7b268048bba893c20b9eaddcfe57b230a8169505cbe48107e9/keystoneauth1-4.0.0.tar.gz"
    sha256 "02b283a662552cba65c1e6b5e89c06acfa242ff96355f59ab7def861e765a695"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/e4/4f/057549afbd12fdd5d9aae9df19a6773a3d91988afe7be45b277e8cee2f4d/msgpack-1.0.0.tar.gz"
    sha256 "9534d5cc480d4aff720233411a1f765be90885750b07df772380b34c10ecb5c0"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/43/a1/ec48010724eedfe2add68eb7592a0d238590e14e08b95a4ffb3c7b2f0808/munch-2.5.0.tar.gz"
    sha256 "2d735f6f24d4dba3417fa448cae40c6e896ec1fdab6cdb5e6510999758a4dbd2"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/47/1b/d115c8cfe20f33176982807a3624b82930ff508196f0d875f6985cd28911/netaddr-0.7.20.tar.gz"
    sha256 "d09252e5aec3913815d77eb8e8ea8fa6eb33521253e52f977f6abaa964776f3e"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/90/99/3f72e506b12ae63e3a6e12eb320247783c95a93d0ab4751b42c160fadf1a/openstacksdk-0.46.0.tar.gz"
    sha256 "a1617f00810a0ec1353e66e7da9fe9b4f926a830bb14b48643b6461b8808ef29"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/58/3f/09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ec/os-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/ad/71/ee714a1bc985f6153cf91941c1de9c7664d8d9527706344051e9f416f1e9/osc-lib-2.2.0.tar.gz"
    sha256 "fcfce4d63a633c3161e2a6666764446e3f32668e814a94ab98da12e3908ee1d6"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/2b/16/182a40587eaf4081e5ec6c9fd9b3d1fe4372b14f98ad462e4974654df6dc/oslo.config-8.2.0.tar.gz"
    sha256 "116ff3a7b98b0309b083af7906d99f8c6bea67df5ee03a85e2ac02700dd75d30"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/fe/40/8cbad079b6930ce7958af9187c208789bb77b90815eea6b01af169ea8f86/oslo.i18n-5.0.0.tar.gz"
    sha256 "2e71ae3ec73a74ac71f8f407e6653243dc267eed404624255a296c34f1fc6887"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/0f/42/3625893aee1450957caf49514810e13514c1b00b0cfbe2a08194bf392aa5/oslo.serialization-4.0.0.tar.gz"
    sha256 "f465df171be564282cb3e86ec895f5b6ae5e5b0760e9af2be96a942a5255a860"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/a5/4e/cf7860e3390bf736d50c25f707bfadd9d615fc51afc9a101b941f59fec15/oslo.utils-4.2.1.tar.gz"
    sha256 "4231498577d575053df8d05338127728226d862d98863a7c4e03ebcca55d72ad"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8a/a8/bb34d7997eb360bc3e98d201a20b5ef44e54098bb2b8e978ae620d933002/pbr-5.4.5.tar.gz"
    sha256 "07f558fece33b05caf857474a366dfcc00562bca13dd8b47b2b3e22d9f9bf55c"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/f6/5b/55866e1cde0f86f5eec59dab5de8a66628cb0d53da74b8dbc15ad8dabda3/pyperclip-1.8.0.tar.gz"
    sha256 "b75b975160428d84608c26edba2dec146e7799566aea42c1fe1b32e72b6028f2"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/be/d7/850a47c96039b2f79175820c65f80038b68d51b70ba13f602c2892a62452/python-cinderclient-7.1.0.tar.gz"
    sha256 "625d34dd6a3626f9a02e83af554441d96ff91ab20aa081412c7530c1e87ec642"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/c9/ec/5cce3af48ac2bd891e1ff7dcaffa2d7322b4438f2324fc3c1d0125c6cd10/python-keystoneclient-4.0.0.tar.gz"
    sha256 "6d93efd494b43d8b4cd8a62281c82d3f02aa531c5523e6bbe7d696e37bc77ba8"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/f6/e3/37f1c627745149d38a4e4016b00b252fe4026d7f4aa8b14ebfd603d67e10/python-novaclient-17.0.0.tar.gz"
    sha256 "3a0ab422f217eeb9043ba786ecb3925c8b66baa142195ed211db37c78eff3c5f"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/70/e2/1344681ad04a0971e8884b9a9856e5a13cc4824d15c047f8b0bbcc0b2029/rfc3986-1.4.0.tar.gz"
    sha256 "112398da31a3344dc25dbf477d8df6cb34f9278a94fee2625d89e4514be8bb9d"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/98/87/a7b98aa9256c8843f92878966dc3d8d914c14aad97e2c5ce4798d5743e07/simplejson-3.17.0.tar.gz"
    sha256 "2b4b2b738b3b99819a17feaf118265d0753d5536049ea570b3c43b51c4701e81"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/4e/a6/0c96ae5f3e817d3cff551a4ebce82da21452b8267dfbf00d6120e401e76d/stevedore-2.0.0.tar.gz"
    sha256 "001e90cd704be6470d46cc9076434e2d0d566c1379187e7013eb296d3a6032d9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/05/8c/40cd6949373e23081b3ea20d5594ae523e681b6f472e600fbc95ed046a36/urllib3-1.25.9.tar.gz"
    sha256 "3018294ebefce6572a474f0604c2021e33b3fd8006ecd11d62107a5d2a963527"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2e/30/268d9d3ed18439b6983a8e630cd52d81fd7460a152d6e801d1b8394e51a1/wcwidth-0.2.4.tar.gz"
    sha256 "8c6b5b6ee1360b842645f336d9e5d68c55817c26d3050f46b235ef2bc650e48f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    output = shell_output("#{bin}/openstack server list 2>&1", 1)
    assert_match "Missing value auth-url required", output
  end
end
