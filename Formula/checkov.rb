class Checkov < Formula
  include Language::Python::Virtualenv

  desc "Prevent cloud misconfigurations during build-time for IaC tools"
  homepage "https://www.checkov.io/"
  # checkov should only be updated every 15 releases on multiples of 15
  url "https://files.pythonhosted.org/packages/1e/c9/279a18eab65b570c830fcfbf801dd7751e9b567a5725334cf1cf9345efb3/checkov-2.2.315.tar.gz"
  sha256 "bf320d264c781111de87eee3845f1e84ab2a87f08aa4881d6de460a67cc83ceb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f19ea79e4fefdc47a0195255b4879fcffba3b020b67bd198e37450a55df7a83c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "788abfaf435ca616d996ee2db891af1c2cfe99be97df60034c9ede00b776b584"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aeef6e6f7dc3d512008622cba65b6b6fde5483d521a4f5fa9d0493a2103adf8e"
    sha256 cellar: :any_skip_relocation, ventura:        "503dd38865d80187487fabf34508f92a2e2dac9e341e887157244f5c3a41180d"
    sha256 cellar: :any_skip_relocation, monterey:       "db4a9ae10f5a8ffac2ea198c5a9bf5ebb043673fa390a40c3fa286cb6f4e456f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a9e9bbeaca5e4655e6460849f32fcd548d697430676ca323349d63e5152c23f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1297bb9d50900ce61475f531fec4be5de5d012e29421bd2f9f63c9e70ca13802"
  end

  depends_on "cmake" => :build # for igraph
  depends_on "python-tabulate"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/27/79/df72e25df0fdd9bf5a5ab068539731d27c5f2ae5654621ae0c92ceca94cf/aiodns-3.0.0.tar.gz"
    sha256 "946bdfabe743fceeeb093c8a010f5d1645f708a241be849e17edfb0e49e08cd6"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ff/4f/62d9859b7d4e6dc32feda67815c5f5ab4421e6909e48cbc970b6a40d60b7/aiohttp-3.8.3.tar.gz"
    sha256 "3828fb41b7203176b82fe5d699e0d845435f2374750a44b480ea6b930f6be269"
  end

  resource "aiomultiprocess" do
    url "https://files.pythonhosted.org/packages/59/30/64e01ec7ecb4aa1123b54401ffc36c16bb1d7155b924f7430a651fb956c1/aiomultiprocess-0.9.0.tar.gz"
    sha256 "07e7d5657697678d9d2825d4732dfd7655139762dee665167380797c02c68848"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ae/67/0952ed97a9793b4958e5736f6d2b346b414a2cd63e82d05940032f45b32f/aiosignal-1.3.1.tar.gz"
    sha256 "54cd96e15e1649b75d6c87526a6ff0b6c1b0dd3459f43d9ca11d48c339b68cfc"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
  end

  resource "async-timeout" do
    url "https://files.pythonhosted.org/packages/54/6e/9678f7b2993537452710ffb1750c62d2c26df438aa621ad5fa9d1507a43a/async-timeout-4.0.2.tar.gz"
    sha256 "2163e1640ddb52b7a8c80d0a67a08587e5d245cc9c553a74a847056bc2976b15"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "bc-detect-secrets" do
    url "https://files.pythonhosted.org/packages/02/f2/d1d870d526c722f22a491ebad1680e02ce935097d42af758a7a0e278f3c4/bc-detect-secrets-1.4.9.tar.gz"
    sha256 "445aa0b1b90c51cf289c71171f37775593fff416e3bba27956ef7279f1005106"
  end

  resource "bc-jsonpath-ng" do
    url "https://files.pythonhosted.org/packages/f3/71/11faab6bd73cb53798aa67a6c457495a7f2525115cf1ef1946e05c8725df/bc-jsonpath-ng-1.5.8.tar.gz"
    sha256 "c79388a3bfd00b52d8dd6cd600b637c377c9fca22faa7d30bbbc38cca9b06ee2"
  end

  resource "bc-python-hcl2" do
    url "https://files.pythonhosted.org/packages/83/30/23d56ecb6c572f84abd506a8af9e03fcccd69d342e7eafd25688d0ba46c1/bc-python-hcl2-0.3.51.tar.gz"
    sha256 "15bfecbae882ead998dd9300737237a14e40dfd8c973e5c7de7b4c92040a010f"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/69/48/5ed869a1d6d515962ec0f7446bdc4759f17e7ce8c1b047570643cb3eb8c8/boto3-1.26.59.tar.gz"
    sha256 "7d9cebb507fc96e6eb429621ccb2e731b75e7bbb8d6d9f0cf0c08089ee3c1ab7"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/05/42/7fa8a5090a7381cfdea10f3bad3fea3c867e248caca1f8ee2e6722568db0/botocore-1.29.59.tar.gz"
    sha256 "bc75d41c5eecf624a2f9875483135aa78088a50c8d29847793f92756697cfed5"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/4d/91/5837e9f9e77342bb4f3ffac19ba216eef2cd9b77d67456af420e7bafe51d/cachetools-5.3.0.tar.gz"
    sha256 "13dfddc7b8df938c21a940dfa6557ce6e94a2f1cdfa58eb90c805721d58f2c14"
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
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/4c/29/ff7cd69825b5bfb48e39853b75d5dc2e98a581730f2b6c9c014188730755/click-option-group-0.5.5.tar.gz"
    sha256 "78ee474f07a0ca0ef6c0317bb3ebe79387aafb0c4a1e03b1d8b2b0be1e42fc78"
  end

  resource "cloudsplaining" do
    url "https://files.pythonhosted.org/packages/d1/b0/0ec965daffb16dfdcae8d2a81be5474f21be37fd007cc1d0bf84f038a674/cloudsplaining-0.5.0.tar.gz"
    sha256 "59b9fb7dfd023297153adc13cce6695413019e13488d69f78bbde97682125489"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/c7/13/37ea7805ae3057992e96ecb1cffa2fa35c2ef4498543b846f90dd2348d8f/contextlib2-21.6.0.tar.gz"
    sha256 "ab1e2bfe1d01d968e1b7e8d9023bc51ef3509bba217bb730cee3827e1ee82869"
  end

  resource "cyclonedx-python-lib" do
    url "https://files.pythonhosted.org/packages/dd/0d/2d77978ff3ebe445c00ffc209eb205d126ef7a8ece69e7f3d014e561bada/cyclonedx_python_lib-3.1.5.tar.gz"
    sha256 "1ccd482024a30b95c4fffb3fe567a9df97b705f34c1075f8abde8537867600c3"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deep_merge" do
    url "https://files.pythonhosted.org/packages/a5/25/aa35c20acd8a4f515f9e4c8dee4c7731446234101a6dae0c34cf498bb342/deep_merge-0.0.4.tar.gz"
    sha256 "b54415f90934c42e334114e2864cb4d4e7335b34ad396e35ad8610c96065a47e"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/79/26/6609b51ecb418e12d1534d00b888ce7e108f38b47dc6cd589598d5c6aaa2/docker-6.0.1.tar.gz"
    sha256 "896c4282e5c7af5c45e8b683b0b0c33932974fe6e50fc6906a0a83616ab3da97"
  end

  resource "dockerfile-parse" do
    url "https://files.pythonhosted.org/packages/0f/c4/8c4fc1da93a67878b15eaac0d47f467c87be7a12406544b1b33e261a0454/dockerfile-parse-2.0.0.tar.gz"
    sha256 "21fe7d510642f2b61a999d45c3d9745f950e11fe6ba2497555b8f63782b78e45"
  end

  resource "dpath" do
    url "https://files.pythonhosted.org/packages/88/b2/abc5803f37a2ea1045d68765acfcb4ec166bc9e08c3ba451c53af29a73f2/dpath-1.5.0.tar.gz"
    sha256 "496615b4ea84236d18e0d286122de74869a60e0f87e2c7ec6787ff286c48361b"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/e9/10/d629476346112b85c912527b9080944fd2c39a816c2225413dbc0bb6fcc0/frozenlist-1.3.3.tar.gz"
    sha256 "58bcc55721e8a90b88332d6cd441261ebb22342e238296bb330968952fbb3a6a"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/ef/8d/50658d134d89e080bb33eb8e2f75d17563b5a9dfb75383ea1a78e1df6fff/GitPython-3.1.30.tar.gz"
    sha256 "769c2d83e13f5d938b7688479da374c4e3d49f71549aaf462b646db9602ea6f8"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "igraph" do
    url "https://files.pythonhosted.org/packages/8d/3d/86afa1a688b9b1e614ad19054c71004b165a6610e291d695f06621b44b8a/igraph-0.10.4.tar.gz"
    sha256 "4786e05919ee93f6479fe8ca697d68537edfe47549ed09dfb33bda4daced1fb9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "junit-xml" do
    url "https://files.pythonhosted.org/packages/98/af/bc988c914dd1ea2bc7540ecc6a0265c2b6faccc6d9cdb82f20e2094a8229/junit-xml-1.9.tar.gz"
    sha256 "de16a051990d4e25a3982b2dd9e89d671067548718866416faec14d9de56db9f"
  end

  resource "lark" do
    url "https://files.pythonhosted.org/packages/a2/25/8e16de418fc83bb00dabaf8c7110bc45a90bf5481a70aa5f1668fcea73bc/lark-1.1.5.tar.gz"
    sha256 "4b534eae1f9af5b4ea000bea95776350befe1981658eea3820a01c37e504bb4d"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/85/7e/133e943e97a943d2f1d8bae0c5060f8ac50e6691754eb9dbe036b047a9bb/Markdown-3.4.1.tar.gz"
    sha256 "3b809086bb6efad416156e00a0da66fe47618a5d6918dd688f53f40c8e4cfeff"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/4a/15/bd620f7a6eb9aa5112c4ef93e7031bcd071e0611763d8e17706ef8ba65e0/multidict-6.0.4.tar.gz"
    sha256 "3666906492efb76453c0e7b97f2cf459b0682e7402c0489a95484965dbc1da49"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/97/ae/7497bc5e1c84af95e585e3f98585c9f06c627fac6340984c4243053e8f44/networkx-2.6.3.tar.gz"
    sha256 "c0946ed31d71f1b732b5aaa6da5a0388a345019af232ce2f49c766e2d6795c51"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/59/ee/1e22fde9f8210b1bad0ada2a629d0e0c145627f546f793f0e5237109fe86/packageurl-python-0.10.4.tar.gz"
    sha256 "5c91334f942cd55d45eb0c67dd339a535ef90e25f05b9ec016ad188ed0ef9048"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "policy-sentry" do
    url "https://files.pythonhosted.org/packages/af/73/b12aba7c724feab12918aef54fa0f958db34c92d7560f62dfcca02e33b50/policy_sentry-0.12.5.tar.gz"
    sha256 "0f3c23a90a3236b9355ffdd55e5a8c53ba8ce5120ca521afde69132901d94bfb"
  end

  resource "policyuniverse" do
    url "https://files.pythonhosted.org/packages/4d/f0/70508150bc8c650025c14437e220358a59ebe568721a495ec5c8e7167d40/policyuniverse-1.5.0.20220613.tar.gz"
    sha256 "c66b1fb907750643a1987eb419b2112ae3f9c527c013429525f9fab989c9a2d7"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ba/b6/8e78337766d4c324ac22cb887ecc19487531f508dbf17d922b91492d55bb/prettytable-3.6.0.tar.gz"
    sha256 "2e0026af955b4ea67b22122f310b90eae890738c08cb0458693a49b6221530ac"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/01/50/e3015e6e03a3cf64113f509e8b86b71af37169b59ccedfcb182f3d031329/pycares-4.3.0.tar.gz"
    sha256 "c542696f6dac978e9d99192384745a65f80a7d9450501151e4a7563e06010d45"
  end

  resource "pycep-parser" do
    url "https://files.pythonhosted.org/packages/7f/22/a684b8df900e2808129383474e4ec8237b07fc5080518efbd90608e87e7c/pycep-parser-0.3.9.tar.gz"
    sha256 "6d3d1e18b497ec5db0d9b133a634f12f6431f6c61aff1d2fe83cfdf306b7d200"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/27/b5/92d404279fd5f4f0a17235211bb0f5ae7a0d9afb7f439086ec247441ed28/regex-2022.10.31.tar.gz"
    sha256 "a3a98921da9a1bf8457aeee6a551948a83601689e5ecdd736894ea9bbec77e83"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "schema" do
    url "https://files.pythonhosted.org/packages/4e/e8/01e1b46d9e04cdaee91c9c736d9117304df53361a191144c8eccda7f0ee9/schema-0.7.5.tar.gz"
    sha256 "f06717112c61895cabc4707752b88716e8420a8819d71404501e114f91043197"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "sortedcontainers" do
    url "https://files.pythonhosted.org/packages/e8/c4/ba2f8066cceb6f23394729afe52f3bf7adec04bf9ed2c820b39e19299111/sortedcontainers-2.4.0.tar.gz"
    sha256 "25caa5a06cc30b6b83d11423433f65d1f9d76c4c6a0c90e3379eaa43b9bfdb88"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/e5/4e/b2a54a21092ad2d5d70b0140e4080811bee06a39cc8481651579fe865c89/termcolor-2.2.0.tar.gz"
    sha256 "dfc8ac3f350788f23b2947b3e6cfa5a53b630b612e6cd8965a015a776020b99a"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/e4/84/4686ee611bb020038375c5f11fe7b6b3bb94ee78614a1faba45effe51591/texttable-1.6.7.tar.gz"
    sha256 "290348fb67f7746931bcdfd55ac7584ecd4e5b0846ab164333f0794b121760f2"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "update-checker" do
    url "https://files.pythonhosted.org/packages/5c/0b/1bec4a6cc60d33ce93d11a7bcf1aeffc7ad0aa114986073411be31395c6f/update_checker-0.18.0.tar.gz"
    sha256 "6a2d45bb4ac585884a6b03f9eade9161cedd9e8111545141e9aa9058932acb13"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/02/cd/1adc1276f1e8f6a929783f4c2992ec7a4934a81f8ced3d4a87191cc168c2/websocket-client-1.5.0.tar.gz"
    sha256 "561ca949e5bbb5d33409a37235db55c279235c78ee407802f1d2314fff8a8536"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/c4/1e/1b204050c601d5cd82b45d5c8f439cb6f744a2ce0c0a6f83be0ddf0dc7b2/yarl-1.8.2.tar.gz"
    sha256 "49d43402c6e3013ad0978602bf6bf5328535c48d192304b91b97a3c6790b1562"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/35/05/f81a74656c04e94f05c1ef186127cceb913493f1f8a21bb142a93c786ee8/zipp-3.12.0.tar.gz"
    sha256 "73efd63936398aac78fd92b6f4865190119d6c91b531532e798977ea8dd402eb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        versioning {
          enabled = true
        }
      }
    EOS

    output = shell_output("#{bin}/checkov -f #{testpath}/test.tf 2>&1", 1)
    assert_match "Passed checks: 4, Failed checks: 6, Skipped checks: 0", output

    (testpath/"test2.tf").write <<~EOS
      resource "aws_s3_bucket" "foo-bucket" {
        region        = "us-east-1"
        bucket        = "test"
        acl           = "public-read"
        force_destroy = true

        #checkov:skip=CKV_AWS_52
        #checkov:skip=CKV_AWS_20:The bucket is a public static content host
        versioning {
          enabled = true
        }
      }
    EOS
    output = shell_output("#{bin}/checkov -f #{testpath}/test2.tf 2>&1", 1)
    assert_match "Passed checks: 4, Failed checks: 5, Skipped checks: 1", output
  end
end
