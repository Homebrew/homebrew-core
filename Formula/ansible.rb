class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.4.1.0.tar.gz"
  sha256 "da61afb29cc5bd6bc4737a2da06e673fb6fccc3ae2685130d19ab3a8e404fb6a"
  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    rebuild 1
    sha256 "d28a5ced078eff66134e029283756e1d73a58c828d51088471f832cd4390b0a8" => :high_sierra
    sha256 "c9529b220dda41ede966599959b4ea176f328824fb8f602928366fb9ac035ceb" => :sierra
    sha256 "31b000feeeadf303fe0b2cabfdb540522aff1ded36bdff06900fbb8641fc650a" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on :python
  depends_on "libyaml"
  depends_on "openssl@1.1"

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
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end
  ### end

  ### extras for requests[security]
  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/ee/6a/cd78737dd990297205943cc4dcad3d3c502807fd2c5b18c5f33dc90ca214/pyOpenSSL-17.3.0.tar.gz"
    sha256 "29630b9064a82e04d8242ea01d7c93d70ec320f5e3ed48e95fcabc6b1d0f6c76"
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

  # Use < 2.9 until https://github.com/ansible/ansible/issues/23779 is resolved
  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/5f/bd/5815d4d925a2b8cbbb4b4960f018441b0c65f24ba29f3bdcfb3c8218a307/Jinja2-2.8.1.tar.gz"
    sha256 "35341f3a97b46327b3ef1eb624aadea87a535b8f50863036e085e7c426ac5891"
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
    url "https://files.pythonhosted.org/packages/8d/f3/02605b056e465bf162508c4d1635a2bccd9abd1ee3ed2a1bb4e9676eac33/PyNaCl-1.1.2.tar.gz"
    sha256 "32f52b754abf07c319c04ce16905109cab44b0e7f7c79497431d3b2000f8af8c"
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
    url "https://files.pythonhosted.org/packages/b6/7c/b9caa157b514e0a456286172862428a83814e4eda114ea1e80267de85378/boto3-1.4.7.tar.gz"
    sha256 "f79f77dca2280f7780f39d72a5088f4cf2b626c0921e7185ed6ac17abfdd7e6c"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6e/d9/6c9f867d4913bc7cafe7721688a32c3d12d49435734b642fe0705aa19d17/botocore-1.7.35.tar.gz"
    sha256 "b0aeb83761d8c22239692ad66faf08f9149ae98d62a778683cbfa54766695268"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
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
    url "https://files.pythonhosted.org/packages/be/79/eb0adb48d8193656a64d679824b9a6a4985faf62875f2f2efe3006695419/cmd2-0.7.7.tar.gz"
    sha256 "b4e2fb9fc656adccc4d01dfd55ab5a9b05890e961950543f692e7885725c2d72"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/78/62/9e38f9b22efe08ec2b40a56c0f46848ce03c35fdd6e78ae445589f914462/cryptography-2.1.2.tar.gz"
    sha256 "d7f348e4f5df146a0e75998544bab6d42313cf19a81a6e49990ab7b27cc9c73b"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/29/52/a3fa968b13bb6010679caca40cf2805dfd973f5715fc43384618342d44c9/debtcollector-1.18.0.tar.gz"
    sha256 "0aa0cd345165e3c831dd9506f20eac5e7c673b210be676594153a3c9905a5fd4"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/bb/e0/f6e41e9091e130bf16d4437dabbac3993908e4d6485ecbc985ef1352db94/decorator-4.1.2.tar.gz"
    sha256 "7cb64d38cb8002971710c8899fbdfb859a23a364b7c99dab19d1f719c2ba16b5"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/8c/e3/e5c66eba8fa2fd567065fa70ada98b990f449f74fb812b408fa7aafe82c9/deprecation-1.0.1.tar.gz"
    sha256 "b9bff5cc91f601ef2a8a0200bc6cde3f18a48c2ed3d1ecbfc16076b14b3ad935"
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
    url "https://files.pythonhosted.org/packages/36/de/499bea7aac917f86eb5be148f631c3ddced4e60c8d119d63939c53a5ab5b/jsonpatch-1.16.tar.gz"
    sha256 "f025c28a08ce747429ee746bb21796c3b6417ec82288f8fe6514db7398f2af8a"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/7b/4f/0c67e6f15c0607c86a4984a922e158933fbfd9a4163ca7fbf44140556b43/jsonpointer-1.12.tar.gz"
    sha256 "819b6dd4fd0a18ac219e02a0117f24b2d31296b0c475c33862cfa9a1616d62c3"
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
    url "https://files.pythonhosted.org/packages/19/05/00048afb5697ac54c0aad757ec8679f471040683e772039ef2977ab00a32/keystoneauth1-3.2.0.tar.gz"
    sha256 "768036ee66372df2ad56716b8be4965cef9a59a01647992919516defb282e365"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/89/dc/ec07a5adf6afb02ad4f5f7e1f7e1a2fc0e3d88ce4fe233ed4b3dabd07cbd/lxml-4.1.0.tar.gz"
    sha256 "be3aaeb5f468a49f523f16736ccff7d82af2b4b303292ba3d052b5b28f3fbe47"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/96/b3/3e9fa0bdf132a971571cbf0e3f0c8b38834f4f7af8ca9523794f4f5895e0/monotonic-1.3.tar.gz"
    sha256 "2b469e2d7dd403f7f7f79227fe5ad551ee1e76f8bb300ae935209884b93c7c1b"
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

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/53/ce/64d6e4a6445bdc33ad4c6dc3b041ff903b4d9716d04d5bd33e2a41495247/openstacksdk-0.9.19.tar.gz"
    sha256 "ac0a160304efba4eaed62d144e9ea0a8f2ba33f7dcd66ba015226c81960b53b5"
  end

  resource "ordereddict" do
    url "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
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
    url "https://files.pythonhosted.org/packages/4d/0a/4a4bc3ada8a66c6da9d2680960b913033874b22608ad39b5793987e02a93/oslo.config-4.13.2.tar.gz"
    sha256 "882e5f1dcc0e5b0d7af877b2df0e2692113c5975db8cbbbf0dd3d2b905aefc0b"
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
    url "https://files.pythonhosted.org/packages/b4/41/b4e5b584da74bdb9ff3999d60f3566f6919679c10c6c3cb66f44d6ff6361/oslo.utils-3.30.0.tar.gz"
    sha256 "1fe825eb74b45e028a3e4d584b43c0971c1d37f635ceaf12b061f8bb848d8fd0"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/83/78/4569a543ef2cb304e9b82387f555021c13a845d0ad1e2bb59272ade67669/paramiko-2.3.1.tar.gz"
    sha256 "fa6b4f5c9d88f27c60fd9578146ff24e99d4b9f63391ff1343305bfd766c4660"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/ce/3d/1f9ca69192025046f02a02ffc61bfbac2731aab06325a218370fd93e18df/ply-3.10.tar.gz"
    sha256 "96e94af7dd7031d8d6dd6e2a8e0de593b511c211a86e28a9c9621c275ac8bacb"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/24/7e/3b1450db76eb48a54ea661a43ae00950275e11840042c5217bd3b47b478e/positional-1.2.1.tar.gz"
    sha256 "cf48ea169f6c39486d5efa0ce7126a97bed979a52af6261cf255a41f9a74453a"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/3c/a6/4d6c88aa1694a06f6671362cb3d0350f0d856edea4685c300785200d1cd9/pyasn1-0.3.7.tar.gz"
    sha256 "187f2a66d617683f8e82d5c00033b7c8a0287e1da88a9d577aebec321cad4965"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyhcl" do
    url "https://files.pythonhosted.org/packages/8a/fb/2ef771488865f15da6f0e8997e01cf019efffc6a8d1848181df27f10adca/pyhcl-0.3.9.tar.gz"
    sha256 "0bda1b46ae06f6d48e70509ecd2a4b65db0ae835726f8e30b2ca7e8684581223"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/7b/a5/48eaa1f2d77f900679e9759d2c9ab44895e66e9612f7f6b5333273b68f29/pyperclip-1.5.27.zip"
    sha256 "a3cb6df5d8f1557ca8fc514d94fabf50dc5a97042c90e5ba4f3611864fed3fc5"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  resource "pysphere" do
    url "https://files.pythonhosted.org/packages/a3/53/582ad19aae059b777f1105e6c7f6fa96f2ab6e7f018d94497fbe1518548d/pysphere-0.1.7.zip"
    sha256 "cef3cb3a6836f1cf092caf4613123d084f36b0e96fa48a27708c0e868df8a1ea"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/d9/04/a62863d814966a2d265a6731a34f64d70182b032ef99d2eac9fde27cb91f/python-cinderclient-3.2.0.tar.gz"
    sha256 "57bd7225a01b5575135e3c602dfda047f0459edb7ce233b9ac2d7565719a8b5c"
  end

  resource "python-consul" do
    url "https://files.pythonhosted.org/packages/7a/8f/9f8eaab8826a59e1beb0808ed77bbb4b8153679ef24c0ef27011f87e4d8b/python-consul-0.7.2.tar.gz"
    sha256 "ef0b7c8a2d8efba5f9602f45aadbe5035e22a511d245624ed732af81223a6571"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/3f/eb/77366b3c5a568b1a205fb3916488219ab6f44d129c455b349642ac5ecf11/python-glanceclient-2.8.0.tar.gz"
    sha256 "26795c19d9b5a2ec54dfc023f5ea869f8b8ae772669606b4af9125a2db51a813"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/7b/68/8d5516a1e0708341ddbd573bb3c08e14e0bef3dd9eb6738bcd2598164727/python-ironicclient-1.17.1.tar.gz"
    sha256 "7346cecd0ef9b97dd48b7d2b87f2d45de6a44e6a469442f7474798b97a01b799"
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

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/07/5a/d74e41953191ab9ea161589b5f0d827ea0ed42e91879bbe5c288f1d6224a/python-novaclient-9.1.1.tar.gz"
    sha256 "ee65c0b429f4b2654416a8a1472729160523c4545315b8fded1652dfb799e428"
  end

  resource "python-openstackclient" do
    url "https://files.pythonhosted.org/packages/e1/a6/25eb5bbb1064bd4203771fd504a717341fcd7d5c7fb9d91beab966d41191/python-openstackclient-3.12.0.tar.gz"
    sha256 "e74e1561dc0ca9aa2193d3e4968f13fba1726deff3ec026eba319fe706d11950"
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
    url "https://files.pythonhosted.org/packages/a8/58/d264e95e1b19a811fc52ff41c95dafd9c70cc7457b658bc04d87dfad31de/s3transfer-0.1.11.tar.gz"
    sha256 "76f1f58f4a47e2c8afa135e2c76958806a3abbc42b721d87fd9d11409c75d979"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/1d/a9/618f1e40e30c69ffab668493953e74e6c266f383af6e34e1b8f089e41139/scp-0.10.2.tar.gz"
    sha256 "18f59e48df67fac0b069591609a0f4d50d781a101ddb8ec705f0c2e3501a8386"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/dc/1e/d5fa685580858edef0f8da59f4e8973410f293276073e9abb4f43d190148/shade-1.24.0.tar.gz"
    sha256 "0b65ea2e5d4015f572b9d87f49b4c4560c1441b1bc13c95ef9becdab539e1ffe"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/08/48/c97b668d6da7d7bebe7ea1817a6f76394b0ec959cb04214ca833c34359df/simplejson-3.11.1.tar.gz"
    sha256 "01a22d49ddd9a168b136f26cac87d9a335660ce07aa5c630b8e3607d6f4325e7"
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

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/0f/d4/408b936a3d9214b7685c35936bb59d9254c70ff319ee6a837b9efcf5615e/warlock-1.2.0.tar.gz"
    sha256 "7c0d17891e14cf77e13a598edecc9f4682a5bc8a219dc84c139c5ba02789ef5a"
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
