class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  # TODO: remove `setuptools` from pypi_formula_mappings.json after https://review.opendev.org/c/openstack/pbr/+/924216
  url "https://files.pythonhosted.org/packages/5e/df/ffc770c88d551f1845411efa572a9657f65300e24a82c5a558c5139b86c3/python-openstackclient-7.2.1.tar.gz"
  sha256 "eb9abe56b52726245b99bdfb539a6cd5196c052039809703c65c69049e44ca39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b278c12bb7f9f1b35117814b6f146497fdff8fc729d5c8aec095e7b3cf36fe5"
    sha256 cellar: :any,                 arm64_sonoma:  "69dd38a7f51009f3eeb927a647fd0f38f7b32dff7b3ee9d5d8add875cf54d294"
    sha256 cellar: :any,                 arm64_ventura: "f9e7f8beff82440920d6565e6a72e20a71838a16ca200404c4f5a089a95ffb64"
    sha256 cellar: :any,                 sonoma:        "33ba0df65a0948ba2159e990e82da3188531da29b13d86f4170d9a4009858900"
    sha256 cellar: :any,                 ventura:       "9c491757a8a364cd95b764fd1f38758bb35757f6d40882359ddae1cbe874246d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1ebd65563cb6bcb8eaea1052cd831d0a5e126b0908d77e7964bd73463d631d2"
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
    url "https://files.pythonhosted.org/packages/fc/0f/aafca9af9315aee06a89ffde799a10a582fe8de76c563ee80bbcdc08b3fb/attrs-24.2.0.tar.gz"
    sha256 "5cfb1b9148b5b086569baec03f20d7b6bf3bcacc9a42bebf87ffaaca362f6346"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/2a/74/f1bc80f23eeba13393b7222b11d95ca3af2c1e28edca18af487137eefed9/babel-2.16.0.tar.gz"
    sha256 "d1f3554ca26605fe173f3de0c65f750f5a42f924499bf134de6423582298e316"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/3c/1c/213ba67600827d8c8cb2b30f1e5471e298b766505341b7fe7c8486cdc388/cliff-4.7.0.tar.gz"
    sha256 "6ca45f8df519bbc0722c61049de7b7e442a465fa7f3f552b96d735fa26fd5b26"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/b1/f8/1d6f1a54378a12acc9e8cc68aa69e2463bbb02f75878da4ad0c5e4d37751/cmd2-2.5.0.tar.gz"
    sha256 "36292d144e5fd62549b50e94e5f36514557fb92e615155ac28763ea4bc13b954"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/81/3b/83ce66995ce658ad63b86f7ca83943c466133108f20edc7056d4e0f41347/dogpile.cache-1.3.3.tar.gz"
    sha256 "f84b8ed0b0fb297d151055447fa8dcaf7bae566d4dbdefecdcc1f37662ab588b"
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
    url "https://files.pythonhosted.org/packages/09/9e/c11b6f5b97f0a5671b61c4908ecae0c6fb879323699c116a8a9040fff6f0/keystoneauth1-5.8.0.tar.gz"
    sha256 "3157c212e121164de64d63e5ef7e1daad2bd3649a68de1e971b76877019ef1c4"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "multipart" do
    url "https://files.pythonhosted.org/packages/ee/fc/03c4a1db15b4365cddb7f18285267b599744a048f8e1a98759cf677e33f0/multipart-1.1.0.tar.gz"
    sha256 "ee32683f5c454740cd9139e1d6057053823da0729c426f156464f81111529ba1"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/32/7b/42529e0014cf5c3e1a4f4c07ed43c1df357d57f5f61ca15cbdbfdd229654/openstacksdk-4.1.0.tar.gz"
    sha256 "ccac9b158e3d36b959a3bdce71bd4f883d7758fef6856841c855ff2b22c941ea"
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
    url "https://files.pythonhosted.org/packages/56/42/a85b60f90efd29bade74d2e4fee287339b8a5b20377736fd2aac7378492d/osc-lib-3.1.0.tar.gz"
    sha256 "ef085249a8764b6f29d404eda566a261a3003502aa431b39ffd54307ee103e19"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/81/85/e6e14d13639656da6bf91f27376cf7352ea98b1624701868a097bf41020a/osc-placement-4.5.0.tar.gz"
    sha256 "831d67419d1efffba6f57cd228a9fdb169275647e4a9537eb275662656b7cd8f"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/42/92/f53acc4f8bb37ba50722b9ba03f53fd507adc434d821552d79d34ca87d2f/oslo.config-9.6.0.tar.gz"
    sha256 "9f05ef70e48d9a61a8d0c9bed389da24f2ef5a89df5b6e8deb7c741d6113667e"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/41/3a/d217eb9c3f844aa6e955bf6d85cc9207b2d93e42fc47aff77fc1a778fc72/oslo.context-5.6.0.tar.gz"
    sha256 "5222c32636be070a230df9d3141a0b27a95f0a3b6978f4c1485bcada47a4c3cb"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/75/16/743dbdaa3ddf05206c07965e89889295ada095d7b91954445f3e6cc7157e/oslo.i18n-6.4.0.tar.gz"
    sha256 "66e04c041e9ff17d07e13ec7f48295fbc36169143c72ca2352a3efcc98e7b608"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/69/dd/7d461de2e089c0ddd56e8834a17f1b4efaf2e6ae495acf63c0ed558780b7/oslo.log-6.1.2.tar.gz"
    sha256 "f768047df9d706c484dd6665dcbbea289021d48cb7ce5abf7a1f69a09491f5fe"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/3d/99/5d314298d154a58343050b4d8bb972cbbbb728ef943b57aef7f247c372f8/oslo.serialization-5.5.0.tar.gz"
    sha256 "9e752fc5d8a975956728dd96a82186783b3fefcacbb3553acd933058861e15a6"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/80/67/160e651bbd4c919ea308d63f5cc6c2b82808f0e118abb9f5f7ebca32ca60/oslo.utils-7.3.0.tar.gz"
    sha256 "59a5d3e4e7bbc78d801ccebc2b823e429b624c12bb6e3b6e76f71c29f2bf21df"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/b2/35/80cf8f6a4f34017a7fe28242dc45161a1baa55c41563c354d8147e8358b2/pbr-6.1.0.tar.gz"
    sha256 "788183e382e3d1d7707db08978239965e8b9e4e5ed42669bf4758186734d5f24"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/28/57/0a642bec16d5736b9baaac7e830bedccd10341dc2858075c34d5aec5c8b6/prettytable-3.11.0.tar.gz"
    sha256 "7e23ca1e68bbfd06ba8de98bf553bf3493264c96d5e8a615c0471025deeba722"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/8c/d5/e5aeee5387091148a19e1145f63606619cb5f20b83fccb63efae6474e7b2/pyparsing-3.2.0.tar.gz"
    sha256 "cbf74e27246d595d9a74b186b810f6fbb86726dbf3b9532efb343f6d7294fe9c"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-barbicanclient" do
    url "https://files.pythonhosted.org/packages/6b/13/af3408d95dee59b1fc6110ed9c7c75e6374f822994ea9724e22bb5cf63e5/python-barbicanclient-7.0.0.tar.gz"
    sha256 "316af38a76d65a4af9135c700a7f3a46e2a5ab0485e93969687f6b62317295c7"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/24/3d/361eec88417f075a2d3864d7f08ec26d80fdd37507d0808bb4090f8b456e/python-cinderclient-9.6.0.tar.gz"
    sha256 "3fefde268252e52e30fe2773f658227a78c6dee378fcb132d31c86e6ec9ba238"
  end

  resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/0c/c7/74e4ad40426fbb3161e3f0a1ad346ec72efa17d0df1aefe42974002c57cb/python-cloudkittyclient-5.2.0.tar.gz"
    sha256 "ee8fa18dc319517f2bc7c3adb953ca8f8ac672a61260f26cc71a47adc8a9abd3"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/36/77/eaf20177b9db9f32c34887957195c473bf429cb3b67d15cb6d9bac4b3a08/python-designateclient-6.1.0.tar.gz"
    sha256 "1adc2a074b30d842cf9787f53310c37949195bf4e34da3984e5635b7b8a4689c"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/97/d0/384228542e29f1b5719453ba936befdf22135031f3ce91fe6d3603219c39/python-glanceclient-4.7.0.tar.gz"
    sha256 "c19452ef12da3c484b69d22a888ce7a74910bdb8783bbe91248c60efa5378810"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/79/56/46ab4b7e3dad2fcfd352a4abb973d65e06ed013288743b07df961a4549b1/python-heatclient-4.0.0.tar.gz"
    sha256 "a33a6fe32caef2599698a83688630c37c209dbdcebf3b1a3ef7767e5032089f2"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/a6/28/aa9809119a76e4d5cf255cedd5df03c4a049b8aec26cfb61e277c1819b19/python-ironicclient-5.8.0.tar.gz"
    sha256 "86fedc2358486628ca8682717ebc69ee102971f117da3526b9d3e29552ec942e"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/ea/5e/2d6700c6e36c288ec7e6d24ad49ef400311e8d2b2d926b16906f12c1cb26/python-keystoneclient-5.5.0.tar.gz"
    sha256 "c2f5934f95576936c98e45bf599ad48bcb0ac451593e5f8344ebf52cb0f411f5"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/ff/ff/84ccfc18038df3e92aa92f3e0e1b65df702895c6eecb03e28c25f0996ad9/python-magnumclient-4.7.0.tar.gz"
    sha256 "463d2246242caf91720bdf598cfbd074656b215e2e0fc400b336cf997919e8e5"
  end

  resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/e3/03/f39ee48a740e8c95ad59be21c0a3709d1073c75662ee3400ed7b779e29f2/python-manilaclient-5.0.0.tar.gz"
    sha256 "324fcc484623fe9a226d797e877d7c80ddeb4ee342fde6e12983b7fc0080e082"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/e0/43/827ecaffbd1140c646ea772863ded42e7340d4ecc632e565ba87271e5eb4/python-mistralclient-5.3.0.tar.gz"
    sha256 "afac5e4501e57d6a3fc12c6ba1508b2087c57b77d2caa1ff369a0a15674d94d9"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/6e/b2/b2cb8b08085e419907a28932ca55a2d54b71bd41aedb10f9faf03410e218/python-neutronclient-11.3.1.tar.gz"
    sha256 "53cd9923f43a3b0772a40e3561f74655adc8038f90261ab3de05b6211d12edcb"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/31/36/f45851e60bc760f8c359173c58cbb88804d28d7759ebded1fb74fc3db348/python-octaviaclient-3.8.0.tar.gz"
    sha256 "c2b621098de0a9c92548af256a9b2016adb9622ddac041a06ab5b66bb5b590ee"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/1e/aa/77250fe47fcc62d4e97c921e853eaa717d1bd538527c2f249b29cc903a21/python-swiftclient-4.6.0.tar.gz"
    sha256 "d4d18540413893fc16ad87791d740f823f763435e8212e68eb53d60da2638233"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/99/5b/73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6d/referencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
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
    url "https://files.pythonhosted.org/packages/55/64/b693f262791b818880d17268f3f8181ef799b0d187f6f731b1772e05a29a/rpds_py-0.20.0.tar.gz"
    sha256 "d72a210824facfdaf8768cf2d7ca25a042c30320b3020de2fa04640920d4e121"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/ed/22/a438e0caa4576f8c383fa4d35f1cc01655a46c75be358960d815bfbb12bd/setuptools-75.3.0.tar.gz"
    sha256 "fba5dd4d766e97be1b1681d98712680ae8f2f26d7881245f2ce9e40714f1a686"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/c4/59/f8aefa21020054f553bf7e3b405caec7f8d1f432d9cb47e34aaa244d8d03/stevedore-5.3.0.tar.gz"
    sha256 "9a64265f4060312828151c204efbe9b7a9852a0d9228756344dbc7e4023e375a"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/e1/34/943888654477a574a86a98e9896bae89c7aa15078ec29f490fef2f1e5384/tzdata-2024.2.tar.gz"
    sha256 "7d85cc416e9382e69095b7bdf4afd9e3880418a2413feec7069d533d6b4e31cc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
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
