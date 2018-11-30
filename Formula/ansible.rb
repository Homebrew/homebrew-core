class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.7.3.tar.gz"
  sha256 "3f424d2db33cdf8af8e11b146f211c4f93573247bd5894da6d262610475e642f"
  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "ba19cb4acee7b19b3a38ccc939c52018de9e5a47af08850762bab8d99a40b4a8" => :mojave
    sha256 "734676690fe0264315df3d2c674967fb589d1665624b1e23f2a87eb86fc9ed09" => :high_sierra
    sha256 "8d8c6edcebc6a2c31519e064fc4da195d6cf297b94134acba1d9485172771f63" => :sierra
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
    url "https://files.pythonhosted.org/packages/33/07/6e68a96ff240a0e7bb1f6e21093532386a98a82d56512e1e3da6d125f7aa/pbr-5.1.1.tar.gz"
    sha256 "f59d71442f9ece3dffc17bc36575768e1ee9967756e6b6535f0ee1f0054c3d68"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/cd/71/ae99fc3df1b1c5267d37ef2c51b7d79c44ba8a5e37b48e3ca93b4d74d98b/pytz-2018.7.tar.gz"
    sha256 "31cb35c89bd7d333cd32c5f278fca91b523b0834369e757f4c5641ea252236ca"
  end
  ### end

  ### extras for requests[security]
  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/d2/5f/6ed3135eb1e775187f7ecd4e7713f1415516725365e51f9786143f36e024/cryptography-2.4.1.tar.gz"
    sha256 "e85b410885addaeb31a867eabcefc9ef4a7e904ad45eac9e60a763a54b244626"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/65/c4/80f97e9c9628f3cac9b98bfca0402ede54e0563b56482e3e6e45c43c4935/idna-2.7.tar.gz"
    sha256 "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/9b/7c/ee600b2a9304d260d96044ab5c5e57aa489755b92bbeb4c0803f9504f480/pyOpenSSL-18.0.0.tar.gz"
    sha256 "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"
  end
  ### end

  # The rest of this list should always be sorted by:
  # pip install homebrew-pypi-poet && poet_lint $(brew formula ansible)
  resource "Babel" do
    url "https://files.pythonhosted.org/packages/be/cc/9c981b249a455fa0c76338966325fc70b7265521bad641bf2932f77712f4/Babel-2.6.0.tar.gz"
    sha256 "8cba50f48c529ca3fa18cf81fa9403be176d374ac4d60738b839122dfaaa3d23"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/56/e6/332789f295cf22308386cf5bbd1f4e00ed11484299c5d7383378cf48ba47/Jinja2-2.10.tar.gz"
    sha256 "f84be1bb0040caca4cea721fcbbbbd61f9be9464ca236387158b0feea01914a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/ac/7e/1b4c2e05809a4414ebce0892fe1e32c14ace86ca7d50c70f00979ca9b3a3/MarkupSafe-1.1.0.tar.gz"
    sha256 "4e97332c9ce444b0c2c38dd22ddc61c743eb208d916e4265a2a3b575bdccb1d3"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/61/ab/2ac6dea8489fa713e2b4c6c5b549cc962dd4a842b5998d9e80cf8440b7cd/PyNaCl-1.3.0.tar.gz"
    sha256 "0c6100edd16fefd1557da078c7a31e7b7d7a52ce39fdca2bec29d4f7b6e7600c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/9e/a3/1d13970c3f36777c583f136c136f804d70f500168edc1edea6daa7200769/PyYAML-3.13.tar.gz"
    sha256 "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/b9/3e/adfe316292bd2f5ff2556ea09887515c09974483c3028ae39563734e145b/apache-libcloud-2.4.0.tar.gz"
    sha256 "125c410996b84464b426922f1398a317869f27173a6461e32f3b1dfe671d5235"
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
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/78/43/434120c81c42e1571c51879c55c73cdd447a858ae5e2c06f8bcb1839ddc5/boto3-1.9.48.tar.gz"
    sha256 "b8a6d9beff31492bd135709d5fbfbe902931c2a6708c4ccbe01f704924f182b8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/6c/aa/526aca9aebab9a0eee34dc080319e061feb9d6b227b62c8230d62eb2601e/botocore-1.12.48.tar.gz"
    sha256 "7140e51ab0a7aa3b7fa9cf5fefa663e0cd097098fcbd51b12ff8884c8d967754"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/41/b6/4f0cefba47656583217acd6cd797bc2db1fede0d53090fdc28ad2c8e0716/certifi-2018.10.15.tar.gz"
    sha256 "6d58c986d22b038c8c0df30d639f23a3e6d172a05c3583e766f4c0b785c0986a"
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
    url "https://files.pythonhosted.org/packages/90/2a/232a69a1f1fe3bdf9a05fd4ec6072c44b63849771d10b6f21a6be701c943/cliff-2.14.0.tar.gz"
    sha256 "21a24dfee9f4e58c397e725bb1568e031d75a8925def92e4d3def2b755f816bc"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/21/80/a93427ed96b700d08200520fe318438ae6c257103941cd18ca1a8325a49a/cmd2-0.9.6.tar.gz"
    sha256 "5c4d92c089d014dfb750a9d05cefd231e2dca437cc25edf535de7a63cdb9e908"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/6e/db/41233498c210b03ab8b072c8ee49b1cd63b3b0c76f8ea0a0e5d02df06898/contextlib2-0.5.5.tar.gz"
    sha256 "509f9419ee91cdd00ba34443217d5ca51f5a364a404e1dce9e8979cea969ca48"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/79/a2/61c8625f96c8582d3053f89368c483ba62e56233d055e58e372f94a393f0/cryptography-2.4.1.tar.gz"
    sha256 "e85b410885addaeb31a867eabcefc9ef4a7e904ad45eac9e60a763a54b244626"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/56/ea/e8867c97ae9650ecf67edf66ed844c89b3b0a7a54c9ea00b23d889195ec6/debtcollector-1.20.0.tar.gz"
    sha256 "f48639881e0dd492e3576fd714e2a4e422492bb586b9f90affe0f093d7a09ac8"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/6f/24/15a229626c775aae5806312f6bf1e2a73785be3402c0acdec5dbddd8c11e/decorator-4.3.0.tar.gz"
    sha256 "c39efa13fbdeb4506c476c9b3babf6a718da943dab7811c206005a4a956c080c"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/cd/35/ab3995718c7b12d6a5e69f40540fe1df0b505cca5ee6af169d23ab9d0b00/deprecation-2.0.6.tar.gz"
    sha256 "68071e5ae7cd7e9da6c7dffd750922be4825c7c3a6780d29314076009cc39c35"
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
    url "https://files.pythonhosted.org/packages/9e/7a/109e0a3cc3c19534edd843c16e792c67911b5b4072fdd34ddce90d49f355/docker-pycreds-0.3.0.tar.gz"
    sha256 "8b0e956c8d206f832b06aa93a710ba2c3bcbacb5a314449c040b0b814355bbff"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/84/f4/5771e41fdf52aabebbadecc9381d11dea0fa34e4759b4071244fa094804c/docutils-0.14.tar.gz"
    sha256 "51e64ef2ebfb29cae1faa133b3710143496eca21c530f3f71424d77687764274"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/ee/bd/440da735a11c6087eed7cc8747fc4b995cbac2464168682f8ee1c8e43844/dogpile.cache-0.6.7.tar.gz"
    sha256 "fca7deb7c276b879b01c15c5d39b3c05701dc43b263ec3fef1e52cb851cf88ab"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/18/80/57284ac01ab6556efe7ce66e5833a890cf26ec256e49fb6d68091f1b9930/iso-8601-0.3.0.tar.gz"
    sha256 "1b9f74df591812732b69a1cfba5196e176138bf5b0b49a920af5804924cc27e0"
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
    url "https://files.pythonhosted.org/packages/c2/0a/b61333c5de5bf9a12cbee528bca94ccc53b2c8a75d2e828cbfa8c51d0188/junos-eznc-2.2.0.tar.gz"
    sha256 "d97d8babf650abca25a096825aa6d88573d340481a0b0793afcdac4a7bee09d3"
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
    url "https://files.pythonhosted.org/packages/3b/c1/ef5904e9d1961b45c2a2cc0bfd9ac3aaeabfab8580683009fb9a94b65b78/keystoneauth1-3.11.1.tar.gz"
    sha256 "c1adb59c82c989b7c6293231da0fd46d30adfe2b7d9e35f327e3bfe7a0f99656"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/4b/20/ddf5eb3bd5c57582d2b4652b4bbcf8da301bdfe5d805cb94e805f4d7464d/lxml-4.2.5.tar.gz"
    sha256 "36720698c29e7a9626a0dc802ef8885f8f0239bfd1689628ecd459a061f2807f"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz"
    sha256 "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/f3/b6/9affbea179c3c03a0eb53515d9ce404809a122f76bee8fc8c6ec9497f51f/msgpack-0.5.6.tar.gz"
    sha256 "0ee8c8c85aa651be3aa0cd005b5931769eaa658c948ce79428766f1bd46ae2c3"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/68/f4/260ec98ea840757a0da09e0ed8135333d59b8dfebe9752a365b04857660a/munch-2.3.2.tar.gz"
    sha256 "6ae3d26b837feacf732fb8aa5b842130da1daf221f5af9f9d4b2a0a6414b0d51"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/dc/95/acc44c2ff966743fedd1ad991ecf2498f40fd434883c67138b60a6373d49/ncclient-0.6.3.tar.gz"
    sha256 "3ab58ee0d71069cb5b0e2f29a4e605d1d8417bd10af45b73ee3e817fe389fadc"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz"
    sha256 "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/81/39/4e9a026265ba944ddf1fea176dbb29e0fe50c43717ba4fcf3646d099fe38/netifaces-0.10.7.tar.gz"
    sha256 "bd590fcb75421537d4149825e1e63cca225fd47dad861710c46bd1cb329d8cbd"
  end

  resource "ntlm-auth" do
    url "https://files.pythonhosted.org/packages/b5/f4/9df9b6713cf3527453d18b2a4567d49893ca1a1c95a566a88baefcb9796e/ntlm-auth-1.2.0.tar.gz"
    sha256 "7bc02a3fbdfee7275d3dc20fce8028ed8eb6d32364637f28be9e9ae9160c6d5c"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/9f/7d/06813c1256abcd83df5ba87c4a547bce741baa54f5a948659359137c2aca/openstacksdk-0.19.0.tar.gz"
    sha256 "822356c4dfff43273a75ed60825c934fc40fb9a8132dcfcdd8a3beb81a183e61"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/80/bb/e7d5c7ae06ccbab1c9a3f8b9ea2a99d16981b66b5f2cad21f1b94a0eca0e/os-client-config-1.31.2.tar.gz"
    sha256 "4e9de6be30d2314bfb40a723ee01fa630e9b6764e0e5680e7418acf1566d0e12"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/a2/bc/c8bc9cce8ec064558ae9b8ab2dbea9d5bdfbaf5c50f637a19cb120410b10/os-service-types-1.3.0.tar.gz"
    sha256 "5790117948d1673319a2dcf4c545c2059a1a933705e8ded586add88200ac9d95"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/8d/a8/b63a53baed828a3e46ff2d1ee5cb63f794e9e071f05e99229642edfc46a5/osc-lib-1.11.1.tar.gz"
    sha256 "4b118f72757b84c8375e8af47bb59151337fbc50305a6c5b5307ad7442422af4"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/b9/a0/402bd835656b6261df354daa16a814eaccf0221a512ceffec49504125783/oslo.config-6.7.0.tar.gz"
    sha256 "5d57ae2efc4f61b6ae11d0074baa93e9ab5e13be77f899d24d280ce66b92208c"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/79/d7/fe6f06ab54056091c4a4a203ed54d26851726a0f7145b4bb68c9ebcb1a47/oslo.context-2.21.0.tar.gz"
    sha256 "163d3d24a90545c2a56a587499027106b5a76d7c9854d2a906e19dd794d6b313"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/d7/ec/70a4b44b07a64dd34a1b37eaba4c19bad16e37670f1f874e88c780fdd6c6/oslo.i18n-3.22.1.tar.gz"
    sha256 "dccc5d4f3c0976917a47de709f4e49db1b3ce790bdadc852e38238f9cdb94b0d"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/dd/6a/84d0dc467f227014e579881c9d96895e5a6c312f5005ad13eb26f07ca7cb/oslo.log-3.40.1.tar.gz"
    sha256 "2209490e6326c23e1310ca26e8956aedbc7b8d5eea537689b8342efd353efdbe"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/ec/ef/e08efaec5c3bc155f6e6cfc1703bb6e6f95171332436a24a6ee6d15ba01c/oslo.serialization-2.28.1.tar.gz"
    sha256 "fd1febd9abe2042052846a39b7b8ad0f878cc5365d4484d241f0b0711601b8ee"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/5e/af/236047dfea57407df332e49e1b68d023c3e1408ab24e4d9d8c7a2a8be519/oslo.utils-3.37.1.tar.gz"
    sha256 "374bc8f1be9969cc15b7ac70afb5bd2ec58bc1220f5196e6d53ab83c9f0b1888"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/cf/50/1f10d2626df0aa97ce6b62cf6ebe14f605f4e101234f7748b8da4138a8ed/packaging-18.0.tar.gz"
    sha256 "0886227f54515e592aaa2e5a553332c73962917f2831f1b0f9b9f4380a4b9807"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/a4/57/86681372e7a8d642718cadeef38ead1c24c4a1af21ae852642bf974e37c7/paramiko-2.4.2.tar.gz"
    sha256 "a8975a7df3560c9f1e2b43dc54ebd40fd00a7017392ca5445ce7df409f900fcb"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/10/46/059775dc8e50f722d205452bced4b3cc965d27e8c3389156acd3b1123ae3/pyasn1-0.4.4.tar.gz"
    sha256 "f58f2a3d12fd754aa123e9fa74fb7345333000a035f3921dbdaa08597aa53137"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d0/09/3e6a5eeb6e04467b737d55f8bba15247ac0876f98fae659e58cd744430c6/pyparsing-2.3.0.tar.gz"
    sha256 "f353aab21fd474459d97b709e527b5571314ee5f067441dc9f88e33eecd96592"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/2d/0f/4eda562dffd085945d57c2d9a5da745cfb5228c02bc90f2c74bbac746243/pyperclip-1.7.0.tar.gz"
    sha256 "979325468ccf682104d5dcaf753f869868100631301d3e72f47babdea5700d1c"
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
    url "https://files.pythonhosted.org/packages/7f/06/c12ff73cb1059c453603ba5378521e079c3f0ab0f0660c410627daca64b7/python-consul-1.1.0.tar.gz"
    sha256 "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/0e/01/68747933e8d12263d41ce08119620d9a7e5eb72c876a3442257f74490da0/python-dateutil-2.7.5.tar.gz"
    sha256 "88f9287c0174266bb0d8cedd395cfba9c58e87e5ad86b2ce58859bc11be3cf02"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/4a/d7/7ee2efca36b975da19b5e2ae76a6dec38a38f8fb5cc92145aa9c58903312/python-keystoneclient-3.18.0.tar.gz"
    sha256 "2825f3bf20f8b4f6b43bdf393462de3d4b116135b02bb4059960c7e9caf638d3"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/47/af/b2f1f26df007078e23a651a1af4fb2100d075ccb24fefe70028c9c0f23c7/python-neutronclient-6.11.0.tar.gz"
    sha256 "eacc4626cd1f59390977e89aad9a3a7600dc45e916020e0b0946912b7c174bc4"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/5b/8b/eae19a3574256c834213838310364838a869d128538609da2099cb027c25/pywinrm-0.3.0.tar.gz"
    sha256 "799fc3e33fec8684443adf5778860388289102ea4fa1458f1bf307d167855573"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/40/35/298c36d839547b50822985a2cf0611b3b978a5ab7a5af5562b8ebe3e1369/requests-2.20.1.tar.gz"
    sha256 "ea881206e59f41dbd0bd445437d792e43906703fff75ca8ff43ccdb11f33f263"
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
    url "https://files.pythonhosted.org/packages/a6/7d/735579c8cd4f903cd3002be68581dfe8d48c7498b4e6e7a874065d2af1a5/scp-0.13.0.tar.gz"
    sha256 "cfcc275c249ae59480f88fa55c4bd7795ce8b48d3a9b8fd635d82958084b4124"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/71/25/21c9a9765dd1321282693ce03bdab751a86b5ff04c7a9347a8671fecee72/shade-1.30.0.tar.gz"
    sha256 "f774ddd3190d6e3a97aa55617d0b10d578e7c8b141104331e2de7f388aeca405"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/e3/24/c35fb1c1c315fc0fffe61ea00d3f88e85469004713dab488dee4f35b0aff/simplejson-3.16.0.tar.gz"
    sha256 "b1f329139ba647a9548aa05fb95d046b4a677643070dc2afc05fa2e975d09ca5"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/fd/e3/5bc7226601d6405b588efc9c9f22e3cb0ada577eb957cdcd0ae9093ab6d8/stevedore-1.30.0.tar.gz"
    sha256 "b92bc7add1a53fb76c634a178978d113330aaf2006f9498d9e2414b31fbfc104"
  end

  resource "subprocess32" do
    url "https://files.pythonhosted.org/packages/be/2b/beeba583e9877e64db10b52a96915afc0feabf7144dcbf2a0d0ea68bf73d/subprocess32-3.5.3.tar.gz"
    sha256 "6bc82992316eef3ccff319b5033809801c0c3372709c5f6985299c88ac7225c3"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b1/53/37d82ab391393565f2f831b8eedbffd57db5a718216f82f1a8b4d381a1c1/urllib3-1.24.1.tar.gz"
    sha256 "de9529817c93f27c8ccbfead6985011db27bd0ddfcdb2d86f3f663385c6a9c22"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/55/11/e4a2bb08bb450fdbd42cc709dd40de4ed2c472cf0ccb9e64af22279c5495/wcwidth-0.1.7.tar.gz"
    sha256 "3df37372226d6e63e1b1e1eda15c594bca98a22d33a23832a90998faa96bc65e"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/35/d4/14e446a82bc9172d088ebd81c0b02c5ca8481bfeecb13c9ef07998f9249b/websocket_client-0.54.0.tar.gz"
    sha256 "e51562c91ddb8148e791f0155fdb01325d99bb52c4cdbb291aee7a3563fd0849"
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
    ENV.prepend_path "PATH", Formula["python"].opt_libexec/"bin"

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
    system libexec/"bin/python3", "-c", script
  end
end
