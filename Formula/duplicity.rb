class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https://gitlab.com/duplicity/duplicity"
  url "https://files.pythonhosted.org/packages/28/8e/925915ebb527df5fe91d17af37637939ffe476ce088f194d74cd99567bc6/duplicity-1.0.0.tar.gz"
  sha256 "bd3c8a5ad3cf9d2709540806b03d7186f9e4473d922bea6051248a2acc7ecf0f"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_monterey: "5e91c7cbeadee782c057f3ad978269a89c603e6f3ac4a6e0f5fb37430e0ed6a8"
    sha256 cellar: :any,                 arm64_big_sur:  "64ca82901fbf711f848ac37164bbb336418ee4f7ccfb195fd09c9e7dbafa6860"
    sha256 cellar: :any,                 monterey:       "bbc62b49b76b13d3c79ef72933945f5b7678e4c5d90e645a620b14d05cfc4635"
    sha256 cellar: :any,                 big_sur:        "8395daf75a96e32a530a12dea666f5136181350b4bddfc7620a087ac0ba03d3e"
    sha256 cellar: :any,                 catalina:       "6bf2228b008f28022ed01f2a8f3d7a08d39d923fcf7e2bb3cead23e95cab783f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "597d9492c9055efcc20a90b4bc7ea6fa3105ebd8d7be3fffd15260190e4e757d"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "gnupg"
  depends_on "librsync"
  depends_on "openssl@1.1"
  depends_on "python-typing-extensions"
  # msgpack-python does not support Python 3.10. Dependency comes from pyrax:
  # pyrax -> python-novaclient==2.27.0 -> oslo-serialization<2.17.0 -> msgpack-python
  # Related issue on pyrax being deprecated: https://gitlab.com/duplicity/duplicity/-/issues/105
  depends_on "python@3.9"
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
    url "https://files.pythonhosted.org/packages/8a/02/f855e97cd6f8e3f2726dfa53f080c6d93cd9bb2cf3ab049145a7c38892c8/azure-core-1.25.1.zip"
    sha256 "3c1cf368650e76ec009c07cd1174a95cdcb471b247bb72d18245f7d56c1809b2"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/11/34/56b2b9a9375cce367a28ab1ad389aebce4a142bc106a79ec4849d9c28ab1/azure-storage-blob-12.13.1.zip"
    sha256 "899c4b8e2671812d2cf78f107556a27dbb128caaa2bb06094e72a3d5836740af"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/3f/6c/15582dbc9340586b6ee1d43070a43753cc9d1c3522db13cd38779f25a479/b2sdk-1.18.0.tar.gz"
    sha256 "9272f28d18d498b66d33d749a0f05e49d9bb1a9134f94261c0b8bfa1b56f3eec"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/51/27/81e9cf804a34a550a47cc2f0f57fe4935281d479ae3a0ac093d69476f221/Babel-2.10.3.tar.gz"
    sha256 "7614553711ee97490f732126dc077f8d0ae084ebc6a96e23db1482afabdb2c51"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/99/f2/b71b9b5b2400fffac7d42c560ac89f302c4d8e328337b2f05f0a4d9e590d/bcrypt-4.0.0.tar.gz"
    sha256 "c59c170fc9225faad04dde1ba61d85b413946e8ce2e5f5f5ff30dfd67283f319"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/e8/b5/f6f8e8455c7fc2d66dd33eceb3843fef1457042a05ebe378e5465d3c28bc/boto3-1.24.82.tar.gz"
    sha256 "2a9b283cd4208cfcea873baac29e5ceb011afbd5a5c5b7a35cb305f377c39f60"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/52/fa/a7d3568b26623f69f19bc639836c95bcd90ee6f9bbebe8231aa9396d25b4/botocore-1.27.82.tar.gz"
    sha256 "b122c7048a79fef53f3d45f7ca2999c2559e15fc4531653824ebd3154d77ede5"
  end

  resource "boxsdk" do
    url "https://files.pythonhosted.org/packages/44/e0/80c9d26837bb47b6a0edc48f3ad4d5e230e48021ebd6afa49f1d04189677/boxsdk-3.5.0.tar.gz"
    sha256 "2830bae6a6644ffc731740a7c18c09e3bcdbc157ea2e338be117e4148245c92a"
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
    url "https://files.pythonhosted.org/packages/31/a2/12c090713b3d0e141f367236d3a8bdc3e5fca0d83ff3647af4892c16c205/chardet-5.0.0.tar.gz"
    sha256 "0368df2bfd78b5fc20572bb4e9bb7fb53e2c094f60ae9993339e8671d0afb8aa"
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
    url "https://files.pythonhosted.org/packages/6d/0c/5e67831007ba6cd7e52c4095f053cf45c357739b0a7c46a45ddd50049019/cryptography-38.0.1.tar.gz"
    sha256 "1db3d807a14931fa317f96435695d9ec386be7b84b618cc61cfa5d08b0ae33d7"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c8/7d/904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211a/debtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/32/93/98039d61e35dbc2abce7f08743f8be1a9a92601c0cdc3e1c738d48e3cde5/dropbox-11.34.0.tar.gz"
    sha256 "a20099de1c1e5b844cafcf4b9bb6b71d28441038ea1bff56aab56310cb0505fd"
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
    url "https://files.pythonhosted.org/packages/0e/a9/d000e7562c27b3c7c037bc11dfe18093197e225dc712cc9120932e33e0ab/google-api-core-2.10.1.tar.gz"
    sha256 "e16c15a11789bc5a3457afb2818a3540a03f341e6e710d7f9bbf6cde2ef4a7c8"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/0d/a5/ecbcb0e6340c960f6077a92c806603caaeefc2b827a53a3c1d994b126e76/google-api-python-client-2.63.0.tar.gz"
    sha256 "5cc828499a2cfec5845e095d32f68265c344eb32969f07a8e3774564153178bd"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/19/dd/48e06d7ce02ebf53a2d36fcada99c68d7f6b10f2058ec4f76f7e2e81d9e6/google-auth-2.12.0.tar.gz"
    sha256 "f12d86502ce0f2c0174e2e70ecc8d36c69593817e67e1d9c5e34489120422e4b"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/f0/d0/3521515d13827eb4c68d3b45972ad49a21b02e486c589fdd3c2aee9b9065/google-auth-oauthlib-0.5.3.tar.gz"
    sha256 "307d21918d61a0741882ad1fd001c67e68ad81206451d05fc4d26f79de56fc90"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/f0/8e/190b3ac9bc75d6ead661398a07c6d6f013502c364fd6cc3d5c06427b8023/googleapis-common-protos-1.56.4.tar.gz"
    sha256 "c25873c47279387cfdcbdafa36149887901d36202cb645a0e4f29686bf6e4417"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/9c/65/57ad964eb8d45cc3d1316ce5ada2632f74e35863a0e57a52398416a182a1/httplib2-0.20.4.tar.gz"
    sha256 "58a98e45b4b1a48273073f905d2961666ecf0fbac4250ea5b47aef259eb5c585"
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
    url "https://files.pythonhosted.org/packages/1a/16/441080c907df829016729e71d8bdd42d99b9bdde48b01492ed08912c0aa9/importlib_metadata-4.12.0.tar.gz"
    sha256 "637245b8bab2b6502fcbc752cc4b7a6f6243bb02b31c5c26156ad103d3d45670"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
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
    url "https://files.pythonhosted.org/packages/2a/ef/28d3d5428108111dae4304a2ebec80d113aea9e78c939e25255425d486ff/keyring-23.9.3.tar.gz"
    sha256 "69b01dd83c42f590250fe7a1f503fc229b14de83857314b1933a3ddbf595c4a5"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/d7/f5/d6e5d18d46ac30369f334eda6b751096c6c5e85688a3b388ff4622f53e9a/keystoneauth1-2.18.0.tar.gz"
    sha256 "075a9ca7a8877c5885fa2487699015e45260c4e6be119683effe0ad2ab1255d2"
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

  resource "mock" do
    url "https://files.pythonhosted.org/packages/e2/be/3ea39a8fd4ed3f9a25aae18a1bff2df7a610bca93c8ede7475e32d8b73a0/mock-4.0.3.tar.gz"
    sha256 "7d3fbbde18228f4ff2f1f119a45cdffa458b4c0dee32eb4d2bb2f82554bac7bc"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz"
    sha256 "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/c7/0c/fad24ca2c9283abc45a32b3bfc2a247376795683449f595ff1280c171396/more-itertools-8.14.0.tar.gz"
    sha256 "c09443cd3d5438b8dafccd867a6bc1cb0894389e90cb53d227456b0b0bccb750"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/8a/20/6eca772d1a5830336f84aca1d8198e5a3f4715cd1c7fc36d3cc7f7185091/msgpack-python-0.5.6.tar.gz"
    sha256 "378cc8a6d3545b532dfd149da715abae4fda2a3adb6d74e525d0d5e51f46909b"
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
    url "https://files.pythonhosted.org/packages/fe/58/30a4d3302f9bbd602c43385e7270fc3a9e8a665d07aafd6a4d4baa844739/oauthlib-3.2.1.tar.gz"
    sha256 "1565237372795bf6ee3e5aba5e2a85bd5a65d0e2aa5c628b9a97b7d7a0da3721"
  end

  resource "os_diskconfig_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/a9/2c/306ef3376bee5fda62c1255da05db2efedc8276be5be98180dbd224d9949/os_diskconfig_python_novaclient_ext-0.1.3.tar.gz"
    sha256 "e7d19233a7b73c70244d2527d162d8176555698e7c621b41f689be496df15e75"
  end

  resource "os_networksv2_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/9e/86/6ec4aa97a5e426034f8cc5657186e18303ffb89f37e71375ee0b342b7b78/os_networksv2_python_novaclient_ext-0.26.tar.gz"
    sha256 "613a75216d98d3ce6bb413f717323e622386c24fc9cc66148507539e7dc5bf19"
  end

  resource "os_virtual_interfacesv2_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/db/33/d5e87b099c9d394a966051cde526c9fcfdd46a51762a8054c98d3ae3b464/os_virtual_interfacesv2_python_novaclient_ext-0.20.tar.gz"
    sha256 "6d39ff4174496a0f795d11f20240805a16bbf452091cf8eb9bd1d5ae2fca449d"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/51/bf/5a671cf70e7103f36b36e05e52508091189b5597778153538399a02cff8f/oslo.config-4.12.0.tar.gz"
    sha256 "bd8d03c4b28f1aa115e6b094651fc51adbca686f22f45ed721d837a5a5a249dd"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/ab/ff/65b92fea4afefd0c9e71e71e2a1a4c0c55dfae70a0976be1b84fd06ffa00/oslo.i18n-3.12.0.tar.gz"
    sha256 "6add28cbbe8254838f7f131de0cf0f3761786d57e5fe5716a488260b725f58d3"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/91/84/92ff0c2ec75f3fbc880c076ba0d074cda4eed9cf199f85100992162cca37/oslo.serialization-2.16.1.tar.gz"
    sha256 "306d9982eae272fff05db7637971fd07d2b9b818306c9e3af87aea7f452b4844"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/ad/90/ef1cc13e41ccc14f0f20ca6c6cd96d50c3a7a6bdf259411bf62af0f28534/oslo.utils-3.22.3.tar.gz"
    sha256 "70473be975412407d43ef04b0de34c4d21c567bdcab608caeb8f0fcd4138f4f2"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1d/08/3b8d8f1b4ec212c17429c2f3ff55b7f2237a1ad0c954972e39c8f0ac394c/paramiko-2.11.0.tar.gz"
    sha256 "003e6bee7c034c21fbb051bf83dc0a9ee4106204dd3c53054c71452cc4ec3938"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/24/7e/3b1450db76eb48a54ea661a43ae00950275e11840042c5217bd3b47b478e/positional-1.2.1.tar.gz"
    sha256 "cf48ea169f6c39486d5efa0ce7126a97bed979a52af6261cf255a41f9a74453a"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/0e/25/693cd589793e7ae429ef76ab08f74b7866d342fd079cc4c723141a9660d3/protobuf-4.21.6.tar.gz"
    sha256 "6b1040a5661cd5f6e610cbca9cfaa2a17d60e2bb545309bc1b278bb05be44bdd"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/8f/57/828ac1f70badc691a716e77bfae258ef5db76bb7830109bf4bcf882de020/psutil-5.9.2.tar.gz"
    sha256 "feb861a10b6c3bb00701063b37e4afc754f8217f0f09c42280586bd6ac712b5c"
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

  resource "PyDrive" do
    url "https://files.pythonhosted.org/packages/52/e0/0e64788e5dd58ce2d6934549676243dc69d982f198524be9b99e9c2a4fd5/PyDrive-1.3.1.tar.gz"
    sha256 "83890dcc2278081c6e3f6a8da1f8083e25de0bcc8eb7c91374908c5549a20787"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/d4/63/6f57a751c9e3135856b44e2c29c548741ec14db3d24b9666e97292aa968e/PyJWT-2.5.0.tar.gz"
    sha256 "e77ab89480905d86998442ac5788f35333fa85f65047a534adc38edf3c88fc3b"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/10/59/02de1fc01a6828daf1ebbe06e9bcc89eff7708775643877d12884a50d826/pyrax-1.10.0.tar.gz"
    sha256 "109b039bc7df363cbecbbe3e59cdeeeac25c3a5d690a3d89f72ecf96e5e367b2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/56/c3/e808e30c7a0b5be8702f24e8c740b50cafe105ef6973624c9a5b258bd85f/python-keystoneclient-3.10.0.tar.gz"
    sha256 "c65fa56791ec02dc942ad08e5c3634b8dca98eda76ee3c2549018b6767e67918"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/ac/10/aa4d81bb5ceac249b7facf86d021b7008a138b447ca9cbf09557fca61046/python-novaclient-2.27.0.tar.gz"
    sha256 "d1279d5c2857cf8c56cb953639b36225bc1fec7fa30ee632940823506a7638ef"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/93/bc/e9fa2d72443623df0561d86f576aeadc1cd95a8dfe551d2724c4f6da2552/python-swiftclient-4.1.0.tar.gz"
    sha256 "f82298e4a48f7cbdd680f2638c85d1ca7ae1a76edbe30036d21b4cd7a29c09eb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/24/0c/401283bb1499768e33ddd2e1a35817c775405c1f047a9dc088a29ce2ea5d/pytz-2022.2.1.tar.gz"
    sha256 "cea221417204f2d1a2aa03ddae3e867921971d0d76f14d87abb4414415bbdcf5"
  end

  resource "rackspace-auth-openstack" do
    url "https://files.pythonhosted.org/packages/3c/14/8932bf613797715bf1fe42b00d413025aac9414cf35bacca091a9191155a/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rackspace-novaclient" do
    url "https://files.pythonhosted.org/packages/2a/fc/2c31fea5bc50cd5a849d9fa61343e95af8e2033b35f2650755dcc5365ff1/rackspace-novaclient-2.1.tar.gz"
    sha256 "22fc44f623bae0feb32986ec4630abee904e4c96fba5849386a87e88c450eae7"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/36/cf/80aeb67615503898b6b870f17ee42a4e87f1c861798c32665c25d9c0494d/rax_default_network_flags_python_novaclient_ext-0.4.0.tar.gz"
    sha256 "852bf49d90e7a1bc16aa0b25b46a45ba5654069f7321a363c8d94c5496666001"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/ef/3c/9cd2453e85979f15316953a37a93d5500d8f70046b501b13766c58cf1310/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
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
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
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

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/7a/47/c7cc3d4ed15f09917838a2fb4e1759eafb6d2f37ebf7043af984d8b36cf7/simplejson-3.17.6.tar.gz"
    sha256 "cf98038d2abf63a1ada5730e91e84c642ba6c225b0198c3684151b1f80c5f8a6"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/40/3a/0443d547d02d40ce6abb0861b16302ad4c57e62c483b9b0180fe44fb4ee4/stevedore-1.20.1.tar.gz"
    sha256 "046200a915780b58bf1c84436e86701b741d664893aefa84d8aceadd15ed4734"
  end

  resource "stone" do
    url "https://files.pythonhosted.org/packages/99/6f/ef25bbc1aefeb9c905d527f1d3cd3f41f22f40566d33001b8bb14ae0cdaf/stone-3.3.1.tar.gz"
    sha256 "4ef0397512f609757975f7ec09b35639d72ba7e3e17ce4ddf399578346b4cb50"
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
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3b/e3/fb79a1ea5f3a7e9745f688855d3c673f2ef7921639a380ec76f7d4d83a85/zipp-3.8.1.tar.gz"
    sha256 "05b45f1ee8f807d0cc928485ca40a07cb491cf092ff587c0df9cb1fd154848d2"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resource("pytz") # `pytz` should be installed before `pbr`
    venv.pip_install resources

    man1_before = Dir[libexec/"share/man/man1/*"].to_set
    venv.pip_install_and_link buildpath
    man1.install_symlink (Dir[libexec/"share/man/man1/*"].to_set - man1_before).to_a
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
