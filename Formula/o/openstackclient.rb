class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/a5/8f/7852b32aa5759ab9333b5ad50834304e61bf06b87fa01ad82063e12411aa/python_openstackclient-8.2.0.tar.gz"
  sha256 "d612af18dfc66cc8f31e6ce96690b6c273ade8a240ec40b7f4835a8896fbbe01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "38c19df017848e89e2eaa89173b47d4e842397814b5418f5aa3136fc95ce1385"
    sha256 cellar: :any,                 arm64_sequoia: "c8eb1a45cb080c41c2d46d6517cd20f32113e73e1072b65614d5220c8d1b5af4"
    sha256 cellar: :any,                 arm64_sonoma:  "19b02e7203b8780817bb5b08970f66799841be35c70bedc978598ef32354ef58"
    sha256 cellar: :any,                 arm64_ventura: "4c3b32140dc294bcc0c75afcb1e4e0f37fb8e6a4647bd2cde2aac310493e06bd"
    sha256 cellar: :any,                 sonoma:        "6690d758248c43018747f81dfb296bdf422577ad844b23134f170b27c5d063d4"
    sha256 cellar: :any,                 ventura:       "e9514e0463ee461e5799fd46619417f933b8c760367c3717846d808ecdda500d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9b1fec0eb815b7f621a764373b75f750cfa09b4b9f477080a2305feb77a7486"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5df1c2041f6baaa94b60dcd05fc215ae8acf0956e2991e5557321ef9c210e43"
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
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/8d/43/6974bae8a54e8e49aea448f2897ba1af4d261b95328a3cc112fa0e290b1a/cliff-4.11.0.tar.gz"
    sha256 "aa33c11ac2fecdf2d1eaffea9d5d0eb4584b8e777673bb55d42a693e34ccc429"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/75/68/4bf43d284e41c01c6011146e5c2824aa6f17a3bb1ef10ba3dbbae5cf31dc/cmd2-2.7.0.tar.gz"
    sha256 "81d8135b46210e1d03a5a810baf859069a62214788ceeec3588f44eed86fbeeb"
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
    url "https://files.pythonhosted.org/packages/e8/07/2257f13f9cd77e71f62076d220b7b59e1f11a70b90eb1e3ef8bdf0f14b34/dogpile_cache-1.4.0.tar.gz"
    sha256 "b00a9e2f409cf9bf48c2e7a3e3e68dac5fa75913acbf1a62f827c812d35f3d09"
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
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/bf/ce/46fbd9c8119cfc3581ee5643ea49464d168028cfb5caff5fc0596d0cf914/jsonschema_specifications-2025.4.1.tar.gz"
    sha256 "630159c9f4dbea161a6a2205c3011cc4f18ff381b189fff48bb39b9bf26ae608"
  end

  resource "keystoneauth-websso" do
    url "https://files.pythonhosted.org/packages/81/11/1a198546433935822501450494754df6150258772d918ce73a1e095aa3f4/keystoneauth_websso-0.2.4.tar.gz"
    sha256 "4a936c777a6bd0a06cd943f99269a45d4ee40b6fc78c4ae6c333709688d9ffb5"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/e5/16/b96df223ca7ea4bfa78034b205e0eaf4875bfecb2f119f375fc5232d2061/keystoneauth1-5.12.0.tar.gz"
    sha256 "dd113c2f3dcb418d9f761c73b8cd43a96ddfa8a612b51c576822381f39ca4ae8"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/45/b1/ea4f68038a18c77c9467400d166d74c4ffa536f34761f7983a104357e614/msgpack-1.1.1.tar.gz"
    sha256 "77b79ce34a2bdab2594f490c8e80dd62a02d650b91a75159a63ec413b8d104cd"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/6d/c9/c6f5ab81bae667d4fe42a58df29f4c2db6ad8377cfd0e9baa729e4fa3ebb/multipart-1.3.0.tar.gz"
    sha256 "a46bd6b0eb4c1ba865beb88ddd886012a3da709b6e7b86084fc37e99087e5cf1"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/92/c2/a3521476b32fd0a25e842632d6e4d5cca401ff6e5c456d8a824194eb1f38/openstacksdk-4.7.0.tar.gz"
    sha256 "ee6b853897b3eef347fa5042187174026ad181a95ff6e6933841f5f9c697b1bd"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/50/cd/352f6f18d1fb90780b95fdc3a668a279bd41d89905d70ee06076b529077c/os_client_config-2.3.0.tar.gz"
    sha256 "e16a260f2fd500af14f157b9b7b7d69292ce83b0f8a461ec68ce6a8a42967cbd"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/9d/e9/1725288a94496d7780cd1624d16b86b7ed596960595d5742f051c4b90df5/os_service_types-1.8.0.tar.gz"
    sha256 "890ce74f132ca334c2b23f0025112b47c6926da6d28c2f75bcfc0a83dea3603e"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/7c/63/ea0eda39e1b2c0ca3e9d87798568f881ea7aa90e4f94affb78676215f72d/osc_lib-4.2.0.tar.gz"
    sha256 "99718f06a990c1ad6fb9034bbed9655390a2ea83cef71a53781e7e9abd9f20ce"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/e4/fb/5a692bbb4ce3fd59233dae986fec7ac53aca2a0053cf6218e452169071d8/osc_placement-4.6.0.tar.gz"
    sha256 "36ae070edbf76af42c1f0eccd7f6153a782040dbc910fbcd2ba7eeb02efd3b8d"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/03/67/221128a241ab4151ecc5b101de23651e7c08491f7b2edea31744207a23dc/oslo_config-10.0.0.tar.gz"
    sha256 "333e675db8c6be7715b3decf78c398ca1138439225aa274632e89314837f6ea3"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/2a/6c/e1e7db0505ff70881336fb6865846885d1ff24fa7fd8e5cdd91016c35f07/oslo_context-6.0.0.tar.gz"
    sha256 "151e8228982d3885ed3fed288e8cddb26f894fb40cb8132129fa9e5b3e0ef0bd"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/cc/94/8ab2746a3251e805be8f7fd5243df44fe6289269ce9f7105bdbe418be90d/oslo_i18n-6.5.1.tar.gz"
    sha256 "ea856a70c5af7c76efb6590994231289deabe23be8477159d37901cef33b109d"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/de/f8/5f167d6f072a75f6a9b3982418a58636f9ae50688c29a45f720e3e018c1e/oslo_log-7.2.0.tar.gz"
    sha256 "963fa3d08f9ab34efc8c8cb2217bb48a78538a6d3a4688905b4efb123a303cea"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/a7/44/e7f2aaef66d7a02c74ce425f2bad8c4aaf11f39bb02fea98eeb7452a0910/oslo_serialization-5.7.0.tar.gz"
    sha256 "bdc4d3dd97b80639b3505e46d9aa439fc95028814177f30b91743e81366c3be7"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/9e/45/f381d0308a7679975ec0e8409ce133136ea96c1ed6a314eb31dcd700c7d8/oslo_utils-9.0.0.tar.gz"
    sha256 "d45a1b90ea1496589562d38fe843fda7fa247f9a7e61784885991d20fb663a43"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/ad/8d/23253ab92d4731eb34383a69b39568ca63a1685bec1e9946e91a32fc87ad/pbr-7.0.1.tar.gz"
    sha256 "3ecbcb11d2b8551588ec816b3756b1eb4394186c3b689b17e04850dfc20f7e57"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
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

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/04/8c/cd89ad05804f8e3c17dea8f178c3f40eeab5694c30e0c9f5bcd49f576fc3/pyopenssl-25.1.0.tar.gz"
    sha256 "8d031884482e0c67ee92bf9a4d8cceb08d92aba7136432ffb0703c5280fc205b"
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
    url "https://files.pythonhosted.org/packages/31/03/96a90b0a83c8e033a8d8d679e457acad18439f5de4a8a1b4a826ff02c412/python_designateclient-6.3.0.tar.gz"
    sha256 "9aabf25e5ff69b15fb6209f9851c507d9499e63c6926245672ff0e495986e778"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/a6/8c/3979b6c6e91553ef39231862bef377fe86f53d177c18ae4424da2acfbc68/python_glanceclient-4.9.0.tar.gz"
    sha256 "f8f00d90220ef30b4b16057ae0c7c42cc29d84721c067b6854d539d2c5ddb154"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/6b/38/1a6a0def362dae922e559c1dfcb553c3be8b3b859fd0943a12a697d9271f/python_heatclient-4.3.0.tar.gz"
    sha256 "8ada7ceb77f25f0dbe3ae2e3328a30461adb94ffbf36b0c2aabc2cce483b75f0"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/83/4b/c62a64a6a1b6b10edf1996e2e497ca8ae0ea7a1c1e9af97a974e168c3d56/python_ironicclient-5.12.0.tar.gz"
    sha256 "f3fdefb096ff04d9174000e20a9443871f07d12d94eb6b1d3efb64bbdc99af5d"
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
    url "https://files.pythonhosted.org/packages/f8/cc/7579afae20b6a7c77879fc6ace6295bf1943b6688ea35198c570bea4d97b/python_manilaclient-5.5.0.tar.gz"
    sha256 "c0f615674f9af60f883f7977787f603165df7b95465337a6eea58439667ebe5a"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/f4/e7/90ffb6e62715db2856d2b1e245c147abffbd0812c444caa51ccaa210cd99/python_mistralclient-5.4.0.tar.gz"
    sha256 "38e34060e89cf2bef4d750f131f61f86a45738d345d0d3918061c76e3f04d968"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/57/15/96f2f42df4c1d6873c89a0cae2ba3b98f83273e965421eb11b7dbb257b4d/python_neutronclient-11.6.0.tar.gz"
    sha256 "3c6958088d18c8676a10abf9d94b8dbf1a984741cbb988554f216880797e072f"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/96/ca/276ce2e9e43c7c148b10d09f4a56f10d1d448792c9d20798395d522b6cc2/python_octaviaclient-3.11.1.tar.gz"
    sha256 "33e25150cb13ab8ebe529a92285cefb515ec69ba14293baac16b36f6fd3dab4e"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/57/a7/a30bf9fd517d7cc75fb111540c9962c166b9e9539d2ba2afab14a6aa1aa3/python_swiftclient-4.8.0.tar.gz"
    sha256 "44162cab469368cafdc25e0c8c4e95a2b9db1a44456a48ce080fe2ca9a4b3863"
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
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/71/a6/34460d81e5534f6d2fc8e8d91ff99a5835fdca53578eac89e4f37b3a7c6d/rich_argparse-1.7.1.tar.gz"
    sha256 "d7a493cde94043e41ea68fb43a74405fa178de981bf7b800f7a3bd02ac5c27be"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/1e/d9/991a0dee12d9fc53ed027e26a26a64b151d77252ac477e22666b9688bc16/rpds_py-0.27.0.tar.gz"
    sha256 "8b23cf252f180cda89220b378d917180f29d313cd6a07b2431c0d3b776aae86f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
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
    url "https://files.pythonhosted.org/packages/98/5a/da40306b885cc8c09109dc2e1abd358d5684b1425678151cdaed4731c822/typing_extensions-4.14.1.tar.gz"
    sha256 "38b39f4aeeab64884ce9f74c94263ef78f3c22467c8724005483154c26648d36"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/29/c2/3ba4daeddd47f1cfdbc703048cbee27bcbc50535261a2bbe36412565f3c9/warlock-2.1.0.tar.gz"
    sha256 "82319ba017341e7fcdc81efc2be9dd2f8237a0da07c71476b5425651b317b1c9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
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
