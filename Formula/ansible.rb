class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.4.3.0.tar.gz"
  sha256 "0e98b3a56928d03979d5f8e7ae5d8e326939111b298729b03f00b3ad8f998a3d"
  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "3e13049fb07456b61e3bf943bf0860b2ecd2f796203bf2f4355776ae3b80e58e" => :high_sierra
    sha256 "1f78a48e3bbb5c55f8ab69c98e860caafeb728fb7b5a6a07748c442e68b0528d" => :sierra
    sha256 "a219a73b6736e374196de8a589a2c3cd27ef975bc764f88a8319eb478abcb0d7" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "python"

  # Collect requirements from:
  #   ansible
  #   docker-py
  #   python-neutronclient (OpenStack)
  #   shade (OpenStack)
  #   pywinrm (Windows)
  #   kerberos (Windows)
  #   xmltodict (Windows)
  #   boto (AWS)
  #   boto3 (AWS)
  #   botocore (AWS)
  #   apache-libcloud (Google GCE)
  #   python-keyczar (Accelerated Mode)
  #   passlib (htpasswd core module)
  #   zabbix-api (Zabbix extras module)
  #   junos-eznc (Juniper device support)
  #   jxmlease (Juniper device support)
  #   dnspython (DNS Lookup - dig)
  #   pysphere (VMware vSphere support)
  #   python-consul (Consul support)

  ### setup_requires dependencies
  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"
    sha256 "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"
  end
  ### end

  ### extras for requests[security]
  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/41/63/8759b18f0a240e91a24029e7da7c4a95ab75bca9028b02635ae0a9723c23/pyOpenSSL-17.4.0.tar.gz"
    sha256 "2d96b6a3d768bf466c56240d6dd6f035cc8e9c356d20da0583886e77ce9cf6ab"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/25/4c/28c412126f0394dbb3d8005465357581f087fc7ec100b0e83838a90009b7/ndg_httpsclient-0.4.3.tar.gz"
    sha256 "7bfd8c5cfcbc241a93ca6a4e45f952650f5c7ecf7c49b1dbcf5f4d390240be0b"
  end
  ### end

  # The rest of this list should always be sorted by:
  # pip install homebrew-pypi-poet && poet_lint $(brew formula ansible)
  resource "Babel" do
    url "https://files.pythonhosted.org/packages/5a/22/63f1dbb8514bb7e0d0c8a85cc9b14506599a075e231985f98afd70430e1f/Babel-2.5.1.tar.gz"
    sha256 "6007daf714d0cd5524bbe436e2d42b3c20e68da66289559341e48d2cd6d25811"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/4d/de/32d741db316d8fdb7680822dd37001ef7a448255de9699ab4bfcbdf4172b/MarkupSafe-1.0.tar.gz"
    sha256 "a6be69091dac236ea9c6bc7d012beab42010fa914c459791d627dad4910eb665"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/fa/38/0f35ec4beb6562f1abfa07914db1cea978e93da409ba6293f810d9e677d6/PyNaCl-1.2.0.tar.gz"
    sha256 "45c5bcdf8ddefe2e9381f5d37fe778bbda6991fe7004e0b1ea3570df2fc07207"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/1d/a9/3de9cf302166aec7d1ee140a417e0717eca10a69c89bcbe5a243fb8f956c/apache-libcloud-2.2.1.tar.gz"
    sha256 "d065d9da8ba192badad3a98c2f6c3ef9dabba45d1318638b9c1bac83f6c3e7a9"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/31/53/8bca924b30cb79d6d70dbab6a99e8731d1e4dd3b090b7f3d8412a8d8ffbc/asn1crypto-0.23.0.tar.gz"
    sha256 "0874981329cfebb366d6584c3d16e913f2a0eb026c9463efcc4aaf42a9d94d70"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/f3/ec/bb6b384b5134fd881b91b6aa3a88ccddaad0103857760711a5ab8c799358/bcrypt-3.1.4.tar.gz"
    sha256 "67ed1a374c9155ec0840214ce804616de49c3df9c5bc66740687c1c9b1cd9e8d"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/66/e7/fe1db6a5ed53831b53b8a6695a8f134a58833cadb5f2740802bc3730ac15/boto-2.48.0.tar.gz"
    sha256 "deb8925b734b109679e3de65856018996338758f4b916ff4fe7bb62b6d7000d1"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/7b/82/ff2cc1627733040b19369d5d561331b378150e02312f1d1b9424a91ae9d0/boto3-1.4.8.tar.gz"
    sha256 "332c6a17fd695581dd6f9ed825ce13c2d5ee3a6f5e1b079bed0ff7293809faf0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0a/b8/d69b14bc619b7b289de12b25cbe47b268492791ee697d0c7e5f598613860/botocore-1.8.5.tar.gz"
    sha256 "5d2e5bb69dede6dd26b26c90c19bc27cb5c9d5f5e9003db4ca1f27e8eca57035"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/23/3f/8be01c50ed24a4bd6b8da799839066ce0288f66f5e11f0367323467f0cbc/certifi-2017.11.5.tar.gz"
    sha256 "5ec74291ca1136b40f0379e1128ff80e866597e4e2c1e755739a913bbc3613c0"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/c9/70/89b68b6600d479034276fed316e14b9107d50a62f5627da37fafe083fde3/cffi-1.11.2.tar.gz"
    sha256 "ab87dd91c0c4073758d07334c1e5f712ce8fe48f007b86f8238773963ee700a6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/01/28/a5d2141c4a8f908eeb5dd11b96e3d97d9be12832016c96059f089303fa61/cliff-2.9.1.tar.gz"
    sha256 "ab50fbb4717c74e32915123f4150805b463e81de1d58e43996fd813b26c5b447"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/88/58/751575405f01a5b157a0f8317a315a685c82a8fa9ef40941a8fab0c3f529/cmd2-0.7.8.tar.gz"
    sha256 "e132db7d1f5a2faf2310606ee4b2e49c7b4e1e5ed533f1e4ca9474c51475eb0f"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/78/c5/7188f15a92413096c93053d5304718e1f6ba88b818357d05d19250ebff85/cryptography-2.1.4.tar.gz"
    sha256 "e4d967371c5b6b2e67855066471d844c5d52d210c36c28d49a8507b96e2c5291"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/29/52/a3fa968b13bb6010679caca40cf2805dfd973f5715fc43384618342d44c9/debtcollector-1.18.0.tar.gz"
    sha256 "0aa0cd345165e3c831dd9506f20eac5e7c673b210be676594153a3c9905a5fd4"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/bb/e0/f6e41e9091e130bf16d4437dabbac3993908e4d6485ecbc985ef1352db94/decorator-4.1.2.tar.gz"
    sha256 "7cb64d38cb8002971710c8899fbdfb859a23a364b7c99dab19d1f719c2ba16b5"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/e4/96/a598fa35f8a625bc39fed50cdbe3fd8a52ef215ef8475c17cabade6656cb/dnspython-1.15.0.zip"
    sha256 "40f563e1f7a7b80dc5a4e76ad75c23da53d62f1e15e6e517293b04e1f84ead7c"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/95/2e/3c99b8707a397153bc78870eb140c580628d7897276960da25d8a83c4719/docker-pycreds-0.2.1.tar.gz"
    sha256 "93833a2cf280b7d8abbe1b8121530413250c6cd4ffed2c1cf085f335262f7348"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/b6/3d/35c05ca01c070bb70d9d422f2c4858ecb021b05b21af438fec5ccd7b945c/dogpile.cache-0.6.4.tar.gz"
    sha256 "a73aa3049cd88d7ec57a1c2e8946abdf4f14188d429c1023943fcc55c4568da1"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/cc/26/b61e3a4eb50653e8a7339d84eeaa46d1e93b92951978873c220ae64d0733/futures-3.1.1.tar.gz"
    sha256 "51ecb45f0add83c806c68e4b06106f90db260585b25ef2abfcda0bd95c0132fd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz"
    sha256 "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/e5/21/795b7549397735e911b032f255cff5fb0de58f96da794274660bca4f58ef/jmespath-0.9.3.tar.gz"
    sha256 "6a81d4c9aa62caf061cb517b4d9ad1dd300374cd4706997aff9cd6aedd61fc64"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/7e/32/f548f7b2b4862fbedf74075903a81670a5c5f6c55281eab6db2743e6bada/jsonpatch-1.20.tar.gz"
    sha256 "b12594a0cfe634bdd2a5c027250af2dd84932d493568e88ae722871edc3eb02d"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/02/00/f43c4d03d61bd2497dfb0b5a03adec5e1ef328d20878b18a8e161cbb9238/jsonpointer-1.14.tar.gz"
    sha256 "c681af823545c731b7b38aedd5d4eee4c5eff87bc0f25e0ff25444a4189eac4d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/b4/54/9836ea3d74c8556fc39c114dbbf9eee9f7c232316caafc69f4ee66ecb02b/junos-eznc-2.1.7.tar.gz"
    sha256 "95a037cdd05618a189517357e46a06886909a18c7923b628c6ac43d5f54b2912"
  end

  resource "jxmlease" do
    url "https://files.pythonhosted.org/packages/80/b3/a1ffc5ea763c84780a9acfaa4f69a98f6c974eaf297e20d9d3648ef7d95b/jxmlease-1.0.1.tar.gz"
    sha256 "fb04cfd54d8d7e4cc533108750047e9ccf43139c3c0220f8a082274b19564e98"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/b3/07/f7f64fec22a7ca9377b1b1a44130b5186443f62a7ae79a630f8e0c208cf4/keystoneauth1-3.3.0.tar.gz"
    sha256 "c8db2d2f53c0d623f9a51bf18133ee0e2eae121b9c6bf08136f9a664ae469ded"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e1/4c/d83979fbc66a2154850f472e69405572d89d2e6a6daee30d18e83e39ef3a/lxml-4.1.1.tar.gz"
    sha256 "940caef1ec7c78e0c34b0f6b94fe42d0f2022915ffc78643d28538a5cfd0f40e"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/14/73/04da85fc1bacfa94361f00205a464b7f1ed23bfe8de3511cbff0fa2eeda7/monotonic-1.4.tar.gz"
    sha256 "a02611d5b518cd4051bf22d21bd0ae55b3a03f2d2993a19b6c90d9d168691f84"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/21/27/8a1d82041c7a2a51fcc73675875a5f9ea06c2663e02fcfeb708be1d081a0/msgpack-python-0.4.8.tar.gz"
    sha256 "1a2b19df0f03519ec7f19f826afb935b202d8979b0856c6fb3dc28955799f886"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/92/58/c17cf679a2b9b65541cc71ba13a950289b7d34dd0967e34b8816a4d87044/munch-2.2.0.tar.gz"
    sha256 "62fb4fb318e965a464b088e6af52a63e0905a50500b770596a939d3855e7aa15"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/e9/cf/cb131bcaf9b31f8d9d1b9ec3aa9a861dd72a7269a9ff07217b60157fa526/ncclient-0.5.3.tar.gz"
    sha256 "fe6b9c16ed5f1b21f5591da74bfdd91a9bdf69eb4e918f1c06b3c8db307bd32b"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz"
    sha256 "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/72/01/ba076082628901bca750bf53b322a8ff10c1d757dc29196a8e6082711c9d/netifaces-0.10.6.tar.gz"
    sha256 "0c4da523f36d36f1ef92ee183f2512f3ceb9a9d2a45f7d19cda5a42c6689ebe0"
  end

  resource "ntlm-auth" do
    url "https://files.pythonhosted.org/packages/4e/46/e93bed510b7b22f2c3fd3e1555ddc4b0c41e8ed120e9f2472df97bf231ae/ntlm-auth-1.0.6.tar.gz"
    sha256 "86d1d55562bfc57c539dba6c81c4e22f1db9860a0f778dd11fa72e7ae99a0c14"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/84/18/7a950c23631fccd09aa33832df52b7bfce2cf2ea104959a14c04512b19db/os-client-config-1.28.0.tar.gz"
    sha256 "e5be9cfa7a57fe838255236fe4956a91ccb461548883c7b01b37b7b4081af8b8"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/a1/2b/12e065299d6d4dc5279476e9df056cc218715bf9e5261c3c24716f3190d5/osc-lib-1.7.0.tar.gz"
    sha256 "7dee72f13e5478f8d3d836267fa019b99ed4d5e478fc08bbcc9e23029d11ec78"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/52/b3/8e91ee52034a9e7fd66c174a9c577e764331634580ad0a5fe0eaa5b46b38/oslo.config-5.1.0.tar.gz"
    sha256 "e05c6eb428246387022ddc29f57782fee44396dd2d6218c1cae2332403673c30"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/51/71/94296fdd2ef9b81ae31f4ae42321c675a3ebcef81dc5cc5e8115bddb06e5/oslo.i18n-3.18.0.tar.gz"
    sha256 "3624459ae0635188645c7f6b61ae0ac8032df3c44e9076d8bdcf215468e486a7"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/a7/22/78dd94b419482964a4e3b205e69692936a6ecf8eda41a0e7b9caf01a9584/oslo.serialization-2.21.2.tar.gz"
    sha256 "6767eb82adf9b2101072192bf71f68c879ef0a720e1bfb337dad63cf51aba568"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/1c/c2/168764733458039db7e14b44a3f1008968db92be736bdaa4075e8cd6f158/oslo.utils-3.31.0.tar.gz"
    sha256 "dbe4c800035023f07159902bf054399852f92e9187ee656cae0ee875b62ea959"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/c8/de/791773d6a4b23327c7475ae3d7ada0d07fa147bf77fb6f561a4a7d8afd11/paramiko-2.4.0.tar.gz"
    sha256 "486f637f0a33a4792e0e567be37426c287efaa8c4c4a45e3216f9ce7fd70b1fc"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/24/7e/3b1450db76eb48a54ea661a43ae00950275e11840042c5217bd3b47b478e/positional-1.2.1.tar.gz"
    sha256 "cf48ea169f6c39486d5efa0ce7126a97bed979a52af6261cf255a41f9a74453a"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/eb/3d/b7d0fdf4a882e26674c68c20f40682491377c4db1439870f5b6f862f76ed/pyasn1-0.4.2.tar.gz"
    sha256 "d258b0a71994f7770599835249cece1caef3c70def868c4915e6e5ca49b67d15"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/5b/06/86e3c6a55cacef0e4ec7c25379ff7fcd1a88fd939ecefd442b535c792fa4/pyperclip-1.6.0.tar.gz"
    sha256 "ce829433a9af640e08ee89b20f7c62132714bcc5d77df114044d0fccb8c3b3b8"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  resource "pysphere" do
    url "https://files.pythonhosted.org/packages/a3/53/582ad19aae059b777f1105e6c7f6fa96f2ab6e7f018d94497fbe1518548d/pysphere-0.1.7.zip"
    sha256 "cef3cb3a6836f1cf092caf4613123d084f36b0e96fa48a27708c0e868df8a1ea"
  end

  resource "python-consul" do
    url "https://files.pythonhosted.org/packages/7a/8f/9f8eaab8826a59e1beb0808ed77bbb4b8153679ef24c0ef27011f87e4d8b/python-consul-0.7.2.tar.gz"
    sha256 "ef0b7c8a2d8efba5f9602f45aadbe5035e22a511d245624ed732af81223a6571"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/8c/07/5d3cd1aac3ef1d8efc5141024db6ccc03804a90f8bb39ebac6fcecace86d/python-ironicclient-2.0.0.tar.gz"
    sha256 "d63ac47cdc63883aefb89be260a2709d1d5faab8a71030166747065e406b148d"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/a4/a8/b8a83375ee028a0bd28acfcbb9bba20ab27ae2e7e513553e0bc1b901a4e4/python-keystoneclient-3.13.0.tar.gz"
    sha256 "f897eaa6b251a12e5d23130e8435fb5d2ead6f7ea1d1d20faf2ccc1c76c51c90"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/36/01/62c0a5b7b96b3c8a22fc758cf90d8e0798790dfce5e32380587ea499bca9/python-neutronclient-6.5.0.tar.gz"
    sha256 "4cdb6b2603c7c9324dfb05d4b75d5467fcfac05c560b1b15afced63d285bb60c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/60/88/d3152c234da4b2a1f7a989f89609ea488225eaea015bc16fbde2b3fdfefa/pytz-2017.3.zip"
    sha256 "fae4cffc040921b8a2d60c6cf0b5d662c1190fe54d718271db4eb17d44a185b7"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/0b/ca/d0ed22845185fdceb24a1e13811a993e805df9a147d223311061d2e294a7/pywinrm-0.2.2.tar.gz"
    sha256 "3030f700fbd6d06f715d4374c10b3586624bccca003b7075dd281c875705ac1b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests_ntlm" do
    url "https://files.pythonhosted.org/packages/3e/02/6b31dfc8334caeea446a2ac3aea5b8e197710e0b8ad3c3035f7c79e792a8/requests_ntlm-1.1.0.tar.gz"
    sha256 "9189c92e8c61ae91402a64b972c4802b2457ce6a799d658256ebf084d5c7eb71"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/86/36/e8e639fc915ac199f98adfe2bcb8f1bf438681d9020660824b373de0c141/requestsexceptions-1.3.0.tar.gz"
    sha256 "8f141ba636d6748cd29208c1955bde38bf00fcdda1a685bc09d8ed133700353e"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/4b/f6/8f0a24e50454494b0736fe02e6617e7436f2b30148b8f062462177e2ca2d/rfc3986-1.1.0.tar.gz"
    sha256 "8458571c4c57e1cf23593ad860bb601b6a604df6217f829c2bc70dc4b5af941b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/b1/a6/24d960ee5f21eb2f9e2e938be44b9929bf9f85a570b9582c50c14e7c7ec7/s3transfer-0.1.12.tar.gz"
    sha256 "10891b246296e0049071d56c32953af05cea614dca425a601e4c0be35990121e"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/1d/a9/618f1e40e30c69ffab668493953e74e6c266f383af6e34e1b8f089e41139/scp-0.10.2.tar.gz"
    sha256 "18f59e48df67fac0b069591609a0f4d50d781a101ddb8ec705f0c2e3501a8386"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/97/5e/04492bc43d0dd159e06073953e82d87c20c5ad4280fe57f8d3025834fa62/shade-1.25.0.tar.gz"
    sha256 "198334b464f5b4d31a5cd8c476101c8970950659c3a138c32e6ef5fae23a6e53"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/0d/3f/3a16847fe5c010110a8f54dd8fe7b091b4e22922def374fe1cce9c1cb7e9/simplejson-3.13.2.tar.gz"
    sha256 "4c4ecf20e054716cc1e5a81cadc44d3f4027108d8dd0861d8b1e3bd7a32d4f0a"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/74/d4/5e2f93795f587154f27a389817de0e066620eb3f5034979b1dfa782014ce/stevedore-1.27.1.tar.gz"
    sha256 "236468dae36707069e8b3bdb455e9f1be090b1e6b937f4ac0c56a538d6f50be0"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/06/19/f00725a8aee30163a7f257092e356388443034877c101757c1466e591bf8/websocket_client-0.44.0.tar.gz"
    sha256 "15f585566e2ea7459136a632b9785aa081093064391878a448c382415e948d72"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/a0/47/66897906448185fcb77fc3c2b1bc20ed0ecca81a0f2f88eda3fc5a34fc3d/wrapt-1.10.11.tar.gz"
    sha256 "d4d560d479f2c21e1b5443bbd15fe7ec4b37fe7e53d335d3b9b0a7b1226fe3c6"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/57/17/a6acddc5f5993ea6eaf792b2e6c3be55e3e11f3b85206c818572585f61e1/xmltodict-0.11.0.tar.gz"
    sha256 "8f8d7d40aa28d83f4109a7e8aa86e67a4df202d9538be40c0cb1d70da527b0df"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/2a/f3/c261c6d7517acbb19bb76e9ff4721a8adda79be7e09218331603baeef145/zabbix-api-0.5.3.tar.gz"
    sha256 "c64a82531d72230cc3c19684ee586d8d1cdb221f0562c1d88f7325db5abe63d4"
  end

  def install
    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    # https://github.com/Homebrew/homebrew-core/issues/7197
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi"

    virtualenv_install_with_resources

    # prettytable 0.7.2 has file permissions 600 for some files.
    # We need to add read permissions in order to be able to use it as a
    # different user than the one installing it.
    # See: https://github.com/Homebrew/homebrew-core/issues/6975
    # Also: https://github.com/Homebrew/brew/pull/1709
    Pathname.glob(libexec/"lib/python*/site-packages/prettytable-0.7.2-py*.egg-info").each do |prettytable_path|
      chmod_R("a+r", prettytable_path)
    end

    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<~EOS
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOS
    (testpath/"hosts.ini").write "localhost ansible_connection=local\n"
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python", "-c", script
  end
end
