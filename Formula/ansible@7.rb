class AnsibleAT7 < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/39/47/bef8fd8bc2b6e7b5058b61565959c91819eccb8be119a66f8524c0252c62/ansible-7.7.0.tar.gz"
  sha256 "9c206ba515f13a0cc9c919d496218ba26df581755bdc39be85b074066c699a02"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f27acb1e79fc5f1047647b0047cb910dd684da2e1f99a4e33ed3dde1665393d"
    sha256 cellar: :any,                 arm64_monterey: "061fe151950ba6c76eae4ad984afd739d2aecf234fc877320b87f5e2324cd355"
    sha256 cellar: :any,                 arm64_big_sur:  "7267659e7cb06ff2bdf47432c4cf79f9a414f2d0470b301d5090705e6fa89734"
    sha256 cellar: :any,                 ventura:        "b1bfff31fbb19932ebdf2486df33eb8695b51547fc25c4a1968fedc7fc5bad8a"
    sha256 cellar: :any,                 monterey:       "676fe318fed0cee7f015d230a2c6fb627e2477bea6ccb84684b75b7e64fa3bfa"
    sha256 cellar: :any,                 big_sur:        "883776bca93186c6e273e53714b2829b4090dee4a3572a5350dbbd5c30df5d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a163bc4590d60952bd202624948851aa2ef2f1a741618ad4cfa771bc1e0c226b"
  end

  keg_only :versioned_formula

  # https://docs.ansible.com/ansible/latest/reference_appendices/release_and_maintenance.html#ansible-community-package-release-cycle
  deprecate! date: "2023-06-22", because: :unmaintained

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  uses_from_macos "krb5"
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  # This will collect requirements from:
  #   ansible
  #   docker
  #   python-neutronclient (OpenStack)
  #   shade (OpenStack)
  #   pywinrm (Windows)
  #   kerberos (Windows)
  #   boto3 (AWS)
  #   apache-libcloud (Google GCE)
  #   passlib (htpasswd core module)
  #   zabbix-api (Zabbix extras module)
  #   junos-eznc (Juniper device support)
  #   jxmlease (Juniper device support)
  #   dnspython (DNS Lookup - dig)
  #   pysphere3 (VMware vSphere support)
  #   python-consul (Consul support)
  #   requests-credssp (CredSSP support for windows hosts)
  #   openshift (k8s module support)
  #   pexpect (expect module support)
  #   ntc-templates (Parsing semi-structured text)
  #   proxmoxer (Proxmox VE support)

  # Automatically updated resources
  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/d6/27/06f4b8a082d9ecd055da28f37fca69ebd0f7b8427d5f6068b6125b1441a8/ansible-core-2.14.7.tar.gz"
    sha256 "2be26d617483b2b1621ec93ca57f2e24faace90cb9f07d8dca3f68a8428d9cd6"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/ee/33/1cc39b29f392154765c9c86446892066275363c6f3cea6a5b1834d9c4301/apache-libcloud-3.7.0.tar.gz"
    sha256 "148a9e50069654432a7d34997954e91434dd38ebf68832eb9c75d442b3e62fad"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/36/b1/e5a1c2ebeb64ccc9c2a4ae133f5955d9824482628ed4bf0331c73323f0de/autopage-0.5.1.tar.gz"
    sha256 "01be3ee61bb714e9090fcc5c10f4cf546c396331c620c6ae50a2321b28ed3199"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/de/e2/a4dd5b40fadfd97cc6f1a81319a7f0afd742653f8f7b9e7f5bdbd244675a/boto3-1.26.159.tar.gz"
    sha256 "7694df61bd6d253d6d9db34adbcd218b8efbe7f894a4a51611f7e0587ae33218"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ee/28/9417cf3790331c1a55e511cf6afebc26b753a96e3983f5426688c976269c/botocore-1.29.159.tar.gz"
    sha256 "da1c61757d466b82cc89f379a50662064bcb0beb67cc6efa1fbfc9a341bd08b0"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/9d/8b/8e2ebf5ee26c21504de5ea2fb29cc6ae612b35fd05f959cdb641feb94ec4/cachetools-5.3.1.tar.gz"
    sha256 "dce83f2d9b4e1f732a8cd44af8e8fab2dbe46201467fc98b3ef8f269092bf62b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/19/9b/6bc3c126eacaede94eb5374d5a222911b47dc1a47a6773b8b122d0e3e4e8/cliff-4.3.0.tar.gz"
    sha256 "fc5b6ebc8fb815332770b2485ee36c09753937c37cce4f3227cdd4e10b33eacc"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
    sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c8/7d/904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211a/debtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/91/8b/522301c50ca1f78b09c2ca116ffb0fd797eadf6a76085d376c01f9dd3429/dnspython-2.3.0.tar.gz"
    sha256 "224e32b03eb46be70e12ef6d64e0be123a64e621ab4c0822ff6d450d52a540b9"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/21/fa/2fec52e38feb6ce89930be010314aa99ff616d6f6dc068cfaa7491ce5f3e/dogpile.cache-1.2.1.tar.gz"
    sha256 "1d0be0cef90505c9f24e9f00aedab8dce9356d28a4153d5660ab13eeb6a0cfd4"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/4b/e0/d2c96098280f17eb626d4da0b7e553b8e5648d57514c8cefec851c16920c/google-auth-2.20.0.tar.gz"
    sha256 "030af34138909ccde0fbce611afc178f1d65d32fbff281f25738b1fe1c6f3eaa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a3/82/f6e29c8d5c098b6be61460371c2c5591f4a335923639edec43b3830650a4/importlib_metadata-6.7.0.tar.gz"
    sha256 "1aaf550d4f73e5d6783e7acb77aec43d49da8017410afae93822cc9cca98c4d4"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/27/23/97cd1cb5792ece594ec5cf16cc4921f91838c689c82c8078ee442751f8dc/iso8601-2.0.0.tar.gz"
    sha256 "739960d37c74c77bd9bd546a76562ccb581fe3d4820ff5c3141eb49c839fda8f"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/7c/4e/501d8138f3794e8bb2221dc8e214f3a5d4548f5e8ab89968c02c9eba6bd1/junos-eznc-2.6.7.tar.gz"
    sha256 "b3ab81dafb160cd16cba8f26b92b6f5c3333a8d30566a7ebd966fc1f313b0980"
  end

  resource "jxmlease" do
    url "https://files.pythonhosted.org/packages/8d/6a/b2944628e019c753894552c1499bf60e2cef9efea138756c5d66f0d5eb98/jxmlease-1.0.3.tar.gz"
    sha256 "612c1575d8a87026dea096bb75acec7302dd69040fa23d9116e71e30d5e0839e"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/39/cd/f98699a6e806b9d974ea1d3376b91f09edcb90415adbf31e3b56ee99ba64/kerberos-1.3.1.tar.gz"
    sha256 "cdd046142a4e0060f96a00eb13d82a5d9ebc0f2d7934393ed559bac773460a2c"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/ad/a5/f0671fad7d66453d0b088973f69f53bcda24896af5252f9dd26373350e28/keystoneauth1-5.2.1.tar.gz"
    sha256 "f79b1c27ed5a69be4d03a5bc4967df3dfab0c5d76e85226fa2060cffadff74a1"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/34/19/2f351c0eaf05234dc33a6e0ffc7894e9dedab0ff341311c5b4ba44f2d8ac/kubernetes-26.1.0.tar.gz"
    sha256 "5854b0c508e8d217ca205591384ab58389abdae608576f9c9afc35a3c76a366c"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/ee/6f/ef2796c82d097dbead1b804db8457fc8fdc244e3d6860eb0a702315dbf67/ncclient-0.6.13.tar.gz"
    sha256 "f9f8cea8bcbe057e1b948b9cd1b241eafb8a3f73c4981fbdfa1cc6ed69c0a7b3"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "ntc-templates" do
    url "https://files.pythonhosted.org/packages/5d/ae/77ea390f0dafe55b045dd0809d23a2aa14c0c967a951b2b573f7b550ca08/ntc_templates-3.4.0.tar.gz"
    sha256 "aabd6b24a3544d95916de7316e1753112198386a9ccea0601e3e27fb9b25e157"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/6d/fa/fbf4001037904031639e6bfbfc02badfc7e12f137a8afa254df6c4c8a670/oauthlib-3.2.2.tar.gz"
    sha256 "9859c40929662bec5d64f34d01c99e093149682a3f38915dc0655d5a633dd918"
  end

  resource "openshift" do
    url "https://files.pythonhosted.org/packages/97/c0/d8e2aae7b4e8f3709eca4fd8c2f70ea3c66151d1a5259e9a7e1ee2497608/openshift-0.13.1.tar.gz"
    sha256 "a060afb7565dda18b2749857867d80ab22b2f4143264519f493a9cabccc3b8a8"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/ac/bd/99a8970d6638d32b5fc0e3ad1e41adfd1f1de4c47e8e1814e43708104a41/openstacksdk-1.3.0.tar.gz"
    sha256 "207a75e5a81e1173bf251e9976965a66ff2ff379d0a0ba55a4903dcf2b5c1974"
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
    url "https://files.pythonhosted.org/packages/62/b1/8fca23cb700e52e0163b41895d47cea1bfab869de0d7c4ee9f76344bec25/osc-lib-2.8.0.tar.gz"
    sha256 "67e0d413911e8d49cb9601e80eb28dc4b391b3d7dbd70adc9a69a204516d9452"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/c2/f1/9012e248ca4a53d64aa2db2a9aad1c38861ec77237a149a521d00cf95c0a/oslo.config-9.1.1.tar.gz"
    sha256 "b07654b53d87792ae8e739962ad729c529c9938a118d891ece9ee31d59716bc9"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/bc/ea/a81a65b2b322d7f71bb5764c7fb61f9636fbc1f8291e4984e8d3b1a1ab0e/oslo.context-5.1.1.tar.gz"
    sha256 "2f2e79171044efd1807c55713ed2c7f4068b18d73d027819165c4819b287cfaf"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/52/7a/655c1c95666d30400d59612a67f510a5395d821f7ae9e306b3fa2a2102e0/oslo.i18n-6.0.0.tar.gz"
    sha256 "ed10686b75f7c607825177a669155f4e259ce39f6143a375f6359bbcaa4a35cd"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/35/13/d9464bf0330597e92aaf0f15c0aedef7050efcbdf4b863497dd5dbc23d10/oslo.log-5.2.0.tar.gz"
    sha256 "6226336d5b6ee1885f057b65dbede84c4a9c5e4e4ae75a0e8e7f383c163ec480"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/57/7c/fb7ac9b6fd5137763bb1265c85134decfbe3c6a3ee398e1a4b70a8183bad/oslo.serialization-5.1.1.tar.gz"
    sha256 "8abbda8b1763a06071fc28c5d8a9be547ba285f4830e68a70ff88fe11f16bf43"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/f7/49/7f6790af38e9ce1a1418dd74c7d07492d711384269b1cecc69bef136b033/oslo.utils-6.1.0.tar.gz"
    sha256 "76bc0108d50aca972b68fec8298e791b5fbcbeb9a51a27c6986b41b0a6a62eeb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/87/62/cee9551811c846e9735f749dbdf05d4f9f0dbcecd66eae35b5daacf9a117/paramiko-3.2.0.tar.gz"
    sha256 "93cdce625a8a1dc12204439d45033f3261bdb2c201648cfcdc06f9fd0f94ec29"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/18/fa/82e719efc465238383f099c08b5284b974f5002dbe12050bcbbc912366eb/prettytable-3.8.0.tar.gz"
    sha256 "031eae6a9102017e8c7c7906460d150b7ed78b20fd1d8c8be4edaf88556c07ce"
  end

  resource "proxmoxer" do
    url "https://files.pythonhosted.org/packages/00/dd/629ec9dfdab26a75e3120403231bf3dc3ecda3ebe36db72c829ae30cbfca/proxmoxer-2.0.1.tar.gz"
    sha256 "088923f1a81ee27631e88314c609bfe22b33d8a41271b5f02e86f996f837fe31"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/3b/e4/7dec823b1b5603c5b3c51e942d5d9e65efd6ff946e713a325ed4146d070f/pyasn1_modules-0.3.0.tar.gz"
    sha256 "5bd01446b736eb9d31512a30d46c1ac3395d676c6f3cafa4c03eb54b9925631c"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/4f/13/28e88033cab976721512e7741000fb0635fa078045e530a91abb25aea0c0/pyparsing-3.1.0.tar.gz"
    sha256 "edb662d6fe322d6e990b1594b5feaeadf806803359e3d4d42f11e295e588f0ea"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pysphere3" do
    url "https://files.pythonhosted.org/packages/fa/1e/16cf889e0e38380678631a4afebeeb840cb29f54f11413356770efe29240/pysphere3-0.1.8.tar.gz"
    sha256 "c8efe92e7802b59ef67e09fb20b008fc1bd0d253ba97ba689aa892b125283ae1"
  end

  resource "pyspnego" do
    url "https://files.pythonhosted.org/packages/fb/38/46174701e2a2de8b72e79c980324b034203edafff3c543a4134b2c1ae9af/pyspnego-0.9.1.tar.gz"
    sha256 "6eea64f511bdfa192c2f80593ddf124258b0ea560327468953d18420e0ab3597"
  end

  resource "python-consul" do
    url "https://files.pythonhosted.org/packages/7f/06/c12ff73cb1059c453603ba5378521e079c3f0ab0f0660c410627daca64b7/python-consul-1.1.0.tar.gz"
    sha256 "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/bb/57/f59abb588eb28c1b5a8432e3163a2135183672e2dceb747aed0b26f3db01/python-keystoneclient-5.1.0.tar.gz"
    sha256 "ba09bdfeafa2a2196450a327cd3f46f2a8a9dd9d21b838f8cb9b17a99740c6a1"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/c7/d4/df99042bec863ef2d7c037f35cd1faa745d388b4de9cf147f410ecdf2da4/python-neutronclient-10.0.0.tar.gz"
    sha256 "2926d3dc5af2fc55a1726aa9bb031ec022e475a4b9717cb1f005c67ca4e249f2"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/5e/32/12032aa8c673ee16707a9b6cdda2b09c0089131f35af55d443b6a9c69c1d/pytz-2023.3.tar.gz"
    sha256 "1d8ce29db189191fb55338ee6d0387d82ab59f3d00eac103412d64e0ebd0c588"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/7c/ba/78329e124138f8edf40a41b4252baf20cafdbea92ea45d50ec712124e99b/pywinrm-0.4.3.tar.gz"
    sha256 "995674bf5ac64b2562c9c56540473109e530d36bde10c262d5a5296121ad5565"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-credssp" do
    url "https://files.pythonhosted.org/packages/bc/c3/de13b8598287440ab1df7eba97b93278d309dffb920f0163a09e089b71ec/requests-credssp-2.0.0.tar.gz"
    sha256 "229afe2f6e1c9fabef64fc2bdf2a10e794ca6c4a0c00a687d53fbfaf7b8ee71d"
  end

  resource "requests-ntlm" do
    url "https://files.pythonhosted.org/packages/7a/ad/486a6ca1879cf1bb181e3e4af4d816d23ec538a220ef75ca925ccb7dd31d/requests_ntlm-1.2.0.tar.gz"
    sha256 "33c285f5074e317cbdd338d199afa46a7c01132e5c111d36bd415534e9b916a8"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/ac/20/9541749d77aebf66dd92e2b803f38a50e3a5c76e7876f45eb2b37e758d82/resolvelib-0.8.1.tar.gz"
    sha256 "c6ea56732e9fb6fca1b2acc2ccc68a0b6b8c566d8f3e78e0443310ede61dbd37"
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
    url "https://files.pythonhosted.org/packages/49/bd/def2ab4c04063a5e114963aae90bcd3e3aca821a595124358b3b00244407/s3transfer-0.6.1.tar.gz"
    sha256 "640bb492711f4c0c0905e1f62b6aaeb771881935ad27884852411f8e9cacbca9"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/b6/50/277f788967eed7aa2cbb669ff91dff90d2232bfda95577515a783bbccf73/scp-0.14.5.tar.gz"
    sha256 "64f0015899b3d212cb8088e7d40ebaf0686889ff0e243d5c1242efe8b50f053e"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/b0/a6/a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549/shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/c0/5c/61e2afbe62bbe2e328d4d1f426f6e39052b73eddca23b5ba524026561250/simplejson-3.19.1.tar.gz"
    sha256 "6277f60848a7d8319d27d2be767a7546bc965535b28070e310b3a9af90604a4c"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "textfsm" do
    url "https://files.pythonhosted.org/packages/b8/bf/c9147d29c5a3ff4c1c876e16ea02f6d4e4f35ba1bcbb2ac80a254924f0aa/textfsm-1.1.3.tar.gz"
    sha256 "577ef278a9237f5341ae9b682947cefa4a2c1b24dbe486f94f2c95addc6504b5"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/bc/c0/d2e5b8a03ad07c10694ab0804682722b9293fbe89391a8508aff1f6d9603/transitions-0.9.0.tar.gz"
    sha256 "2f54d11bdb225779d7e729011e93a9fb717668ce3dc65f8d4f5a5d7ba2f48e10"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/31/4e/aa6ab8f8812b5766350ed2beb5bc6f3a007c448dd9c178ef5db2d163dac3/websocket-client-1.6.0.tar.gz"
    sha256 "e84c7eafc66aade6d1967a51dfd219aabdf81d15b9705196e11fd81f48666b78"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  resource "yamlordereddictloader" do
    url "https://files.pythonhosted.org/packages/56/e1/1ca77da64cc355f0de483095e841d96f2366f93b095b83869440a296c21d/yamlordereddictloader-0.4.0.tar.gz"
    sha256 "7f30f0b99ea3f877f7cb340c570921fa9d639b7f69cba18be051e27f8de2080e"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/4a/ce/893d6ab7e978d0c00d9154c0cf385016b862438da069302e7ceac0f6c429/zabbix-api-0.5.6.tar.gz"
    sha256 "627ad26769b6831130239182afcb195f64fbf494626bc9eb4b2ac8170de5b775"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    venv = virtualenv_create(libexec, "python3.11")
    # Install all of the resources declared on the formula into the virtualenv.
    resources.each do |r|
      # ansible-core provides all ansible binaries
      if r.name == "ansible-core"
        venv.pip_install_and_link r
      else
        venv.pip_install r
      end
    end
    venv.pip_install_and_link buildpath

    resource("ansible-core").stage do
      man1.install Pathname.glob("docs/man/man1/*.1")
    end
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
    (testpath/"hosts.ini").write [
      "localhost ansible_connection=local",
      " ansible_python_interpreter=#{Formula["python@3.11"].opt_bin}/python3.11",
      "\n",
    ].join
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python", "-c", script

    # Ensure ansible-vault can encrypt/decrypt files.
    (testpath/"vault-password.txt").write("12345678")
    (testpath/"vault-test-file.txt").write <<~EOS
      ---
      content:
        hello: world
    EOS
    system bin/"ansible-vault", "encrypt",
           "--vault-password-file", testpath/"vault-password.txt",
           testpath/"vault-test-file.txt"
    system bin/"ansible-vault", "decrypt",
           "--vault-password-file", testpath/"vault-password.txt",
           testpath/"vault-test-file.txt"
  end
end
