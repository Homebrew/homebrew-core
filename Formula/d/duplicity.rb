class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "https://gitlab.com/duplicity/duplicity"
  # TODO: Restore `depends_on "cryptography"` once pydrive2 replaces oauth2client
  # Issue ref: https://github.com/iterative/PyDrive2/issues/361
  url "https://files.pythonhosted.org/packages/97/44/d1aa0f5484a8c685bda04fdbaef9d107f43894c0b843ad4b9c8abc23a324/duplicity-3.0.6.2.tar.gz"
  sha256 "d22ee49173a19bbca23afa6d2984437da74fdbefac50049291c8d0f1a2994606"
  license "GPL-2.0-or-later"

  # TODO: need to allow autobump to install libxml2/libxslt to resolve lxml
  no_autobump! because: "`update-python-resources` cannot determine dependencies"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "940ef6ca48252bf6332a4e3bb6b3bf5df1a5e2f44148d46191cdaf1fc1d38334"
    sha256 cellar: :any,                 arm64_sequoia: "661b46c674dc3dbc2d429c26f3c0d143c1e1705a38e8a1bcb30747f8e6451c0f"
    sha256 cellar: :any,                 arm64_sonoma:  "cf06b35a45346dc7dc77de32e0eccf1232771af87b625c81723aee212d422e41"
    sha256 cellar: :any,                 sonoma:        "51e3b5f43202ece1195fa4e59ac8f6714a44986be744cee1d259f6826b3d1459"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "43cceeb2409cf85586f64e9b883f2ac4ff11e24c14743db3f14be599e4bf7320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d8a76fc00425ea3e87a08bc3a9f0533dd062f82279e811f6114ddb374522122"
  end

  depends_on "gettext" => :build # for msgfmt
  depends_on "pkgconf" => :build # for cryptography
  depends_on "rust" => :build # for bcrypt
  depends_on "certifi" => :no_linkage
  depends_on "gnupg"
  depends_on "librsync"
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "openssl@3" # for cryptography
  depends_on "python@3.14"

  uses_from_macos "libffi"
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: "certifi",
                extra_packages:   ["python-novaclient>18", "stone==3.2.1"]

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "args" do
    url "https://files.pythonhosted.org/packages/e5/1c/b701b3f4bd8d3667df8342f311b3efaeab86078a840fb826bd204118cc6b/args-0.1.0.tar.gz"
    sha256 "a785b8d837625e9b61c39108532d95b85274acd679693b71ebb5156848fcf814"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/0a/c4/d4ff3bc3ddf155156460bff340bbe9533f99fac54ddea165f35a8619f162/azure_core-1.36.0.tar.gz"
    sha256 "22e5605e6d0bf1d229726af56d9e92bc37b6e726b141a18be0b4d424131741b7"
  end

  resource "azure-storage-blob" do
    url "https://files.pythonhosted.org/packages/36/7c/2fd872e11a88163f208b9c92de273bf64bb22d0eef9048cc6284d128a77a/azure_storage_blob-12.27.1.tar.gz"
    sha256 "a1596cc4daf5dac9be115fcb5db67245eae894cf40e4248243754261f7b674a6"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/f2/d2/3418125c13b35960d0fa00cdb58bfe03c4b88fb74519c5930a47802c1b63/b2sdk-2.10.1.tar.gz"
    sha256 "92c860a4a2e64d4a30d255d5a8d6d9049ff6d2bc64ff5751c0e05b1a2921fd1f"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/19/9d/a8d41de19d81c87dd9d7528e8ad2f4f0c0282d0899a70a3d963472064063/boto3-1.41.1.tar.gz"
    sha256 "fdee48cff828cfe0fb66295ae4d5f47736ee35f11e1de6be6c6dcd910f0810a4"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/eb/f3/d14135ce1c0fe175254e969a2cf7394062a7e52bf1a3d699b30982c0622a/botocore-1.41.1.tar.gz"
    sha256 "e98095492ef8f18d0d6a02ba87d9135c663d4627322e049228143b3a4ef4c2a3"
  end

  resource "boxsdk" do
    url "https://files.pythonhosted.org/packages/44/a6/b7afb8ee4745b61470322ada33c0463b26d221367bc23c8e8c7d4b7b6cbe/boxsdk-10.1.0.tar.gz"
    sha256 "fb409b682d173eeb9a72c03ca0dddf2e66dbd79199235815a2ad61bf39c4f231"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/fb/44/ca1675be2a83aeee1886ab745b28cda92093066590233cc501890eb8417a/cachetools-6.2.2.tar.gz"
    sha256 "8e6d266b25e539df852251cfd6f990b4bc3a141db73b939058d809ebd2590fc6"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/eb/56/b1ba7935a17738ae8453301356628e8147c79dbb825bcbc73dc7401f9846/cffi-2.0.0.tar.gz"
    sha256 "44d1b5909021139fe36001ae048dbdde8214afa20200eda0f64c068cac5d5529"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "clint" do
    url "https://files.pythonhosted.org/packages/3d/b4/41ecb1516f1ba728f39ee7062b9dac1352d39823f513bb6f9e8aeb86e26d/clint-0.5.1.tar.gz"
    sha256 "05224c32b1075563d0b16d0015faaf9da43aa214e4a2140e51f08789e7a4c5aa"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/0d/05/07b55d1fa21ac18c3a8c79f764e2514e6f6a9698f1be44994f5adf0d29db/cryptography-43.0.3.tar.gz"
    sha256 "315b9001266a492a6ff443b61238f956b214dbec9910a081ba5b6646a055a805"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/31/e2/a45b5a620145937529c840df5e499c267997e85de40df27d54424a158d3c/debtcollector-3.0.0.tar.gz"
    sha256 "2a8917d25b0e1f1d0d365d3c1c6ecfc7a522b1e9716e8a1a4a915126f7ccea6f"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/9e/56/ac085f58e8e0d0bcafdf98c2605e454ac946e3d0c72679669ae112dc30be/dropbox-12.0.2.tar.gz"
    sha256 "50057fd5ad5fcf047f542dfc6747a896e7ef982f1b5f8500daf51f3abd609962"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/c0/1f/924e3caae75f471eae4b26bd13b698f6af2c44279f67af317439c2f4c46a/ecdsa-0.19.1.tar.gz"
    sha256 "478cba7b62555866fcb3bb3fe985e06decbdb68ef55713c4e5ab98c57d508e61"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/2d/18/7881a99ba5244bfc82f06017316ffe93217dbbbcfa52b887caa1d4f2a6d3/fasteners-0.20.tar.gz"
    sha256 "55dce8792a41b56f727ba6e123fcaee77fd87e638a6863cec00007bfea84c8d8"
  end

  resource "gdata-python3" do
    url "https://files.pythonhosted.org/packages/de/13/7c54a70f2d415750408b22f6a5ede98d33c0f1da9a40449926e8a2037723/gdata-python3-3.0.1.tar.gz"
    sha256 "b77301becfb3bf42e9a459169e75e6ff4c20cc7b7e247d4d84988e8c8ac6d898"
  end

  resource "google-api-core" do
    url "https://files.pythonhosted.org/packages/61/da/83d7043169ac2c8c7469f0e375610d78ae2160134bf1b80634c482fa079c/google_api_core-2.28.1.tar.gz"
    sha256 "2b405df02d68e68ce0fbc138559e6036559e685159d148ae5861013dc201baf8"
  end

  resource "google-api-python-client" do
    url "https://files.pythonhosted.org/packages/75/83/60cdacf139d768dd7f0fcbe8d95b418299810068093fdf8228c6af89bb70/google_api_python_client-2.187.0.tar.gz"
    sha256 "e98e8e8f49e1b5048c2f8276473d6485febc76c9c47892a8b4d1afa2c9ec8278"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/a8/af/5129ce5b2f9688d2fa49b463e544972a7c82b0fdb50980dafee92e121d9f/google_auth-2.41.1.tar.gz"
    sha256 "b76b7b1f9e61f0cb7e88870d14f6a94aeef248959ef6992670efee37709cbfd2"
  end

  resource "google-auth-httplib2" do
    url "https://files.pythonhosted.org/packages/e0/83/7ef576d1c7ccea214e7b001e69c006bc75e058a3a1f2ab810167204b698b/google_auth_httplib2-0.2.1.tar.gz"
    sha256 "5ef03be3927423c87fb69607b42df23a444e434ddb2555b73b3679793187b7de"
  end

  resource "google-auth-oauthlib" do
    url "https://files.pythonhosted.org/packages/86/a6/c6336a6ceb682709a4aa39e2e6b5754a458075ca92359512b6cbfcb25ae3/google_auth_oauthlib-1.2.3.tar.gz"
    sha256 "eb09e450d3cc789ecbc2b3529cb94a713673fd5f7a22c718ad91cf75aedc2ea4"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/e5/7b/adfd75544c415c487b33061fe7ae526165241c1ea133f9a9125a56b39fd8/googleapis_common_protos-1.72.0.tar.gz"
    sha256 "e55a601c1b32b52d7a3e65f43563e2aa61bcd737998ee672ac9b951cd49319f5"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/52/77/6653db69c1f7ecfe5e3f9726fdadc981794656fcd7d98c4209fecfea9993/httplib2-0.31.0.tar.gz"
    sha256 "ac7ab497c50975147d4f7b1ade44becc7df2f8954d42b38b3d69c515f531135c"
  end

  resource "humanize" do
    url "https://files.pythonhosted.org/packages/b6/43/50033d25ad96a7f3845f40999b4778f753c3901a11808a584fed7c00d9f5/humanize-4.14.0.tar.gz"
    sha256 "2fa092705ea640d605c435b1ca82b2866a1b601cdf96f076d70b79a855eba90d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "invoke" do
    url "https://files.pythonhosted.org/packages/de/bd/b461d3424a24c80490313fd77feeb666ca4f6a28c7e72713e3d9095719b4/invoke-2.2.1.tar.gz"
    sha256 "515bf49b4a48932b79b024590348da22f39c4942dff991ad1fb8b8baea1be707"
  end

  resource "ip-associations-python-novaclient-ext" do
    url "https://files.pythonhosted.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
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
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/e5/16/b96df223ca7ea4bfa78034b205e0eaf4875bfecb2f119f375fc5232d2061/keystoneauth1-5.12.0.tar.gz"
    sha256 "dd113c2f3dcb418d9f761c73b8cd43a96ddfa8a612b51c576822381f39ca4ae8"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/76/3d/14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08f/lxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "mediafire" do
    url "https://files.pythonhosted.org/packages/0c/fe/491d7b3200f3c3cf894e8c05415be4ee5537bf318d9c04ddd53846edf6b3/mediafire-0.6.1.tar.gz"
    sha256 "a1adfeff43dfb611d560c920f6ec18a05b5197b2b15093b08591e45ce879353e"
  end

  resource "megatools" do
    url "https://files.pythonhosted.org/packages/69/0e/cc12d8dfa5cee8b11c72179de7b23b00d1c1555dfe8c25101d88ae86a7ec/megatools-0.0.4.tar.gz"
    sha256 "4418b67fd6ec4b9417d32e2a153a1757d47bc2819b32c155d744640345630112"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/07/8c/14c2ae915e5f9dca5a22edd68b35be94400719ccfa068a03e0fb63d0f6f6/mock-5.2.0.tar.gz"
    sha256 "4e460e818629b4b173f32d08bf30d3af8123afbb8e04bb5707a1fd4799e503f0"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/4d/f2/bfb55a6236ed8725a96b0aa3acbd0ec17588e6a2c3b62a93eb513ed8783f/msgpack-1.1.2.tar.gz"
    sha256 "3b60763c1373dd60f398488069bcdc703cd08a711477b5d480eecc9f9626f47e"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "oauth2client" do
    url "https://files.pythonhosted.org/packages/a6/7b/17244b1083e8e604bf154cf9b716aecd6388acd656dd01893d0d244c94d9/oauth2client-4.1.3.tar.gz"
    sha256 "d486741e451287f69568a4d26d70d9acd73a2bbfa275746c535b4209891cccc6"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/0b/5f/19930f824ffeb0ad4372da4812c50edbd1434f678c90c2733e1188edfc63/oauthlib-3.3.1.tar.gz"
    sha256 "0f0f8aa759826a193cf66c12ea1af1637f87b9b4622d46e866952bb022e538c9"
  end

  resource "os-diskconfig-python-novaclient-ext" do
    url "https://files.pythonhosted.org/packages/a9/2c/306ef3376bee5fda62c1255da05db2efedc8276be5be98180dbd224d9949/os_diskconfig_python_novaclient_ext-0.1.3.tar.gz"
    sha256 "e7d19233a7b73c70244d2527d162d8176555698e7c621b41f689be496df15e75"
  end

  resource "os-networksv2-python-novaclient-ext" do
    url "https://files.pythonhosted.org/packages/9e/86/6ec4aa97a5e426034f8cc5657186e18303ffb89f37e71375ee0b342b7b78/os_networksv2_python_novaclient_ext-0.26.tar.gz"
    sha256 "613a75216d98d3ce6bb413f717323e622386c24fc9cc66148507539e7dc5bf19"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/e7/da/66eaa235e053eb2451464ec131487dec01b5259105688e9f6771d07d45fe/os_service_types-1.8.1.tar.gz"
    sha256 "c3d60134ee509cf55452c73ff8bd41891bcb6cf42421a159c0138824e126402b"
  end

  resource "os-virtual-interfacesv2-python-novaclient-ext" do
    url "https://files.pythonhosted.org/packages/db/33/d5e87b099c9d394a966051cde526c9fcfdd46a51762a8054c98d3ae3b464/os_virtual_interfacesv2_python_novaclient_ext-0.20.tar.gz"
    sha256 "6d39ff4174496a0f795d11f20240805a16bbf452091cf8eb9bd1d5ae2fca449d"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/4d/58/9d4a11a838f174180606f71a8eeeb0a443e98e28798d87c150be732c0d32/oslo_i18n-6.7.1.tar.gz"
    sha256 "7dc879089056fe287a6fb46fa2e73ad88f8d4b989bd63f00486f494435b24ced"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/d4/ac/119c430df3a86dc6a664fa864f777b4fd5cc16c50caa1ba3dd3bf10f43ae/oslo_serialization-5.8.0.tar.gz"
    sha256 "5871a62b23f98cacd5518482941ae6d2a983e2936ed52d543ad08685dc6d2343"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/12/fe/22b08a1234826f3baace1d46494f764625a6e6753b8e4b3809aa93ae35b3/oslo_utils-9.2.0.tar.gz"
    sha256 "1f42006de6b9291a0305025f5ccdb8907120d88ed7ebc3784a1472a3328048ab"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/1f/e7/81fdcbc7f190cdb058cffc9431587eb289833bdd633e2002455ca9bb13d4/paramiko-4.0.0.tar.gz"
    sha256 "6a25f07b380cc9c9a88d2b920ad37167ac4667f8d9886ccebd8f90f654b5d69f"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/79/45/b0847d88d6cfeb4413566738c8bbf1e1995fad3d42515327ff32cc1eb578/prettytable-3.17.0.tar.gz"
    sha256 "59f2590776527f3c9e8cf9fe7b66dd215837cca96a9c39567414cbc632e8ddb0"
  end

  resource "proto-plus" do
    url "https://files.pythonhosted.org/packages/f4/ac/87285f15f7cce6d4a008f33f1757fb5a13611ea8914eb58c3d0d26243468/proto_plus-1.26.1.tar.gz"
    sha256 "21a515a4c4c0088a773899e23c7bbade3d18f9c66c73edd4c7ee3816bc96a012"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/0a/03/a1440979a3f74f16cab3b75b0da1a1a7f922d56a8ddea96092391998edc0/protobuf-6.33.1.tar.gz"
    sha256 "97f65757e8d09870de6fd973aeddb92f85435607235d20b2dfed93405d00c85b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/88/bdd0a41e5857d5d703287598cbf08dad90aed56774ea52ae071bae9071b6/psutil-7.1.3.tar.gz"
    sha256 "6c86281738d77335af7aec228328e944b30930899ea760ecf33a4dba66be5e74"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/ba/e9/01f1a64245b89f039897cb0130016d79f77d52669aae6ee7b159a6c4c018/pyasn1-0.6.1.tar.gz"
    sha256 "6f580d2bdd84365380830acf45550f2511469f673cb4a5ae3857a3170128b034"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/fe/cf/d2d3b9f5699fb1e4615c8e32ff220203e43b248e1dfcc6736ad9057731ca/pycparser-2.23.tar.gz"
    sha256 "78816d4f24add8f10a06d6f05b4d424ad9e96cfebf68a4ddc99c65c0720d00c2"
  end

  resource "pydrive2" do
    url "https://files.pythonhosted.org/packages/3f/dc/92b0beba58f09441219bb6720bebdb895317632db4778cfe1d21532d27e5/pydrive2-1.21.3.tar.gz"
    sha256 "649b84d60c637bc7146485039535aa8f1254ad156423739f07e5d32507447c13"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/e7/46/bd74733ff231675599650d3e47f361794b22ef3e3770998dda30d3b63726/pyjwt-2.10.1.tar.gz"
    sha256 "3cc5772eb20009233caf06e9d8a0577824723b44e6648ee0a2aedb6cf9381953"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/b2/46/aeca065d227e2265125aea590c9c47fbf5786128c9400ee0eb7c88931f06/pynacl-1.6.1.tar.gz"
    sha256 "8d361dac0309f2b6ad33b349a56cd163c98430d409fa503b10b70b3ad66eaa1d"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/5d/70/ff56a63248562e77c0c8ee4aefc3224258f1856977e0c1472672b62dadb8/pyopenssl-24.2.1.tar.gz"
    sha256 "4247f0dbe3748d560dcbb2ff3ea01af0f9a1a001ef5f7c4c647956ed8cbf0e95"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f2/a5/181488fc2b9d093e3972d2a472855aae8a03f000592dbfce716a512b3359/pyparsing-3.2.5.tar.gz"
    sha256 "2df8d5b7b2802ef88e8d016a2eb9c7aeaa923529cd251ed0fe4608275d4105b6"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/96/70/3fd9925320ffd6cc23d1ea737f0a4db56a4862428ad412cbc2521b954787/pyrax-1.9.5.tar.gz"
    sha256 "59ac98ae0549beb1eb36cc1f4985d565f126adbfa596d7fa5aaccde5ef194c0e"
  end

  resource "pysocks" do
    url "https://files.pythonhosted.org/packages/bd/11/293dd436aea955d45fc4e8a35b6ae7270f5b8e00b53cf6c024c83b657a11/PySocks-1.7.1.tar.gz"
    sha256 "3f8804571ebe159c380ac6de37643bb4685970655d3bba243530d6558b799aa0"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-gettext" do
    url "https://files.pythonhosted.org/packages/f6/c8/85df0d3956bebdbaff936df47a5705be9e0b42404589a07065a39c8324e5/python-gettext-5.0.tar.gz"
    sha256 "869af1ea45e3dab6180557259824c2a62f1800e1286226af912431fe75c5084c"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/5c/8a/ac14136fe0a549416b69e6111d6e45c7d821508037922baefa2d54b661f0/python_novaclient-18.11.0.tar.gz"
    sha256 "0a31ae20779d4cd171bb29c1fe4e6b22b9c7d97c79670db5149bbdfac03f57dc"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/36/33/be8b0b894f92f45877cd314a9cf6478001af77a53179adf833a296e792ff/python_swiftclient-4.9.0.tar.gz"
    sha256 "9e207b82ec31786f10db8fef6e205681c24997a0b600d28a194f9d15a90ed772"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rackspace-auth-openstack" do
    url "https://files.pythonhosted.org/packages/3c/14/8932bf613797715bf1fe42b00d413025aac9414cf35bacca091a9191155a/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rackspace-novaclient" do
    url "https://files.pythonhosted.org/packages/2a/fc/2c31fea5bc50cd5a849d9fa61343e95af8e2033b35f2650755dcc5365ff1/rackspace-novaclient-2.1.tar.gz"
    sha256 "22fc44f623bae0feb32986ec4630abee904e4c96fba5849386a87e88c450eae7"
  end

  resource "rax-default-network-flags-python-novaclient-ext" do
    url "https://files.pythonhosted.org/packages/36/cf/80aeb67615503898b6b870f17ee42a4e87f1c861798c32665c25d9c0494d/rax_default_network_flags_python_novaclient_ext-0.4.0.tar.gz"
    sha256 "852bf49d90e7a1bc16aa0b25b46a45ba5654069f7321a363c8d94c5496666001"
  end

  resource "rax-scheduled-images-python-novaclient-ext" do
    url "https://files.pythonhosted.org/packages/ef/3c/9cd2453e85979f15316953a37a93d5500d8f70046b501b13766c58cf1310/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/42/f2/05f29bc3913aea15eb670be136045bf5c5bbf4b99ecb839da9b422bb2c85/requests-oauthlib-2.0.0.tar.gz"
    sha256 "b3dffaebd884d8cd778494369603a9e7b58d29111bf6b41bdc2dcd87203af4e9"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/da/8a/22b7beea3ee0d44b1916c0c1cb0ee3af23b700b6da9f04991899d0c555d4/rsa-4.9.1.tar.gz"
    sha256 "e7bdbfdb5497da4c07dfd35530e1a902659db6ff241e39d9953cad06ebd0ae75"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/ca/bb/940d6af975948c1cc18f44545ffb219d3c35d78ec972b42ae229e8e37e08/s3transfer-0.15.0.tar.gz"
    sha256 "d36fac8d0e3603eff9b5bfa4282c7ce6feb0301a633566153cbd0b93d11d8379"
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
    url "https://files.pythonhosted.org/packages/96/5b/496f8abebd10c3301129abba7ddafd46c71d799a70c44ab080323987c4c9/stevedore-5.6.0.tar.gz"
    sha256 "f22d15c6ead40c5bbfa9ca54aa7e7b4a07d59b36ae03ed12ced1a54cf0b51945"
  end

  resource "stone" do
    url "https://files.pythonhosted.org/packages/61/4f/b5a9138e86b13e00e2439c62fb4d045d595e0e260454977741f62448c624/stone-3.2.1.tar.gz"
    sha256 "9bc78b40143b4ef33bf569e515408c2996ffebefbb1a897616ebe8aa6f2d7e75"
  end

  resource "tlslite-ng" do
    url "https://files.pythonhosted.org/packages/ff/d1/f6572100f6d6ddb31d7356d7c670599bf404b744ce9bb3c6728bde3665f3/tlslite_ng-0.8.2.tar.gz"
    sha256 "9ac377526c60a7d6e7625bd49e7a5ae551b12b0465b07d691342c64a0b3e8440"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "uritemplate" do
    url "https://files.pythonhosted.org/packages/98/60/f174043244c5306c9988380d2cb10009f91563fc4b31293d27e17201af56/uritemplate-4.2.0.tar.gz"
    sha256 "480c2ed180878955863323eea31b0ede668795de182617fef9c6ca09e6ec9d0e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/49/2a/6de8a50cb435b7f42c46126cf1a54b2aab81784e74c8595c8e025e8f36d3/wrapt-2.0.1.tar.gz"
    sha256 "9c9c635e78497cacb81e84f8b11b23e0aacac7a136e73b8e5b2109a1d9fc468f"
  end

  resource "jeepney" do
    on_linux do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end
  end

  resource "secretstorage" do
    on_linux do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  def install
    virtualenv_install_with_resources
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
      ENV["PASSPHRASE"] = "brew"
      system bin/"duplicity", "--tempdir=#{testpath}", "full", "./test", "file://output"
      assert_match "duplicity-full-signatures", Dir["output/*"].to_s

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
