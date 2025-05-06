class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  # TODO: remove `setuptools` from pypi_formula_mappings.json after https://review.opendev.org/c/openstack/pbr/+/924216
  url "https://files.pythonhosted.org/packages/81/81/afb257489a665cfc330129cc8bb74c4131a085c310eeb74cc86391c3dd06/python_openstackclient-8.0.0.tar.gz"
  sha256 "5b7a5e06893f833b5d296d019c50d42c7368e37748ee6be8e9b15655b999424e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "77b83d23f06af1b5c79620681e92ed0908673ec287fa56afd58fd1004db4d6fc"
    sha256 cellar: :any,                 arm64_sonoma:  "deafaede5af3f1775f7ac3137bd7595aff4800bb3fb719dd10b6e8b89fe0890d"
    sha256 cellar: :any,                 arm64_ventura: "41b5705d23ea14c61ae84599cbad7613187a9b5370700353b8606944a465dc58"
    sha256 cellar: :any,                 sonoma:        "e118b22f30959e97a33993c2cc2929eba4c02c38a5002108b965dc2cf52342a7"
    sha256 cellar: :any,                 ventura:       "00e5146fb5dac09a3776710acf055b96ee1129988036d1c2353004e2ed2b72d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "597b585e51c06b172855b186dd62f108140e07476b972da22e53091bfc24d9c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed9b7ae8f895dded24e0f300b49f58df4795d5a4444e600a4aa72f305124bdb2"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyinotify" do
    on_linux do
      url "https://files.pythonhosted.org/packages/e3/c0/fd5b18dde17c1249658521f69598f3252f11d9d7a980c5be8619970646e1/pyinotify-0.9.6.tar.gz"
      sha256 "9c998a5d7606ca835065cdabc013ae6c66eb9ea76a00a1e3bc6e0cfe2b4f71f4"
    end
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/62/74/c7fb720990b17da636064a7993506c230f7a913b752f0116ad2a2e39d621/cliff-4.9.1.tar.gz"
    sha256 "5b392198293c0b9225d459be8ba710cf8248f1ee33006bdeb3d92fb0012592b4"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/f7/2a/018fe937e25e1db0cafeb358c117644a58cdba24f5bbee69c003faf0b454/cmd2-2.5.11.tar.gz"
    sha256 "30a0d385021fbe4a4116672845e5695bbe56eb682f9096066776394f954a7429"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/43/fa/6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6b/decorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/cb/b7/2fa37f52b4f38bc8eb6d4923163dd822ca6f9e2f817378478a5de73b239e/dogpile_cache-1.3.4.tar.gz"
    sha256 "4f0295575f5fdd3f7e13c84ba8e36656971d1869a2081b4737ec99ede378a8c0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
  end

  resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
  end

  resource "jsonpath-rw-ext" do
    url "https://files.pythonhosted.org/packages/d5/f0/5d865b2543be45e3ab7a8c2ae8dfa5c3e56cfdd48f19d4455eb02f370386/jsonpath-rw-ext-1.2.2.tar.gz"
    sha256 "a9e44e803b6d87d135b09d1e5af0db4d4cf97ba62711a80aa51c8c721980a994"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6a/0a/eebeb1fa92507ea94016a2a790b93c2ae41a7e18778f85471dc54475ed25/jsonpointer-3.0.0.tar.gz"
    sha256 "2b2d729f2091522d61c3b31f82e11870f60b68f43fbc705cb76bf4b832af59ef"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "keystoneauth-websso" do
    url "https://files.pythonhosted.org/packages/bf/e0/f138694f014d5b43ecdec1e105db8a872c3f966ed4f96dbf736149f64ee6/keystoneauth_websso-0.2.0.tar.gz"
    sha256 "f381ad0583a1fe462630c939568c9f970dcdac1bb1915fd58fe8a1f126f0cc0a"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/59/f8/39aa1ac0c7fb9e7c8849f17e663eac208262689b7b9db02861b5e1093500/keystoneauth1-5.10.0.tar.gz"
    sha256 "34b870dbbcf806cdb5aec98483b62820a6568d364eca7b1174ca6a8b5a9c77ed"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/df/91/6c93b6a95e6a99ef929a99d019fbf5b5f7fd3368389a0b1ec7ce0a23565b/multipart-1.2.1.tar.gz"
    sha256 "829b909b67bc1ad1c6d4488fcdc6391c2847842b08323addf5200db88dbe9480"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/c2/9e/dc50e3821ba3dda7e94071a25f8daa34575d92752e94e0d3e8583064856e/openstacksdk-4.4.0.tar.gz"
    sha256 "157437563d64f3f6feec1796fbd8552d56277332461778c4dbe76d1828fd31e0"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/58/be/ba2e4d71dd57653c8fefe8577ade06bf5f87826e835b3c7d5bb513225227/os-client-config-2.1.0.tar.gz"
    sha256 "abc38a351f8c006d34f7ee5f3f648de5e3ecf6455cc5d76cfd889d291cdf3f4e"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/58/3f/09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ec/os-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/47/84/ecd798d1aee59b5501de21e8e69f98f5ba275464053be62309a4d4a4b85b/osc_lib-4.0.0.tar.gz"
    sha256 "1dd15dd64c2b62101487a0f774821839df6b2baa5abc1a572c8e6c53314ee3e7"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/e4/fb/5a692bbb4ce3fd59233dae986fec7ac53aca2a0053cf6218e452169071d8/osc_placement-4.6.0.tar.gz"
    sha256 "36ae070edbf76af42c1f0eccd7f6153a782040dbc910fbcd2ba7eeb02efd3b8d"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/3c/ac/aa17577d353a8c90b758a0edb1a94de7fffa24283c7f82cd2c485cb0a740/oslo_config-9.7.1.tar.gz"
    sha256 "5558b34bcc2b52f2208e80fcad955a4f7b2c41bb245b6451d43a621ad1263bbd"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/a3/65/17722b5f616aa129cee9b5f4a34952ffac7845f7a2cb842472b27c990caa/oslo_context-5.7.1.tar.gz"
    sha256 "0c511fe153732aff0c1b3b44abd2f51008a83c707bb929bee01e1255ac964889"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/cc/94/8ab2746a3251e805be8f7fd5243df44fe6289269ce9f7105bdbe418be90d/oslo_i18n-6.5.1.tar.gz"
    sha256 "ea856a70c5af7c76efb6590994231289deabe23be8477159d37901cef33b109d"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/72/e9/ed065144ab6dec839fe7bafebfa803b775eb2149db33878ca5ff613f6b11/oslo_log-7.1.0.tar.gz"
    sha256 "9a2b3c18be6f59152dfe25f34deabe71343db7fb8248a633967fb6a04707629d"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/a7/44/e7f2aaef66d7a02c74ce425f2bad8c4aaf11f39bb02fea98eeb7452a0910/oslo_serialization-5.7.0.tar.gz"
    sha256 "bdc4d3dd97b80639b3505e46d9aa439fc95028814177f30b91743e81366c3be7"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/f1/98/0c74172604f4ea9db117933fa9794e82a66438481a1e5a538584479c92f8/oslo_utils-8.2.0.tar.gz"
    sha256 "dcf78d14b968fb7b14263c77278b2b930a7861d3caa887d3a58b2890f6659835"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/01/d2/510cc0d218e753ba62a1bc1434651db3cd797a9716a0a66cc714cb4f0935/pbr-6.1.1.tar.gz"
    sha256 "93ea72ce6989eb2eed99d0f75721474f69ad88128afdef5ac377eb797c4bf76b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/b6/2d/7d512a3913d60623e7eb945c6d1b4f0bddf1d0b7ada5225274c87e5b53d1/platformdirs-4.3.7.tar.gz"
    sha256 "eb437d586b6a0986388f0d6f74aa0cde27b48d0e3d66843640bfb6bdcdb6e351"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/99/b1/85e18ac92afd08c533603e3393977b6bc1443043115a47bb094f3b98f94f/prettytable-3.16.0.tar.gz"
    sha256 "3c64b31719d961bf69c9a7e03d0c1e477320906a98da63952bc6698d6164ff57"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/9f/26/e25b4a374b4639e0c235527bbe31c0524f26eda701d79456a7e1877f4cc5/pyopenssl-25.0.0.tar.gz"
    sha256 "cd2cef799efa3936bb08e8ccb9433a575722b9dd986023f1cabc4ae64e9dac16"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/bb/22/f1129e69d94ffff626bdb5c835506b3a5b4f3d070f17ea295e12c2c6f60f/pyparsing-3.2.3.tar.gz"
    sha256 "b9c13f1ab8b3b542f72e28f634bad4de758ab3ce4546e4301970ad6fa77c38be"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-barbicanclient" do
    url "https://files.pythonhosted.org/packages/8b/43/6fe98492ea213d3e9d10bd666668790bea70f73b4f2eb17a10c26a030ceb/python_barbicanclient-7.1.0.tar.gz"
    sha256 "1394b72a7a2c46378d78a7f3a3c8fbec5fe7f8598ae5ead47522afd8ffdb1696"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/ed/25/a2bf747f91f86e25f56115499da2654b7cab849c816c0774128066da2a3e/python_cinderclient-9.7.0.tar.gz"
    sha256 "18c4501e549677984d85b0b10fd074efbd265e30add2a796d28176055a8d7dcf"
  end

  resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/3c/cb/f67c65313297d8a3d93975012a2ab2364740b153493e54598f87bc1705a2/python_cloudkittyclient-5.3.1.tar.gz"
    sha256 "3528e4fe2d7ad52304dbd5d61e0f65f8590a33714e92994e270f520ede4826af"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/e1/f9/f326c606aa5a1ce383c223b6fa58747ebf6049890085e68bb3001d76f4ae/python_designateclient-6.2.0.tar.gz"
    sha256 "d25c8f136c4ff1dedd4255df620ddacb6949740a1324f6ac1d3c593b320380ed"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/9d/55/996a756318b17f162665cbc9f7e6219d6dc56875684693f07a60c02d7148/python_glanceclient-4.8.0.tar.gz"
    sha256 "f85b6fc81f27b34da1c87484b3097659db0529abd1c67595d2f0fe7cb159036c"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/15/1a/d53aae3b7f281af51ee738b3b275ff781ee5b47e68992f8d90523624d9cd/python-heatclient-4.1.0.tar.gz"
    sha256 "d68499ce67031304e105b17c33f9ef63ffdac492f2414c4301539822c2ebf70d"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/c9/be/c8fa91c8c3554eceff66ba998af9f8b90b94c467353e251c9c05618f4eb7/python-ironicclient-5.10.0.tar.gz"
    sha256 "120d9e6a4ae2e7ed613ee2b2abdf9fe1d2f7de297a1b82d82d9be85987d4e0b6"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/91/d9/e6b430abdd77caccfc0f47005f7ff2125d143b16bd6f9aaa46ceaac75b90/python_keystoneclient-5.6.0.tar.gz"
    sha256 "721de2aec7710076389c674ee27b6712e97d86c7e0ff487b0b4409c8fcee10e7"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/71/d5/16f96df3637d21e2c70657726270cd535001fbc233aa0fc3dc10e2337d0e/python_magnumclient-4.8.1.tar.gz"
    sha256 "6cd7d6f4ca508603f773344a4eb4e0d1968727171c726d12ee86d67635a7e3b5"
  end

  resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/34/a6/d3969f862c0a5c512233c4e6e764738b25acbb4149e23d9f04f837abb3e3/python_manilaclient-5.4.0.tar.gz"
    sha256 "e7c018673a45c06e157760175b5598c736ca46d32b8bb73263b91ba2abfd10df"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/f4/e7/90ffb6e62715db2856d2b1e245c147abffbd0812c444caa51ccaa210cd99/python_mistralclient-5.4.0.tar.gz"
    sha256 "38e34060e89cf2bef4d750f131f61f86a45738d345d0d3918061c76e3f04d968"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/62/f5/43ac046c8bc32068faccd4d0b79e44c08ec96b7104a0ac70974c2a17ac76/python-neutronclient-11.4.0.tar.gz"
    sha256 "8741219362e4bf9c2e43f2e6cae4d4991ed8f9df9063f43408a0b658b03d62e2"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/b5/10/feaf9e2365c99739b1530f31f19e98ec3817543d156bf76a0458d27cbeb4/python_octaviaclient-3.10.0.tar.gz"
    sha256 "db2667b8f7611b27c48d2e5b2d76d18e197fbfe990cb2cd896fde06f3b4d6228"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/6b/75/80d296c0ee9d48acde631adae21877b8199c3d8facaedfad998d87bbea56/python_swiftclient-4.7.0.tar.gz"
    sha256 "afd7575753d8e49617adcb11550187fd0b120fcd819f1e782c0b538f2d093773"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/0b/b3/52b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41/rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/28/3f/13cacea96900bbd31bb05c6b74135f85d15564fc583802be56976c940470/stevedore-5.4.1.tar.gz"
    sha256 "3135b5ae50fe12816ef291baff420acb727fcd356106e3e9cbfa9e5985cd6f4b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/76/ad/cd3e3465232ec2416ae9b983f27b9e94dc8171d56ac99b345319a9475967/typing_extensions-4.13.1.tar.gz"
    sha256 "98795af00fb9640edec5b8e31fc647597b4691f099ad75f469a2616be1a76dff"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/de/cf/ba9ac96d09b797c377e2c12c0eb6b19565f3b2a2efb55932d319e319b622/warlock-2.0.1.tar.gz"
    sha256 "99abbf9525b2a77f2cde896d3a9f18a5b4590db063db65e08207694d2e0137fc"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c3/fc/e91cc220803d7bc4db93fb02facd8461c37364151b8494762cc88b0fbcef/wrapt-1.17.2.tar.gz"
    sha256 "41388e9d4d1522446fe79d3213196bd9e3b301a336965b9e27ca2788ebd122f3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "resource provider list", # osc-placement
      "stack list", # python-heatclient
      "loadbalancer list", # python-octaviaclient
      "rating summary get", # python-cloudkittyclient
      "zone list", # python-designateclient
      "secret list", # python-barbicanclient
      "share list", # python-manliaclient
      "workflow list", # python-mistralclient
      "coe cluster list", # python-magnumclient
      "baremetal node list", # python-ironicclient
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
