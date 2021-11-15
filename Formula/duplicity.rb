class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https://launchpad.net/duplicity"
  url "https://files.pythonhosted.org/packages/84/65/5ca97dade5527b6a93757e88455c53b0d7002322f9d47d848c35902ef431/duplicity-0.8.20.tar.gz"
  sha256 "488af2ecadb059214074f2b3ac51bf9d7de55a800e37ccc2f1075cd0a74940e3"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4d4a669e32edb2f371d1d378cfcea8c4afd0a14c2902481ab130d5b54d93a93b"
    sha256 cellar: :any,                 arm64_big_sur:  "6c6b66266734d719cf06275cc51da33f1250fbdfdecfe925b2ea9cbbbc43075a"
    sha256 cellar: :any,                 monterey:       "dc9c7cb7a0265b478aea97821aeab7158e7c45ad0065ecb8d5aebfbb1b618bb9"
    sha256 cellar: :any,                 big_sur:        "6a0149ec7cee5ae2b9e94ba3abda42976c1c3930840405d5c4935d294148a9bc"
    sha256 cellar: :any,                 catalina:       "2c1188acf3647c4d69cd838ef872c5510d2a4dde419930e8c9407b8684ef1cf6"
    sha256 cellar: :any,                 mojave:         "9ce160d22e8f610640b7966d06eeec924c15601ee9604f4d72f6c47f420e6508"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667182e0c461b0fb907b3587d332506d3a4db4ee0d72c46bd43f4c1990fcc58b"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "gnupg"
  depends_on "librsync"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.9"
  depends_on "six"

  uses_from_macos "libxslt"

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/ec/74/1cf2d9912921cebdba3fa954949206c8aa159c9cc803b88140fb227f8a0e/arrow-0.17.0.tar.gz"
    sha256 "ff08d10cda1d36c68657d6ad20d74fbea493d980f8b2d45344e00d6ed2bf6ed4"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/ec/01/26f0b9af1fd88a19ee390aec6cad1483fc6af33d82124be3da83328ba4d0/azure-core-1.15.0.zip"
    sha256 "197917b98fec661c35392e32abec4f690ac2117371a814e25e57c224ce23cf1f"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/76/e9/563c5078837173e95f70c7b8ea70d66672d04263b833f02038e73e92faa9/azure-storage-blob-12.8.1.zip"
    sha256 "eb37b50ddfb6e558b29f6c8c03b0666514e55d6170bf4624e7261a3af93c6401"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/fb/6e/e609df8687e960aba003c77d6b7b7da56ab0ad35f5ab11d4e18d8d4b4a76/b2sdk-1.11.0.tar.gz"
    sha256 "c8e3b286eb9edc0ea9fd205a3ba514c5b7789930f25b69919dbaa5bd94b288a0"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e/Babel-2.9.1.tar.gz"
    sha256 "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/51/07/4a40d0188a51398138d4abff7b3c26da476b139a19f24299e71626d98091/boto3-1.17.101.tar.gz"
    sha256 "77ebaa3645ae153978a0f2c492502fef3804fe0e693abc7dc74620e4884afe67"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/73/37/27b163e4bb3da2356ba826481c573dddee19616a5f5871e9cade3b211378/botocore-1.20.101.tar.gz"
    sha256 "f7a44fab1a3739ca54e7f72e8625b71574f8218f05349e59d3b871c887444edd"
  end

  resource "boxsdk" do
    url "https://files.pythonhosted.org/packages/99/6a/427714bcc1cd918190ed7f52f9f915bf22d6dc43e51ab7529e4f2753259e/boxsdk-2.12.1.tar.gz"
    sha256 "4411942210b8e1418b9e2b00d48097cf130c58b04105f12fafe166ab42f6212a"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/52/ba/619250fa6bc11ce6aa4de0604d45843090a53cd7d10d7253b89669313370/cachetools-4.2.2.tar.gz"
    sha256 "61b5ed1e22a0924aed1d23b478f37e8d52549ff8a961de2909c69bf950020cff"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c4/1e/89680e36d87799bdaf685c0896b66b1fa4301ff9ce1aaa0f53d34f7911a9/debtcollector-1.11.0.tar.gz"
    sha256 "733afa881c844a40ef4623ab73ce1862e505bc4655635da3a91d8f3482677785"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/a9/9f/41ade667bddd1b9b6e846519aab8d88c34398ce17b61113fd7443ee22b44/dropbox-11.12.0.tar.gz"
    sha256 "27e70bae5082ca96938ea02ac03b9e1d4accf794a5d1632d8168b6835eff70c1"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/bf/3d/3d909532ad541651390bf1321e097404cbd39d1d89c2046f42a460220fb3/ecdsa-0.17.0.tar.gz"
    sha256 "b9f500bb439e4153d0330610f5d26baaf18d17b8ced1bc54410d189385ea68aa"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/28/e4/2888d41cdbd405828ccdb9a8536c5919939c2f4c6ab9b2ba63e9bd2570d5/fasteners-0.16.3.tar.gz"
    sha256 "b1ab4e5adfbc28681ce44b3024421c4f567e705cc3963c732bf1cba3348307de"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
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
    url "https://files.pythonhosted.org/packages/7a/05/bac134ab5e9705141ae37d8a4a29147f320cb159e81a6f4e00b452e55593/google-api-core-1.30.0.tar.gz"
    sha256 "0724d354d394b3d763bc10dfee05807813c5210f0bd9b8e2ddf6b6925603411c"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/3f/65/9e811aa2f3e88f6d4d2b56725056928cba763d8cfa21869400e47419c3bb/google-api-python-client-2.10.0.tar.gz"
    sha256 "58424d263344625dcf4dc08e7639a6714737102ab4ae83e5f043e3db08d9965f"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/25/c9/2891b5885fc47ea7a5b534ef6e9decead403c2392116291d5eadd321c7db/google-auth-1.32.0.tar.gz"
    sha256 "e34e5f5de5610b202f9b40ebd9f8b27571d5c5537db9afed3a72b2db5a345039"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/c6/b5/a9e956fd904ecb34ec9d297616fe98fa4106fc12f3b0a914dec983c267b9/google-auth-httplib2-0.1.0.tar.gz"
    sha256 "a07c39fd632becacd3f07718dfd6021bf396978f03ad3ce4321d060015cc30ac"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/cd/b3/3897aefd988da1bd45953ace5c4fe9451a14aa0ada1f5d0bbb4d8d9e77be/google-auth-oauthlib-0.4.4.tar.gz"
    sha256 "09832c6e75032f93818edf1affe4746121d640c625a5bef9b5c96af676e98eee"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/1f/4a/369a8b1cf12089c1a902101b0431729e02cd2dd4e390377c920aa1d3ccab/googleapis-common-protos-1.53.0.tar.gz"
    sha256 "a88ee8903aa0a81f6c3cec2d5cf62d3c8aa67c06439b0496b49048fb1854ebf4"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/ed/cd/533a1e9e04671bcee5d2854b4f651a3fab9586d698de769d93b05ee2bff1/httplib2-0.19.1.tar.gz"
    sha256 "0b12617eeca7433d4c396a100eaecfa4b08ee99aa881e6df6e257a7aad5d533d"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/54/af/45d2f76c56912fb75ab19499c7b1b882cd5dc12c7ae4576b5338b5fea8c0/humanize-3.9.0.tar.gz"
    sha256 "892a5b7b87763c4c6997a58382c2b1f4614048a2e01c23ef1bb0456e6f9d4d5d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0e/75/92eed8e2ae8cd78f03c8ab9faf26e561482f3453a6f271a81e792178dd54/importlib_metadata-4.6.0.tar.gz"
    sha256 "4a5611fea3768d3d967c447ab4e93f567d95db92225b43b7b238dbfb855d70bb"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/f9/ed/b97abc7877e5b253eef96a469f47d617b0ebcccc735405fa1a620c7ee833/iso8601-0.1.14.tar.gz"
    sha256 "8aafd56fa0290496c5edbb13c311f78fa3a241f0853540da09d9363eae3ebd79"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70/isodate-0.6.0.tar.gz"
    sha256 "2e364a3d5759479cdb2d37cce6b9376ea504db2ff90252a2e5b7cc89cc9ff2d8"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jottalib" do
    url "https://files.pythonhosted.org/packages/aa/4b/7a5dea988a7a76842738fa23ff8e397109ccb0a85702d10153ce9e46c3ca/jottalib-0.5.1.tar.gz"
    sha256 "015c9a1772f06a2ad496278aff4b20ad41acc660304fa8f8b854932c662bb0a5"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/b0/b5/b27458e1d2adf2a11c6e95c67ac63f828e96fe7e166132e5dacbe03e88c0/keyring-23.0.1.tar.gz"
    sha256 "045703609dd3fccfcdb27da201684278823b72af515aedec1a8515719a038cb8"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/d7/f5/d6e5d18d46ac30369f334eda6b751096c6c5e85688a3b388ff4622f53e9a/keystoneauth1-2.18.0.tar.gz"
    sha256 "075a9ca7a8877c5885fa2487699015e45260c4e6be119683effe0ad2ab1255d2"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/e2/a0/66a7b78e1800af85e54701490cf8764cc6de6c0725d18b10a6fb13ce4d2d/logfury-0.1.2.tar.gz"
    sha256 "42da58fbbd4e6fdb9e5b6b9098e94c249ba9cebfae125643329c8636768edcd3"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
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

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/8a/20/6eca772d1a5830336f84aca1d8198e5a3f4715cd1c7fc36d3cc7f7185091/msgpack-python-0.5.6.tar.gz"
    sha256 "378cc8a6d3545b532dfd149da715abae4fda2a3adb6d74e525d0d5e51f46909b"
  end

  resource "msrest" do
    url "https://files.pythonhosted.org/packages/bb/2c/e8ac4f491efd412d097d42c9eaf79bcaad698ba17ab6572fd756eb6bd8f8/msrest-0.6.21.tar.gz"
    sha256 "72661bc7bedc2dc2040e8f170b6e9ef226ee6d3892e01affd4d26b06474d68d8"
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
    url "https://files.pythonhosted.org/packages/9e/84/001a3f8d9680f3b26d5e7711e13d5ff92e4b511766a72ac6b4a4e5f06796/oauthlib-3.1.1.tar.gz"
    sha256 "8f0215fcc533dd8dd1bee6f4c412d4f0cd7297307d43ac61666389e3bc3198a3"
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

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
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
    url "https://files.pythonhosted.org/packages/3d/64/a3b379cb9c7827ad33c67dcda4c4ad117bdef1b7d68b22a05c963cf4727d/protobuf-3.17.3.tar.gz"
    sha256 "72804ea5eaa9c22a090d2803813e280fb273b62d5ae497aaf3553d141c4fdd7b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
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
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "PyDrive" do
    url "https://files.pythonhosted.org/packages/52/e0/0e64788e5dd58ce2d6934549676243dc69d982f198524be9b99e9c2a4fd5/PyDrive-1.3.1.tar.gz"
    sha256 "83890dcc2278081c6e3f6a8da1f8083e25de0bcc8eb7c91374908c5549a20787"
  end

  resource "PyJWT" do
    url "https://files.pythonhosted.org/packages/0c/c6/3cdc7cb1289b35186fd7fd61836b6d83632ca0f7eee552516777361667b1/PyJWT-2.1.0.tar.gz"
    sha256 "fba44e7898bbca160a2b2b501f492824fc8382485d3a6f11ba5d0c1937ce6130"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/98/cd/cbc9c152daba9b5de6094a185c66f1c6eb91c507f378bb7cad83d623ea88/pyOpenSSL-20.0.1.tar.gz"
    sha256 "4c231c759543ba02560fcd2480c48dcec4dae34c9da7d3747c508227e0624b51"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/10/59/02de1fc01a6828daf1ebbe06e9bcc89eff7708775643877d12884a50d826/pyrax-1.10.0.tar.gz"
    sha256 "109b039bc7df363cbecbbe3e59cdeeeac25c3a5d690a3d89f72ecf96e5e367b2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
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
    url "https://files.pythonhosted.org/packages/5b/02/d20b866dabd7cecae658b7179691948abcf8d28f156b90a63b16c5729693/python-swiftclient-3.12.0.tar.gz"
    sha256 "313b444a14d0f9b628cbf3e8c52f2c4271658f9e8a33d4222851c2e4f0f7b7a0"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
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
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310/requests-toolbelt-0.9.1.tar.gz"
    sha256 "968089d4584ad4ad7c171454f0a5c6dac23971e9472521ea3b6d49d610aa6fc0"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/79/30/5b1b6c28c105629cc12b33bdcbb0b11b5bb1880c6cfbd955f9e792921aa8/rfc3986-1.5.0.tar.gz"
    sha256 "270aaf10d87d0d4e095063c65bf3ddbc6ee3d0b226328ce21e036f946e421835"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/49/45/a16db4f0fa383aaf0676fb7e3c660304fe390415c243f41a77c7f917d59b/simplejson-3.17.2.tar.gz"
    sha256 "75ecc79f26d99222a084fbdd1ce5aad3ac3a8bd535cd9059528452da38b68841"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/40/3a/0443d547d02d40ce6abb0861b16302ad4c57e62c483b9b0180fe44fb4ee4/stevedore-1.20.1.tar.gz"
    sha256 "046200a915780b58bf1c84436e86701b741d664893aefa84d8aceadd15ed4734"
  end

  resource "stone" do
    url "https://files.pythonhosted.org/packages/61/4f/b5a9138e86b13e00e2439c62fb4d045d595e0e260454977741f62448c624/stone-3.2.1.tar.gz"
    sha256 "9bc78b40143b4ef33bf569e515408c2996ffebefbb1a897616ebe8aa6f2d7e75"
  end

  resource "tlslite-ng" do
    url "https://files.pythonhosted.org/packages/cd/95/4311e6b70ded82035b7f3a92bfe5ea350e6d9effe925493ac31ccaf924cc/tlslite-ng-0.7.6.tar.gz"
    sha256 "6ab56f0e9629ce3d807eb528c9112defa9f2e00af2b2961254e8429ca5c1ff00"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/f2/9c/99aae7670351c694c60c72e3cc834b7eab396f738b391bd0bdfc5101a663/tqdm-4.61.1.tar.gz"
    sha256 "24be966933e942be5f074c29755a95b315c69a91f839a29139bf26ffffe2d3fd"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/42/da/fa9aca2d866f932f17703b3b5edb7b17114bb261122b6e535ef0d9f618f8/uritemplate-3.0.1.tar.gz"
    sha256 "5af8ad10cec94f215e3f48112de2022e1d5a37ed427fbd88652fa908f2ab7cae"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/38/f9/4fa6df2753ded1bcc1ce2fdd8046f78bd240ff7647f5c9bcf547c0df77e3/zipp-3.4.1.tar.gz"
    sha256 "3607921face881ba3e026887d8150cca609d517579abe052ac81fc5aeffdbd76"
  end

  def install
    venv = virtualenv_create(libexec, Formula["python@3.9"].opt_bin/"python3")
    venv.pip_install resource("pytz") # `pytz` should be installed before `pbr`
    venv.pip_install resources
    venv.pip_install_and_link buildpath

    man1.install Dir[libexec/"share/man/man1/*"]
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
