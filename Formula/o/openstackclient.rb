class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  # TODO: remove `setuptools` from pypi_formula_mappings.json after https://review.opendev.org/c/openstack/pbr/+/924216
  url "https://files.pythonhosted.org/packages/92/fc/c3c17c98ba811a364094ff35057475dcc1ceaeb5edf4f9884542644982d0/python-openstackclient-7.0.0.tar.gz"
  sha256 "d470e3598c929d923fd768fdf866f51bd34a91bfb17eb70ca1363fabb68bd2e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d32d77c8fc9e462cc76be9b030f61ff1084a786513150eff1d0e0eba4f49fcce"
    sha256 cellar: :any,                 arm64_ventura:  "a26f1139d1846160ea1feef858fd094d7477a3bd1bdc0b5d295fd63069069d13"
    sha256 cellar: :any,                 arm64_monterey: "6a180e15d999758cec333be2205613c318f852750725b1cd39e3920c9ebfb11c"
    sha256 cellar: :any,                 sonoma:         "a3e309c0d07998cf25f3cc8d7afaf67523d532c267bbc89779122169533fc497"
    sha256 cellar: :any,                 ventura:        "c60b8446008ccb4981e596f0c8dfbc5f86bb846333bfe1694ad044d80bcc8be0"
    sha256 cellar: :any,                 monterey:       "a32144e5a20fdd500be5ac82f2a142d303f0f9680251ffc08a004a6d0ccd9668"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74cf38db4d703d377fd846966362f3429de64673ce655f090b759cd8ff2f5e11"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "python@3.12"

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
    url "https://files.pythonhosted.org/packages/15/d2/9671b93d623300f0aef82cde40e25357f11330bdde91743891b22a555bed/babel-2.15.0.tar.gz"
    sha256 "8daf0e265d05768bc6c7a314cf1321e9a123afc328cc635c18622a2f30a04413"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/3c/1c/213ba67600827d8c8cb2b30f1e5471e298b766505341b7fe7c8486cdc388/cliff-4.7.0.tar.gz"
    sha256 "6ca45f8df519bbc0722c61049de7b7e442a465fa7f3f552b96d735fa26fd5b26"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
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
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
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
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/70/72/0278c4e8734c4eeb753726e39ef9f0cfa6e09fdf0e5470ba0c7f61fb054c/keystoneauth1-5.7.0.tar.gz"
    sha256 "b2cc2d68d1a48e9c2c6d9b1b1fd00d7c7bdfe086e8040b51e70938a8ba3adfd1"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/08/4c/17adf86a8fbb02c144c7569dc4919483c01a2ac270307e2d59e1ce394087/msgpack-1.0.8.tar.gz"
    sha256 "95c02b0e27e706e48d0e5426d1710ca78e0f0628d6e89d5b5a5b91a5f12274f3"
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
    url "https://files.pythonhosted.org/packages/01/54/c7fb51f40e439cd7d935b54611552dfbe5aa9e033dbcfe4bd099435ef5da/openstacksdk-3.3.0.tar.gz"
    sha256 "0608690ca37ca73327b0fa3761d17e65395be37ff200b8735d8f24277b4f4980"
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

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/92/9e/bb832c9777e622058309a177ee3f970ef0eda4c8cca17783ad1c4981e649/oslo.config-9.5.0.tar.gz"
    sha256 "aa500044886b6c55f76577cb5a93492a4596c5f9283376760ea7852cc49c99a3"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/f6/9f/0f4d315c5ea8cd7fc83fc6416d952a6fffa4094ad17e59745932f78794fb/oslo.context-5.5.0.tar.gz"
    sha256 "eae0317b29928f1934df4c60b860fe8625247cb297c5cc62fef8eb5827b12fac"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/c1/d6/7c48b3444e08a0ef7555747a11cddcadf32437cf3ba45b7722b3ab7b1ae0/oslo.i18n-6.3.0.tar.gz"
    sha256 "64a251edef8bf1bb1d4e6f78d377e149d4f15c1a9245de77f172016da6267444"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/5f/4a/eb006d3a74273205bf0aae34580b92d995bbcbf2ffa10c1a2db0eb944d7c/oslo.log-6.1.1.tar.gz"
    sha256 "e35a12cfe4cad13ffb0aeda99fcca20a705d0f694a84c2ef7b07b45960f88fb4"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/21/ff/78cc62d4282cf26d322eedf7409a39f7cd5f8c1a83329dc0a65bfa545bd4/oslo.serialization-5.4.0.tar.gz"
    sha256 "315cb3465e99c685cb091b90365cb701bee7140e204ba3e5fc2d8a20b4ec6e76"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/81/01/11003a56d9580e41959f7948e4b56c5cb873def4b4e534cc28017cbf0bb3/oslo.utils-7.2.0.tar.gz"
    sha256 "94f8053391a33502dab4d84465403262ca19ffd8cfd29a1a5ea3c8aa620ef610"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/4c/90/e1c8c06235d53c3adaae74d295669612beea5f5a2052b3184a763e7bdd62/prettytable-3.10.2.tar.gz"
    sha256 "29ec6c34260191d42cd4928c28d56adec360ac2b1208a26c7e4f14b90cc8bc84"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/46/3a/31fd28064d016a2182584d579e033ec95b809d8e220e74c4af6f0f2e8842/pyparsing-3.1.2.tar.gz"
    sha256 "a1bac0ce561155ecc3ed78ca94d3c9378656ad4c94c1270de543f621420f94ad"
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
    url "https://files.pythonhosted.org/packages/c5/ac/2a7e767ca2058af6ab9b257bef8cde23b607719ff876602ddb72f6104aa8/python-cinderclient-9.5.0.tar.gz"
    sha256 "1b9d717aff93cad420045fb6c52f6376ab72f085f8193130892020ec46c93555"
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
    url "https://files.pythonhosted.org/packages/51/98/d33c0a9d58a8b46e61113f5ddac31fd2009e08bd4cf943a122d51a8da01a/python-designateclient-6.0.1.tar.gz"
    sha256 "771ba22f4f0cae3540a7e58ef8787b3f663362b7ffda02fab1dc99ff1a5fa5b1"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/2f/10/e5b966f447ca5af7c762591092c6d0334c21a0be0cc00e33e3fc7f1388c9/python-glanceclient-4.6.0.tar.gz"
    sha256 "8099b84f3c6d223be4a4e95b37cd8c3db6342660dd8b09443061b166f4d1f8fa"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/82/ee/39fafd5436e39d5e1ed4d036fee04c448d141bd82043faccce05104c620a/python-heatclient-3.5.0.tar.gz"
    sha256 "075178d07607145f759a4c70c9247f92a0af9702cbb4182ac14bf0d9bc8e73d8"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/8c/2a/be7734ea87a564a62ddacb4213f099d8ea348ce6c8c23f430fc433e1733a/python-ironicclient-5.7.0.tar.gz"
    sha256 "065c74a6bef7b9903c787776899f5663e6a8cc1156b10856a71a102ad8ed2529"

    # Remove `pkg_resources` for 3.12
    patch do
      url "https://opendev.org/openstack/python-ironicclient/commit/54b878238c712b6bff890fac0a9e51c42214a861.patch"
      sha256 "4f146dd884afbc96ce5dffa65b278723d2ab9ac8d3b9fd40deb47f93fffbfd71"
    end
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/10/67/16b204d96216c57606b352388283fb743e09d85560860ca666baf4876210/python-keystoneclient-5.4.0.tar.gz"
    sha256 "b2b4bdbe9daf7b0b353b8807672eeed01f87dd03b4f8b42d0d061b09b8931f41"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/a2/c2/c07897024a2387d16099728139ad2b717dc00eeef3a4cacc901c8dabeac5/python-magnumclient-4.6.0.tar.gz"
    sha256 "d029c4361c68aae077bdd860df389795d83d1486c3ff1e677b15fcd8af0c2b66"
  end

  resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/a1/f9/3f2b0f3c621d69b7ae7239ca228036e40f68907827dfb8bea55eda45bba4/python-manilaclient-4.9.1.tar.gz"
    sha256 "4de6f291d1b47e4782fb956cf5e8b0b89a576a6e35820f20478176a6860a0e12"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/d1/c5/e3f5be0fb37baacdb7d90cac594d359ac8f2151064d6b4b5f155ebd4dc4f/python-mistralclient-5.2.0.tar.gz"
    sha256 "fe2b2add1057e6bb9f3efddcfa700d9bf1a9b35d06e194ba4ce0747d693abae1"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/6e/b2/b2cb8b08085e419907a28932ca55a2d54b71bd41aedb10f9faf03410e218/python-neutronclient-11.3.1.tar.gz"
    sha256 "53cd9923f43a3b0772a40e3561f74655adc8038f90261ab3de05b6211d12edcb"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/d4/45/00f23cecc76da6ec7a1c8c355fe7c2e859ece2dfaf8267bad30b92f13790/python-octaviaclient-3.7.0.tar.gz"
    sha256 "c001b107279104ec1d5998360f0569b75c868b97abdca43faa1c91540c1a29ee"
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
    url "https://files.pythonhosted.org/packages/5e/11/487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1d/setuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/e7/c1/b210bf1071c96ecfcd24c2eeb4c828a2a24bf74b38af13896d02203b1eec/stevedore-5.2.0.tar.gz"
    sha256 "46b93ca40e1114cea93d738a6c1e365396981bb6bb78c27045b7587c9473544d"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/74/5b/e025d02cb3b66b7b76093404392d4b44343c69101cc85f4d180dd5784717/tzdata-2024.1.tar.gz"
    sha256 "2674120f8d891909751c38abcdfd386ac0a5a1127954fbc332af6b5ceae07efd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
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
