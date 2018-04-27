class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.5.2.tar.gz"
  sha256 "a95483f3b33e0f97d03badaad073392ed03a2b2f526bec4ddf598edfc1c03ae5"
  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "65d22c410092599b894690827a24322cf5f83e0703925e1fbd368087b03797c6" => :high_sierra
    sha256 "17a3698b62652ec9dad822925bb29083fc7f125222571be99e29859ab30eccd6" => :sierra
    sha256 "9c7e0d7a3a1428716990941a1e7fd13315cc3b321049ca4d85eabda3b318be18" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl"
  depends_on "python@2"

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
    url "https://files.pythonhosted.org/packages/c6/46/f414e7d9ba9621c8acd3e7a82e08c47e0de34ad3e213c16e458b6c04d432/pbr-4.0.2.tar.gz"
    sha256 "dae4aaa78eafcad10ce2581fc34d694faa616727837fd8e55c1a00951ad6744f"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/10/76/52efda4ef98e7544321fd8d5d512e11739c1df18b0649551aeccfb1c8376/pytz-2018.4.tar.gz"
    sha256 "c06425302f2cf668f1bba7a0a03f3c1d34d4ebeef2c72003da308b3947c7f749"
  end
  ### end

  ### extras for requests[security]
  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fd/2c/a9e42f90bda9ebadf4790ed699e44edd630614f1590eb42e11de64a0b9c1/cryptography-2.2.1.tar.gz"
    sha256 "dddad9d322a3f0867009ff9f25477b8f7c0bdbedf143704b384c9472f11cb2d3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/3b/15/a5d90ab1a41075e8f0fae334f13452549528f82142b3b9d0c9d86ab7178c/pyOpenSSL-17.5.0.tar.gz"
    sha256 "2c10cfba46a52c0b0950118981d61e72c1e5b1aac451ca1bc77de1a679456773"
  end
  ### end

  # The rest of this list should always be sorted by:
  # pip install homebrew-pypi-poet && poet_lint $(brew formula ansible)
  resource "Babel" do
    url "https://files.pythonhosted.org/packages/0e/d5/9b1d6a79c975d0e9a32bd337a1465518c2519b14b214682ca9892752417e/Babel-2.5.3.tar.gz"
    sha256 "8ce4cb6fdd4393edd323227cba3a077bceb2a6ce5201c902c65e730046f41f14"
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
    url "https://files.pythonhosted.org/packages/08/19/cf56e60efd122fa6d2228118a9b345455b13ffe16a14be81d025b03b261f/PyNaCl-1.2.1.tar.gz"
    sha256 "e0d38fa0a75f65f556fb912f2c6790d1fa29b7dd27a1d9cc5591b281321eaaa9"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/2a/b9/dbc5ef54d9b5fd5759a483b5cb7404e470ce4dbe7c944416df346cde8ff5/apache-libcloud-2.3.0.tar.gz"
    sha256 "0e2eee3802163bd0605975ed1e284cafc23203919bfa80c0cc5d3cd2543aaf97"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
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
    url "https://files.pythonhosted.org/packages/6e/48/45a9b5bd6f0652598e5650cac37a96da324fcd03c45d6ffafe7201f670ea/boto3-1.7.10.tar.gz"
    sha256 "30239a3c16da19c0a0886e7904195fb1a191dafc5773ad1656b7896577241cb5"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6c/36/445661a4cfbc2eb7cf3c74c6d9308911dd37a09323a1c7b900ff34931db5/botocore-1.10.10.tar.gz"
    sha256 "10d4880253210ad35cb1b3c3134d8698c2c2d10f15a2cf6a7be3f91b486866ff"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/4d/9c/46e950a6f4d6b4be571ddcae21e7bc846fcbb88f1de3eff0f6dd0a6be55d/certifi-2018.4.16.tar.gz"
    sha256 "13e698f54293db9f89122b0581843a782ad0934a4fe0172d2a980ba77fc61bb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/b6/9d/bcc276f7ab90162a7e78cab3ea33b4017b42ed050af25c1008bb768067c4/cliff-2.11.0.tar.gz"
    sha256 "38a318fb2927edb61cae365d4bf3a8241f222e2b30cc9e448ae5b92665802a85"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/5c/ec/63ac612859b7b243432891e2fc5f60016fd95e41af30ba8747978eb68f10/cmd2-0.8.5.tar.gz"
    sha256 "2ae9c397bcb8c4ca2a068002407238e56acfce3ed55e67bde35988a100adcdee"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/6e/db/41233498c210b03ab8b072c8ee49b1cd63b3b0c76f8ea0a0e5d02df06898/contextlib2-0.5.5.tar.gz"
    sha256 "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/44/db/6b54be9367110bc40468f3bcc75b115ab655a9fdd993a4ed01862fdb8d80/debtcollector-1.19.0.tar.gz"
    sha256 "4e90683553a6bb68d10a29b42c5df90d0e83d5085ff1ac2970c91314acdf8719"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"
    sha256 "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/d1/98/caa4171c9ad4bb046b18bef84cc6e5d0ae0427baeee920eef53da83fae09/deprecation-2.0.2.tar.gz"
    sha256 "e8d0dc5a17d7d551730e5f23ff3a53fc9e438364b9efb47d41c3e9b05522eabe"
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
    url "https://files.pythonhosted.org/packages/fc/29/f0fe6e6a055ebfc224f952d1166aea7bccd7de38ac01842fcbffe10ec0b8/docker-pycreds-0.2.3.tar.gz"
    sha256 "e3732a03610a00461a716997670c7010bf1c214a3edc440f7d6a2a3a830ecd9d"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/65/24/7bd97e9d486c37ac03ef6ae3a590db1a8e02183e5d7ce9071bcca9d86c44/dogpile.cache-0.6.5.tar.gz"
    sha256 "631197e78b4471bb0e93d0a86264c45736bc9ae43b4205d581dcc34fbe9b5f31"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/1f/9e/7b2ff7e965fc654592269f2906ade1c7d705f1bf25b7d469fa153f7d19eb/futures-3.2.0.tar.gz"
    sha256 "9ec02aa7d674acb8618afb127e27fde7fc68994c0437ad759fa094a574adb265"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
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
    url "https://files.pythonhosted.org/packages/9a/7d/bcf203d81939420e1aaf7478a3efce1efb8ccb4d047a33cb85d7f96d775e/jsonpatch-1.23.tar.gz"
    sha256 "49f29cab70e9068db3b1dc6b656cbe2ee4edf7dfe9bf5a0055f17a4b6804a4b9"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz"
    sha256 "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362"
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
    url "https://files.pythonhosted.org/packages/34/18/9c86fdfdb27e0f7437b7d5a9e22975dcc382637b2a68baac07843be512fc/kerberos-1.3.0.tar.gz"
    sha256 "f039b7dd4746df56f6102097b3dc250fe0078be75130b9dc4211a85a3b1ec6a4"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/7e/3e/79238e265b094afa93b11fa167503030962c1842cf13a8f6f9c346951298/keystoneauth1-3.5.0.tar.gz"
    sha256 "0579c112df9ab6764d6e005b7bacbaf2524f7cfcf9a89cc041b2b72d00414268"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e8/5d/98f56e274bdf17f2e0d9016d1788ca80d26d8987dcd5e1d9416d86ee0625/lxml-4.2.1.tar.gz"
    sha256 "e2629cdbcad82b83922a3488937632a4983ecc0fed3e5cfbf430d069382eeb9b"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/14/73/04da85fc1bacfa94361f00205a464b7f1ed23bfe8de3511cbff0fa2eeda7/monotonic-1.4.tar.gz"
    sha256 "a02611d5b518cd4051bf22d21bd0ae55b3a03f2d2993a19b6c90d9d168691f84"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/f3/b6/9affbea179c3c03a0eb53515d9ce404809a122f76bee8fc8c6ec9497f51f/msgpack-0.5.6.tar.gz"
    sha256 "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/64/4e/ab05b4a03fe1221e54f1c2040c2375180759c5931dbe21da955f467f5b6b/munch-2.3.1.tar.gz"
    sha256 "fc64a4aeb47e34ff1125f69af3cf3f59e51554b96dbaa2b720c6fb6c9e47a551"
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
    url "https://files.pythonhosted.org/packages/f4/e5/72bcd01db360de8af903e303ba5ed4a26b95aec6799e4cd36dd7ccf367eb/ntlm-auth-1.1.0.tar.gz"
    sha256 "d4b21b85cbbf53ec1f16e435898eb9ab80f1e8f1571f0b7e2eb038c0517dd47a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/da/f9/95495c0e3eb7c9a1c4c4d9023ef88b19ba8cc35ddafb573056e64734de9c/openstacksdk-0.13.0.tar.gz"
    sha256 "2a34dfbe99e1388f77dfc6eee90fb52f766ee5a9bd383c33c5a450262f580eec"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/4a/68/ea2065b649cf7ebe73b456737c0f54966907e2338ff873b99ee69b5ca3fe/os-client-config-1.29.0.tar.gz"
    sha256 "e98bdde50e30396d47d237cfb23e209e8c0a6f834ada190a2dcfe5305bd42af0"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/b3/22/1d0a1f5fd633fdbdff3ac1191f95773e3277d1138e4cee09a891c9ee51aa/os-service-types-1.2.0.tar.gz"
    sha256 "b08fb4ec1249d313afea2728fa4db916b1907806364126fe46de482671203111"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/19/d4/e3738123a4bf165f2dab3f74004c189707e25befabe6895faad06afdf0a4/osc-lib-1.10.0.tar.gz"
    sha256 "6b02b8fe036b8e5f722b9de6f14923ae7cb4d90aa4474b70df5aa1fdb113b352"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/b4/0d/539499bb0c13bf10f398dad32ef4852a173aad3914453ed0c8386203db4b/oslo.config-6.2.0.tar.gz"
    sha256 "135ae788d7a1bb57327364da9a6fd9225f053d33b9da0bbece9a146c8cc55802"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/cc/8d/9514c0f979c858fcbf3c8300769f8323d5c69c20cffe3543059e978329cd/oslo.i18n-3.20.0.tar.gz"
    sha256 "c3cf63c01fa3ff1b5ae7d6445d805c6bf5390ac010725cf126b18eb9086f4c4e"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/a8/25/71f3dbdd26093d296ef563132de5450820d78141343a9e506b70c396b099/oslo.serialization-2.25.0.tar.gz"
    sha256 "9563fa6ff64bc0a94f8ad8d2b36c5dda452dfe3ea8bb8a5291ba0355687445c4"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/e2/31/4a1b716dd899599df2a7fb7f1899fa2d6dc08da627d918d8321035567ac8/oslo.utils-3.36.1.tar.gz"
    sha256 "baaffb9d1528bdb5677f8c67828c457d5c015249674a33c62e6a0dbddd9f0e58"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/77/32/439f47be99809c12ef2da8b60a2c47987786d2c6c9205549dd6ef95df8bd/packaging-17.1.tar.gz"
    sha256 "f019b770dd64e585a99714f1fd5e01c7a8f11b45635aa953fd41c689a657375b"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/29/65/83181630befb17cd1370a6abb9a87957947a43c2332216e5975353f61d64/paramiko-2.4.1.tar.gz"
    sha256 "33e36775a6c71790ba7692a73f948b329cf9295a72b0102144b031114bd2a4f3"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
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
    url "https://files.pythonhosted.org/packages/c5/39/4da7c2dbc4f023fba5fb2325febcadf0d0ce0efdc8bd12083a0f65d20653/python-dateutil-2.7.2.tar.gz"
    sha256 "9d8074be4c993fbe4947878ce593052f71dac82932a677d49194d8ce9778002e"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/17/2f/87f6c87a9c2f935bcc45f3c3c60275e5ce297ce36a89af46d3d6f5c1c00a/python-keystoneclient-3.16.0.tar.gz"
    sha256 "0658240b39cced18784c8c4c0bed24d42f06c048103b397a55992a9e0da01c4a"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/06/09/491f3627a092b8a6c27b0f6d9d09946ddc8cad206eaacd9226399b0ca990/python-neutronclient-6.8.0.tar.gz"
    sha256 "7f86527475a751ec3a101bb98f6341ca40504de59f46e57369c5e0785fe7479f"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/5b/8b/eae19a3574256c834213838310364838a869d128538609da2099cb027c25/pywinrm-0.3.0.tar.gz"
    sha256 "799fc3e33fec8684443adf5778860388289102ea4fa1458f1bf307d167855573"
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
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/4b/f6/8f0a24e50454494b0736fe02e6617e7436f2b30148b8f062462177e2ca2d/rfc3986-1.1.0.tar.gz"
    sha256 "8458571c4c57e1cf23593ad860bb601b6a604df6217f829c2bc70dc4b5af941b"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/9a/66/c6a5ae4dbbaf253bd662921b805e4972451a6d214d0dc9fb3300cb642320/s3transfer-0.1.13.tar.gz"
    sha256 "90dc18e028989c609146e241ea153250be451e05ecc0c2832565231dacdf59c1"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/1d/a9/618f1e40e30c69ffab668493953e74e6c266f383af6e34e1b8f089e41139/scp-0.10.2.tar.gz"
    sha256 "18f59e48df67fac0b069591609a0f4d50d781a101ddb8ec705f0c2e3501a8386"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/15/8b/cd80c6c1a4178d6670abebb80b65c7e857d46fd90cf0564ef3e7efa8e79d/shade-1.27.1.tar.gz"
    sha256 "d1702b9427eb4146e69a9c61c0f8d83457a9f8b4fa5f43aa775c34672e1907a6"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/6c/ca/8776e0c494b7f16f98a4f40f1540ed6f7467f75280631d837e9cf3e5796e/simplejson-3.14.0.tar.gz"
    sha256 "1ebbd84c2d7512f7ba65df0b9cc3cbc1bbd6ef9eab39fc9389dfe7e3681f7bd2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ba/40/92295187c3157c109fde84eb2d4002c2bb3ab5a9c1df09f7fd96e6dfd5c9/stevedore-1.28.0.tar.gz"
    sha256 "f1c7518e7b160336040fee272174f1f7b29a46febb3632502a8f2055f973d60b"
  end

  resource "subprocess32" do
    url "https://files.pythonhosted.org/packages/b8/2f/49e53b0d0e94611a2dc624a1ad24d41b6d94d0f1b0a078443407ea2214c2/subprocess32-3.2.7.tar.gz"
    sha256 "1e450a4a4c53bf197ad6402c564b9f7a53539385918ef8f12bdf430a61036590"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/c9/bb/8d3dd9063cfe0cd5d03fe6a1f74ddd948f384e9c1eff0eb978f3976a7d27/websocket_client-0.47.0.tar.gz"
    sha256 "a453dc4dfa6e0db3d8fd7738a308a88effe6240c59f3226eb93e8f020c216149"
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
    ENV.prepend_path "PATH", Formula["python@2"].opt_libexec/"bin"

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
