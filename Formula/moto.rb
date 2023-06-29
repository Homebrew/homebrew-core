class Moto < Formula
  include Language::Python::Virtualenv

  desc "Mock AWS services"
  homepage "http://getmoto.org/"
  url "https://files.pythonhosted.org/packages/2b/6b/85f00b5da885b6ca023868a420062c46fef0dc31e971f4bfe0cf9572e32a/moto-4.1.12.tar.gz"
  sha256 "25577e4cf55f05235f4efe78bcfeb5a7704fb75c16b426a5de2fc1e6b7b8545b"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "be0047f86ddba9fc61a504063e260399bc9c369a2764a106d81a9e5207a1f294"
    sha256 cellar: :any,                 arm64_monterey: "f8f477363b39275bba945d867e51b7bf52999a8c29828d20752f802aede86276"
    sha256 cellar: :any,                 arm64_big_sur:  "d1c6415b898ed32b370b57b2befd5857184e10e6cb8c7ba779bb50ecd9adad75"
    sha256 cellar: :any,                 ventura:        "a6324510a45765d2e2b28f11c977b17dbf6e70eacdc7ac8e4397a91680f8acb7"
    sha256 cellar: :any,                 monterey:       "49715d4c34a5ccca6867d1e44311190c75a2be1bb4fa0535c54ed32d413bb89f"
    sha256 cellar: :any,                 big_sur:        "9cb19077d1fb009afd03b4b42f1e1632c726db99faa323177709ea619b733f94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "636c2cf49cacbefb2430c063a9e77e1f25c44e2d6bfe66af87899e1c3899203b"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  depends_on "cffi"
  depends_on "cfn-lint"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "aws-sam-translator" do
    url "https://files.pythonhosted.org/packages/c2/c1/b5fbee830ab33a89422bb2f5b941318947ea31b178a31dce2fef4a41a5e8/aws-sam-translator-1.70.0.tar.gz"
    sha256 "753288eda07b057e5350773b7617076962b59404d49cd05e2259ac96a7694436"
  end

  resource "aws-xray-sdk" do
    url "https://files.pythonhosted.org/packages/83/98/25d55538c8e344586354defa4644dd728801be18bcf46c0cd268d84860fa/aws-xray-sdk-2.12.0.tar.gz"
    sha256 "295afc237073a80956d7d4f27c31830edcb9a8ccca9ef8aa44990badef15e5b7"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/e8/f9/a05287f3d5c54d20f51a235ace01f50620984bc7ca5ceee781dc645211c5/blinker-1.6.2.tar.gz"
    sha256 "4afd3de66ef3a9f8067559fb7a1cbe555c17dcbe15971b05d1b625c3e7abe213"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e7/d7/f1be1f98c6b983febb37916837086b5a40a9accb6aa517cc6a196ff15e85/boto3-1.26.160.tar.gz"
    sha256 "5218869eddeeb70efead1dd01037c3553dc7b268de3b80a0c3a2baeec2b97fc9"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/f2/fe/8c5a585898af94e8a7aacb7cbebd41212e0cd85d0eb02bb153f8cc961e5d/botocore-1.29.160.tar.gz"
    sha256 "dacf41787978c0d550321d334e0001a488145200f8a6c9bd893fb8e281b25cf7"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/4d/00/ef81c18da32fdfcde6381c315f4b11597fb6691180a330418848efee0ae7/Flask-2.3.2.tar.gz"
    sha256 "8c2f9abd47a9e8df7f0c3f091ce9497d011dc3b31effcf4c85a6e2b50f4114ef"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/cf/25/e3b2553d22ed542be807739556c69621ad2ab276ae8d5d2560f4ed20f652/Flask-Cors-3.0.10.tar.gz"
    sha256 "b60839393f3b84a0f3746f6cdca56c1ad7426aa738b70d6c61375857823181de"
  end

  resource "graphql-core" do
    url "https://files.pythonhosted.org/packages/ee/a6/94df9045ca1bac404c7b394094cd06713f63f49c7a4d54d99b773ae81737/graphql-core-3.2.3.tar.gz"
    sha256 "06d2aad0ac723e35b1cb47885d3e5c45e956a53bc1b209a9fc5369007fe46676"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jschema-to-python" do
    url "https://files.pythonhosted.org/packages/1d/7f/5ae3d97ddd86ec33323231d68453afd504041efcfd4f4dde993196606849/jschema_to_python-1.2.3.tar.gz"
    sha256 "76ff14fe5d304708ccad1284e4b11f96a658949a31ee7faed9e0995279549b91"
  end

  resource "jsondiff" do
    url "https://files.pythonhosted.org/packages/dd/13/2b691afe0a90fb930a32b8fc1b0fd6b5bdeaed459a32c5a58dc6654342da/jsondiff-2.0.0.tar.gz"
    sha256 "2795844ef075ec8a2b8d385c4d59f5ea48b08e7180fce3cb2787be0db00b1fb4"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpickle" do
    url "https://files.pythonhosted.org/packages/2b/3f/dd9bc9c1c9e57c687e8ebc4723e76c48980004244cf8db908a7b2543bd53/jsonpickle-3.0.1.tar.gz"
    sha256 "032538804795e73b94ead410800ac387fdb6de98f8882ac957fcd247e3a85200"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "jsonschema-spec" do
    url "https://files.pythonhosted.org/packages/a3/d5/b1c6171af26a3086189c45fcc7145cb40cdb7ab6779806e9e321501f5251/jsonschema_spec-0.1.6.tar.gz"
    sha256 "90215863b56e212086641956b20127ccbf6d8a3a38343dad01d6a74d19482f76"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
    sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mpmath" do
    url "https://files.pythonhosted.org/packages/e0/47/dd32fa426cc72114383ac549964eecb20ecfd886d1e5ccf5340b55b02f57/mpmath-1.3.0.tar.gz"
    sha256 "7a28eb2a9774d00c7bc92411c19a89209d5da7c4c9a9e227be8330a23a25b91f"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/fd/a1/47b974da1a73f063c158a1f4cc33ed0abf7c04f98a19050e80c533c31f0c/networkx-3.1.tar.gz"
    sha256 "de346335408f84de0eada6ff9fafafff9bcda11f0a0dfaa931133debb146ab61"
  end

  resource "openapi-schema-validator" do
    url "https://files.pythonhosted.org/packages/f6/bc/ea1c532bba227c61cf57f228790b3544e73fa1f82832bb59f3272672d239/openapi_schema_validator-0.4.4.tar.gz"
    sha256 "c573e2be2c783abae56c5a1486ab716ca96e09d1c3eab56020d1dc680aa57bf8"
  end

  resource "openapi-spec-validator" do
    url "https://files.pythonhosted.org/packages/27/e5/9fe67dfd403777d500abb5cd650c16ef9d4918a6c12e87731c3a4feeb4ff/openapi_spec_validator-0.5.7.tar.gz"
    sha256 "6c2d42180045a80fd6314de848b94310bdb0fa4949f4b099578b69f79d9fa5ac"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/9d/ed/e0e29300253b61dea3b7ec3a31f5d061d577c2a6fd1e35c5cfd0e6f2cd6d/pathable-0.4.3.tar.gz"
    sha256 "5c869d315be50776cc8a993f3af43e0c60dc01506b399643f919034ebf4cdcab"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "py-partiql-parser" do
    url "https://files.pythonhosted.org/packages/93/e4/9a718409473643b22e12accd47ccdecbdb9a2c989581b94e2309d00cc986/py-partiql-parser-0.3.3.tar.gz"
    sha256 "351672721dfaaa00bbd82c4a3340d5d2defb589d2dd5baaecf6e493910f1c033"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/ec/0a/cf955f8bb3b9498d554522cfe7cb9b019ba9f8b86e2879009f604207b72c/pydantic-1.10.9.tar.gz"
    sha256 "95c70da2cd3b6ddf3b9645ecaa8d98f3d80c606624b6d245558d202cd23ea3be"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/4f/13/28e88033cab976721512e7741000fb0635fa078045e530a91abb25aea0c0/pyparsing-3.1.0.tar.gz"
    sha256 "edb662d6fe322d6e990b1594b5feaeadf806803359e3d4d42f11e295e588f0ea"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-jose" do
    url "https://files.pythonhosted.org/packages/e4/19/b2c86504116dc5f0635d29f802da858404d77d930a25633d2e86a64a35b3/python-jose-3.3.0.tar.gz"
    sha256 "55779b5e6ad599c6336191246e95eb2293a9ddebd555f796a65f838f07e5d78a"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/18/df/401fd39ffd50062ff1e0344f95f8e2c141de4fd1eca1677d2f29609e5389/regex-2023.6.3.tar.gz"
    sha256 "72d1a25bf36d2050ceb35b517afe13864865268dfb45910e2e17a84be6cbfeb0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "responses" do
    url "https://files.pythonhosted.org/packages/fa/4f/5033bf66528c832e7fcc48e76f540bf401302c55041c7fb488b4fbaaec4a/responses-0.23.1.tar.gz"
    sha256 "c4d9aa9fc888188f0c673eff79a8dadbe2e75b7fe879dc80a221a06e0a68138f"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "sarif-om" do
    url "https://files.pythonhosted.org/packages/ba/de/bbdd93fe456d4011500784657c5e4a31e3f4fcbb276255d4db1213aed78c/sarif_om-1.0.4.tar.gz"
    sha256 "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98"
  end

  resource "sshpubkeys" do
    url "https://files.pythonhosted.org/packages/a3/b9/e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220/sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "sympy" do
    url "https://files.pythonhosted.org/packages/e5/57/3485a1a3dff51bfd691962768b14310dae452431754bfc091250be50dd29/sympy-1.12.tar.gz"
    sha256 "ebf595c8dac3e0fdc4152c51878b498396ec7f30e7a914d6071e674d49420fb8"
  end

  resource "types-pyyaml" do
    url "https://files.pythonhosted.org/packages/1e/1f/b94c24cd38507a94efb8bd95682a27fbcda543e5afbd11a018305f552a11/types-PyYAML-6.0.12.10.tar.gz"
    sha256 "ebab3d0700b946553724ae6ca636ea932c1b0868701d4af121630e78d695fc97"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/d1/7e/c35cea5749237d40effc50ed1a1c7518d9f2e768fcf30b4e9ea119e74975/Werkzeug-2.3.6.tar.gz"
    sha256 "98c774df2f91b05550078891dee5f0eb0cb797a522c757a2452b9cee5b202330"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"moto_server"]
    keep_alive true
    working_dir var
    log_path var/"log/moto.log"
    error_log_path var/"log/moto.log"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"moto_server", "--port=#{port}"
    end

    # keep trying to connect until the server is up
    curl_cmd = "curl --silent 127.0.0.1:#{port}/"
    ohai curl_cmd
    output = ""
    exitstatus = 7
    loop do
      sleep 1
      output = `#{curl_cmd}`
      exitstatus = $CHILD_STATUS.exitstatus
      break if exitstatus != 7  # CURLE_COULDNT_CONNECT
    end

    assert_equal exitstatus, 0
    expected_output = <<~EOS
      <ListAllMyBucketsResult xmlns="http://s3.amazonaws.com/doc/2006-03-01"><Owner><ID>bcaf1ffd86f41161ca5fb16fd081034f</ID><DisplayName>webfile</DisplayName></Owner><Buckets></Buckets></ListAllMyBucketsResult>
    EOS
    assert_equal expected_output.strip, output.strip
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
