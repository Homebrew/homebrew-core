class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https://gitlab.com/duplicity/duplicity"
  url "https://files.pythonhosted.org/packages/fe/36/0bcb50f8888d1f2384e556ede3bd209cd3993108dcf54ef09cd7ff512999/duplicity-1.2.1.tar.gz"
  sha256 "15d768fb0ab86a30d734011e6e6371b3c6752e13ab239057c22d291324932099"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6ed485d456ae46f102c956a15831ef93d42f6e6b7abe68a5b2ed4a656a9f9e97"
    sha256 cellar: :any,                 arm64_monterey: "9c70e5f402724aab24ca16ea9742ee62db2f37d0bfeec5e0f65ffd25a0de9d66"
    sha256 cellar: :any,                 arm64_big_sur:  "94a00f4b617c7e34bd75f6f0c80bd8f4cb14511bf9b1aa7dcb4f8947654aca75"
    sha256 cellar: :any,                 ventura:        "2b82cf581ee51aba9241190df631cfeadcefbe7ad28fa18f5436f7a85cc5c1b5"
    sha256 cellar: :any,                 monterey:       "7fae7f98c77d17da5dff0273cd935ff0239c9244dbe65435340be8cca85e7f4b"
    sha256 cellar: :any,                 big_sur:        "afca506e2207b9f9b3462318beeefd46e1ad3019d0617e8f299fb42ab656da61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c796cea89af9aee875367b98336353bb87937f4a46a0c070fe2e8e56e5f8fb63"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "gnupg"
  depends_on "librsync"
  depends_on "openssl@1.1"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/4f/ec/3ba46ff4deebe738b7213997fc856553282e971a767b6291e05aca9d9566/azure-core-1.26.1.zip"
    sha256 "223b0e90cbdd1f03c41b195b03239899843f20d00964dbb85e64386873414a2d"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/e8/72/a834f1a89f8b66e717d7cddc88ff182fb860130c4ff78f87a286eec602be/azure-storage-blob-12.14.1.zip"
    sha256 "860d4d82985a4bfc7d3271e71275af330f54f330a754355435a7ba749ccde997"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/3f/6c/15582dbc9340586b6ee1d43070a43753cc9d1c3522db13cd38779f25a479/b2sdk-1.18.0.tar.gz"
    sha256 "9272f28d18d498b66d33d749a0f05e49d9bb1a9134f94261c0b8bfa1b56f3eec"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/bf/05/c256c7936520cc265f7561b5180920e986321916d341e7399fc5de5bea6b/boto3-1.26.22.tar.gz"
    sha256 "f16c3aef1432c5083a9e1c36ac08b70b9072e87205e970f8d7520b10b964858f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9f/4b/3fa75a66e5b21cf49793fd96b9fd5d91b5e1758258849bbd0800ef872f39/botocore-1.29.22.tar.gz"
    sha256 "ce637e3537388200775d80c5a3170df4810ddf7afbd7883db5673279b2584f68"
  end

  resource "boxsdk" do
    url "https://files.pythonhosted.org/packages/e2/60/7c2f41d27d7ff39fbb139782e9434bf7a4db5286c6fdb6f3b686fb85311f/boxsdk-3.5.1.tar.gz"
    sha256 "1ef7286c2ee26c69d1f200fad75501ac3b64e0e0bb729c72d3d647c50d431316"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/e3/3f/41186b1f2fd86a542d399175f6b8e43f82cd4dfa51235a0b030a042b811a/cryptography-38.0.4.tar.gz"
    sha256 "175c1a818b87c9ac80bb7377f5520b7f31b3ef2a0004e2420319beadedb67290"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c8/7d/904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211a/debtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/89/d7/42792461014f5c434e070c8d4727a7e8aa1ed1e24726a62bbececc7b49dd/dropbox-11.36.0.tar.gz"
    sha256 "830ce522d8bc3905b4a99b67dc009aa9542550d1de9fa1743c1927de70888b47"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/f5/9a/e613fc7f7fa157bea028d8d823a13ba5583a49a2dea926ca86b6cbf0fd00/fasteners-0.18.tar.gz"
    sha256 "cb7c13ef91e0c7e4fe4af38ecaf6b904ec3f5ce0dda06d34924b6b74b869d953"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "gdata-python3" do
    url "https://files.pythonhosted.org/packages/de/13/7c54a70f2d415750408b22f6a5ede98d33c0f1da9a40449926e8a2037723/gdata-python3-3.0.1.tar.gz"
    sha256 "b77301becfb3bf42e9a459169e75e6ff4c20cc7b7e247d4d84988e8c8ac6d898"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/2b/15/7bafa5379a228ed72baf769eea5e6019a944469fe637ea0742c0351109bf/google-api-core-2.11.0.tar.gz"
    sha256 "4b9bb5d5a380a0befa0573b302651b8a9a89262c1730e37bf423cec511804c22"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/bc/de/8b6eb80aa71052f5ae6126822413f40fb8c0038cca8717df91dc4d267863/google-api-python-client-2.68.0.tar.gz"
    sha256 "19177411b7dcf8fcd66bff085c6838ecea5fd6b598998d594be1f7290dfc34b4"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/52/a6/72c80f4a0b37c2c32d35636b2373bdf07c1dad81b109f9361742d3aa1cbe/google-auth-2.15.0.tar.gz"
    sha256 "72f12a6cfc968d754d7bdab369c5c5c16032106e52d32c6dfd8484e4c01a6d1f"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/fb/d1/afcdd1611dc768ed3757a021a6e9410275ae27c6b26b84623bc0f9f706dc/google-auth-oauthlib-0.7.1.tar.gz"
    sha256 "9940f543f77d1447432a93781d7c931fb53e418023351ad4bf9e92837a1154ec"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/c5/db/9b98c3a9e148b5daaa2e26ce4faeb6ade28dc623dcc109f2ac7efee514de/googleapis-common-protos-1.57.0.tar.gz"
    sha256 "27a849d6205838fb6cc3c1c21cb9800707a661bb21c6ce7fb13e99eb1f8a0c46"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/c2/37/a093aaa902f6b2301f0f2cff5285548dbc4ab9b9a29215eb440381cbb32b/httplib2-0.21.0.tar.gz"
    sha256 "fc144f091c7286b82bec71bdbd9b27323ba709cc612568d3000893bfd9cb4b34"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/51/19/3e1adf0e7a8c8361496b085edcab2ddcd85410735a2b6fdd044247fc5b75/humanize-4.4.0.tar.gz"
    sha256 "efb2584565cc86b7ea87a977a15066de34cdedaf341b11c851cfcfd2b964779c"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/32/5a/e0d75c8010295ae6746f379f5324bc726076dfc426548bfa6f0763fce870/importlib_metadata-5.1.0.tar.gz"
    sha256 "d5059f9f1e8e41f80e9c56c2ee58811450c31984dfa625329ffd7c0dad88a73b"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/31/8c/1c342fdd2f4af0857684d16af766201393ef53318c15fa785fcb6c3b7c32/iso8601-1.1.0.tar.gz"
    sha256 "32811e7b81deee2063ea6d2e94f8819a86d1f3811e49d23623a41fa832bef03f"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jottalib" do
    url "https://files.pythonhosted.org/packages/aa/4b/7a5dea988a7a76842738fa23ff8e397109ccb0a85702d10153ce9e46c3ca/jottalib-0.5.1.tar.gz"
    sha256 "015c9a1772f06a2ad496278aff4b20ad41acc660304fa8f8b854932c662bb0a5"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/1c/35/c22960f14f5e17384296b2f09da259f8b5244fb3831eccec71cf948a49c6/keyring-23.11.0.tar.gz"
    sha256 "ad192263e2cdd5f12875dedc2da13534359a7e760e77f8d04b50968a821c2361"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/d4/d5/5ced8d6865f4dae2eba917e17e3e067dddde385b2858fe24079f1f472629/keystoneauth1-5.1.0.tar.gz"
    sha256 "9ef7b4b719a79a4a04387a6aa558a7b6ca4adf18b8131f186acaf0643ff97bbe"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  resource "megatools" do
    url "https://files.pythonhosted.org/packages/69/0e/cc12d8dfa5cee8b11c72179de7b23b00d1c1555dfe8c25101d88ae86a7ec/megatools-0.0.4.tar.gz"
    sha256 "4418b67fd6ec4b9417d32e2a153a1757d47bc2819b32c155d744640345630112"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/68/77/8397c8fb8fc257d8ea0fa66f8068e073278c65f05acb17dcb22a02bfdc42/msrest-0.7.1.zip"
    sha256 "6e7661f46f3afd88b75667b7187a92829924446c7ea1d169be8c4bb7eeb788b9"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/58/3f/09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ec/os-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/c0/b0/e6c8f1a543978b6909e1a8b733eb8e5e7b8ede2b29f7e83c8638169eae36/oslo.config-9.0.0.tar.gz"
    sha256 "3b6b63c43cf1e09344ba850bcb11d6f2b9201086fbeb0a97a8950e7eac3f2645"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/7c/d8/a56cdadc3eb21f399327c45662e96479cb73beee0d602769b7847e857e7d/oslo.i18n-5.1.0.tar.gz"
    sha256 "6bf111a6357d5449640852de4640eae4159b5562bbba4c90febb0034abc095d0"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/c0/00/166651f281396a57d5342f1d8be772c7f54bbb128b6753ee8bf3943ad7e6/oslo.serialization-5.0.0.tar.gz"
    sha256 "2845328d0f47dc8a23fed2a82253e90acff0aa731dbd24f379cf8e50e6cc66ba"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/f7/49/7f6790af38e9ce1a1418dd74c7d07492d711384269b1cecc69bef136b033/oslo.utils-6.1.0.tar.gz"
    sha256 "76bc0108d50aca972b68fec8298e791b5fbcbeb9a51a27c6986b41b0a6a62eeb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/98/75/e78ddbe671a4a59514b59bc6a321263118e4ac3fe88175dd784d1a47a00f/paramiko-2.12.0.tar.gz"
    sha256 "376885c05c5d6aa6e1f4608aac2a6b5b0548b1add40274477324605903d9cd49"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/96/72/6c06803e83df69e27d3d94edf0ec0ef2b5761446cf59cdf35609ed96ce28/protobuf-4.21.10.tar.gz"
    sha256 "4d97c16c0d11155b3714a29245461f0eb60cace294455077f3a3b8a629afa383"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/88/87/72eb9ccf8a58021c542de2588a867dbefc7556e14b2866d1e40e9e2b587e/pyasn1-modules-0.2.8.tar.gz"
    sha256 "905f84c712230b2c592c19470d3ca8d552de726050d1d1716282a1f6146be65e"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "PyDrive2" do
    url "https://files.pythonhosted.org/packages/05/e8/4d227db64308b3ccc81e7ef5df2432c4b97ecc835b9f291fd07f5be93c58/PyDrive2-1.15.0.tar.gz"
    sha256 "3ae06b66bf963f43524989c87f4d678039441fe059993c6703fb33cc3c6d8aec"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/75/65/db64904a7f23e12dbf0565b53de01db04d848a497c6c9b87e102f74c9304/PyJWT-2.6.0.tar.gz"
    sha256 "69285c7e31fc44f68a1feb309e948e0df53259d579295e6cfe2b1792329f05fd"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/e7/2f/c6d89edac75482f11e231b644e365d31d5479b7b727734e6a8f3d00decd5/pyOpenSSL-22.1.0.tar.gz"
    sha256 "7a83b7b272dd595222d672f5ce29aa030f1fb837630ef229f62e72e395ce8968"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/a0/dd/81d3d89231a09445e4b2a13a374aeed8f3abb82ff7c0ecb5da87bebb6790/python-keystoneclient-5.0.1.tar.gz"
    sha256 "a8bbf671f56c24aa5a37a225b98f2994b82063d73e3486657eb500a33a406d29"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/93/bc/e9fa2d72443623df0561d86f576aeadc1cd95a8dfe551d2724c4f6da2552/python-swiftclient-4.1.0.tar.gz"
    sha256 "f82298e4a48f7cbdd680f2638c85d1ca7ae1a76edbe30036d21b4cd7a29c09eb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/0c/4c/07f01c6ac44f7784fa399137fbc8d0cdc1b5d35304e8c0f278ad82105b58/requests-toolbelt-0.10.1.tar.gz"
    sha256 "62e09f7ff5ccbda92772a29f394a49c3ad6cb181d568b1337626b2abb628a63d"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/aa/65/7d973b89c4d2351d7fb232c2e452547ddfa243e93131e7cfa766da627b52/rsa-4.9.tar.gz"
    sha256 "e38464a49c6c85d7f1351b0126661487a7e0a14a50f1675ec50eb34d4f20ef21"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
  end

  # Using GitHub tarball as requirements.txt is missing from PyPI tarball.
  # Issue ref: https://github.com/dropbox/stone/issues/266
  resource "stone" do
    url "https://github.com/dropbox/stone/archive/refs/tags/v3.3.1.tar.gz"
    sha256 "dc5aff3fad1333188d4ddb4eee0a19d31e6262bb3cdf10c0bbdaeb309ff91a52"
  end

  resource "tlslite-ng" do
    url "https://files.pythonhosted.org/packages/cd/95/4311e6b70ded82035b7f3a92bfe5ea350e6d9effe925493ac31ccaf924cc/tlslite-ng-0.7.6.tar.gz"
    sha256 "6ab56f0e9629ce3d807eb528c9112defa9f2e00af2b2961254e8429ca5c1ff00"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/d2/5a/4742fdba39cd02a56226815abfa72fe0aa81c33bed16ed045647d6000eba/uritemplate-4.1.1.tar.gz"
    sha256 "4346edfc5c3b79f694bccd6d6099a322bbeb628dbf2cd86eea55a456ce5124f0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/8e/b3/8b16a007184714f71157b1a71bbe632c5d66dd43bc8152b3c799b13881e1/zipp-3.11.0.tar.gz"
    sha256 "a7a22e05929290a67401440b39690ae6563279bced5f314609d9d03798f56766"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resource("pytz") # `pytz` should be installed before `pbr`
    venv.pip_install resources
    venv.pip_install_and_link(buildpath, link_manpages: true)
  end

  test do
    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS

    system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"
    begin
      (testpath/"test/hello.txt").write "Hello!"
      (testpath/"command.sh").write <<~EOS
        #!/bin/sh
        ulimit -n 1024
        PASSPHRASE=brew #{bin}/duplicity #{testpath} "file://test"
      EOS
      chmod 0555, testpath/"command.sh"
      system "./command.sh"
      assert_match "duplicity-full-signatures", Dir["test/*"].to_s

      # Ensure requests[security] is activated
      script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
      system libexec/"bin/python", "-c", script
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
