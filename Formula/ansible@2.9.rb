class AnsibleAT29 < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://files.pythonhosted.org/packages/69/a5/66a19a54e4565c94532807556e992609a3789048a1686d67e39c9e0b322a/ansible-2.9.21.tar.gz"
  sha256 "4098246b67aa143e1e3af79d99346419e0545d5405d1cdf6e7fd389beab6de5a"
  license "GPL-3.0-or-later"

  # The newest PyPI release won't be a 2.9.x version, so we match versions from
  # the links in the "Release History" section.
  livecheck do
    url :stable
    regex(%r{href=.*?/project/ansible/v?(2\.9(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "3198997b5e28c55a3316ee33d37c3fee7598a95438323e266f3725efa33cc071"
    sha256 cellar: :any, big_sur:       "eb288d9cf23fdaf1959854b07f677fd58965521a5da05e788521047bec8442a3"
    sha256 cellar: :any, catalina:      "32c4d5c641bb8df8cb1fc8ba922511ba0ab2f0d0ce1fdb13ca1b221879bae001"
    sha256 cellar: :any, mojave:        "30701024ebd7cdcafe5b95fe47cdc6f2d5e3250c6797c18120a16804b69f86bc"
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "krb5"
  uses_from_macos "libffi"
  uses_from_macos "libxslt"

  # The second (short) block of resources can't be automatically updated and should be cared for manually.
  # The first (long) block can be updated by two slightly different methods.
  # A) run `brew update-python-resources ansible@2.9 --print-only` and replace the resource block manually.
  # B) temporarily comment out the "Manually updated resources" block and run
  # `brew update-python-resources ansible@2.9`.
  #
  # This will collect requirements from:
  #   ansible
  #   docker-py
  #   python-neutronclient (OpenStack)
  #   shade (OpenStack)
  #   pywinrm (Windows)
  #   kerberos (Windows)
  #   boto3 (AWS)
  #   apache-libcloud (Google GCE)
  #   python-keyczar (Accelerated Mode)
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

  # Automatically updated resources
  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/39/e0/64f54da78a1856713810e7b5f540fec53582ca91afaab0568ed44527d4fe/apache-libcloud-3.3.1.tar.gz"
    sha256 "d7450453eaf5904eb4fb4f74cf9f37dc83721a719bce34f5abb336b1a1ab974d"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/4d/e0/8f3ccee89317124211d2efa44739c939b99e2446b82596c8fc6e824cf851/attrs-21.1.0.tar.gz"
    sha256 "3901be1cb7c2a780f14668691474d9252c070a756be0a9ead98cfeabfa11aeb8"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d8/ba/21c475ead997ee21502d30f76fd93ad8d5858d19a3fad7cd153de698c4dd/bcrypt-3.2.0.tar.gz"
    sha256 "5b93c1726e50a93a033c36e5ca7fdcd29a5c7395af50a6892f5d9e7c6cfbfb29"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/40/5b/a25eb36bd333f246ab47705bf4ce3a3512c62612470cc8956e0b214deca7/boto3-1.17.67.tar.gz"
    sha256 "61fe8cbb2d4bf1c9a69a73b3f2c68464e0ab587c9367b35f0ef691f372d5ce67"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/af/70/4fb7c31c7dc3a43aa716a3b1dca4f0b37c71998af7c74c40dba844c919bc/botocore-1.20.67.tar.gz"
    sha256 "4666fb5bdf7d78c51d465bac7d9eb1d31c34be46990cd1ad2d1b338bbec8c049"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/52/ba/619250fa6bc11ce6aa4de0604d45843090a53cd7d10d7253b89669313370/cachetools-4.2.2.tar.gz"
    sha256 "61b5ed1e22a0924aed1d23b478f37e8d52549ff8a961de2909c69bf950020cff"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/24/fd/49d46908eb2cf67e4fcd304aab2b295b8269e2fe62461fd6fb9b9a1e6e1c/cliff-3.7.0.tar.gz"
    sha256 "389c81960de13f05daf1cbd546f33199e86c518ba4266c79ec7a153a280980ea"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/00/65/f580d23070a3f4eadaece9e4edcea002bc7fed639debc63c7b81a42fbe7f/cmd2-1.5.0.tar.gz"
    sha256 "701a8c9975c4abc45e5d13906ab149f959f812869106347323a3f89ac0e82a62"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9b/77/461087a514d2e8ece1c975d8216bc03f7048e6090c5166bc34115afdaa53/cryptography-3.4.7.tar.gz"
    sha256 "3d10de8116d25649631977cb37da6cbdd2d6fa0e0281d014a5b7d337255ca713"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/43/db/878dd456ccdbba6e466fc91e2534fd183a345a3fe261c4780a0e46c6dab0/debtcollector-2.2.0.tar.gz"
    sha256 "787981f4d235841bf6eb0467e23057fb1ac7ee24047c32028a8498b9128b6829"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/a9/09/dd085a8afcf48fdaba851fe10956d5dbf1e9091206f7ca717223563f75c2/decorator-5.0.7.tar.gz"
    sha256 "6f201a6c4dac3d187352661f508b9364ec8091217442c9478f1f83c003a0f060"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/13/27/5277de856f605f3429d752a39af3588e29d10181a3aa2e2ee471d817485a/dnspython-2.1.0.zip"
    sha256 "e4a87f0b573201a0f3727fa18a516b055fd1107e0e5477cded4a2de497df1dd4"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/c5/e6/d1f6c00b7221e2d7c4b470132c931325c8b22c51ca62417e300f5ce16009/docker-pycreds-0.4.0.tar.gz"
    sha256 "6ce3270bcaf404cc4c3e27e4b6c70d3521deae82fb508767870fdbf772d584d4"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/55/51/24484f0f713f3499da44f5b4483cf0e5b5284572980530065b97b3d41c83/dogpile.cache-1.1.2.tar.gz"
    sha256 "2134464672a3deb7ef1366a8691726686d8c62540e4208f1a40c9aaa1a0b6a45"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/35/93/d5d63fde20def63d708b1f341c90d52fe75d0ade870975012e791583509e/google-auth-1.30.0.tar.gz"
    sha256 "9ad25fba07f46a628ad4d0ca09f38dcb262830df2ac95b217f9b0129c9e42206"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/f9/ed/b97abc7877e5b253eef96a469f47d617b0ebcccc735405fa1a620c7ee833/iso8601-0.1.14.tar.gz"
    sha256 "8aafd56fa0290496c5edbb13c311f78fa3a241f0853540da09d9363eae3ebd79"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/4f/e7/65300e6b32e69768ded990494809106f87da1d436418d5f1367ed3966fd7/Jinja2-2.11.3.tar.gz"
    sha256 "a6d58433de0ae800347cab1fa3043cebbabe8baa9d29e668f1c768cb87a333c6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/b4/4a/5260acb93dab4138e95ae69477a84b0b25c5440988e4bb97bd2328ac14f6/junos-eznc-2.6.0.tar.gz"
    sha256 "761a85a1485f8dc41b983ae7296889c7a78394b78d2de68f0831b7efa5f6ca34"
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
    url "https://files.pythonhosted.org/packages/d3/65/e6a02ffec522bc5382438b1c4c855899f4d65978d4cfc23cded2dcab931e/keystoneauth1-4.3.1.tar.gz"
    sha256 "93605430a6d1424f31659bc5685e9dc1be9a6254e88c99f00cffc0a60c648a64"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/a1/56/fd57e391f60dc143402e45560ca87df1d74ddade5ac9b7e9f2cc0338171e/kubernetes-12.0.1.tar.gz"
    sha256 "ec52ea01d52e2ec3da255992f7e859f3a76f2bdb51cf65ba8cd71dfc309d8daa"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e5/21/a2e4517e3d216f0051687eea3d3317557bde68736f038a3b105ac3809247/lxml-4.6.3.tar.gz"
    sha256 "39b78571b3b30645ac77b95f7c69d1bffc4cf8c3b157c435a34da72e78c82468"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/43/a1/ec48010724eedfe2add68eb7592a0d238590e14e08b95a4ffb3c7b2f0808/munch-2.5.0.tar.gz"
    sha256 "2d735f6f24d4dba3417fa448cae40c6e896ec1fdab6cdb5e6510999758a4dbd2"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/72/fd/ccae38393c22099229b68e8cdf061408b824e09ee207e2401c224398c5b0/ncclient-0.6.9.tar.gz"
    sha256 "0112f2ad41fb658f52446d870853a63691d69299c73c7351c520d38dbd8dc0c4"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
  end

  resource "ntc-templates" do
    url "https://files.pythonhosted.org/packages/26/0e/bb9c80ec638facbabf68dc338e7a7aa4b33dd165dff08d96d5e776d4b6f4/ntc_templates-2.0.0.tar.gz"
    sha256 "32d3b371dfe5aecd4c36f56184f109f1f75e4768e6087d234c0371cbefe82bcd"
  end

  resource "ntlm-auth" do
    url "https://files.pythonhosted.org/packages/44/a5/ab45529cc1860a1cb05129b438b189af971928d9c9c9d1990b549a6707f9/ntlm-auth-1.5.0.tar.gz"
    sha256 "c9667d361dc09f6b3750283d503c689070ff7d89f2f6ff0d38088d5436ff8543"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fc/c7/829c73c64d3749da7811c06319458e47f3461944da9d98bb4df1cb1598c2/oauthlib-3.1.0.tar.gz"
    sha256 "bee41cc35fcca6e988463cacc3bcb8a96224f470ca547e697b604cc697b2f889"
  end

  resource "openshift" do
    url "https://files.pythonhosted.org/packages/39/2b/7ff97fa8874de0d65f1bbb9c881eb0a40bf1c9b72a8ada187680758a61ee/openshift-0.12.0.tar.gz"
    sha256 "6a08119c3e20a226493e9e1c9e0a7c008ac90bf578eb7efc7305127eaf179a5e"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/d2/38/33a4e7a6de6592298b883e26090925d33b16ff973d87c53c60c847fcd425/openstacksdk-0.56.0.tar.gz"
    sha256 "9c7633746a5603ef059f95f33d5aa8116066204de65b572c877a8c31120ef65b"
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
    url "https://files.pythonhosted.org/packages/f4/70/a92bb13b8eaf13be71e72d5137c338279eb139dddc8b146b9849f5e20259/osc-lib-2.3.1.tar.gz"
    sha256 "f7d178dc6fcf5e5c069206e4fcf7206bf6369e3c855ec5b8498c7f6bb28be75e"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/20/94/6eb0fbbabfbe49863e7e5333289fb5b179246506e6aed37ba8f0f9dca9d4/oslo.config-8.6.0.tar.gz"
    sha256 "dadb10ea187b6282622a31be3a15bd1c45dc0bc2a4f232ec8762ae8196982f28"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/22/4e/336321171977ea62711f5d896e0d597346ca4f290e0caa2de1b10f748838/oslo.context-3.2.0.tar.gz"
    sha256 "0e7d96a95c276de2da0f458ef34153347327ac34fe33b264be2bb59eac51e620"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/de/6f/e8343be26e69e42b3d30610c3ffee576e5b901be6792e5c3af1384613b40/oslo.i18n-5.0.1.tar.gz"
    sha256 "3484b71e30f75c437523302d1151c291caf4098928269ceec65ce535456e035b"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/e0/2b/30e41e5cef9da3aafe8a174fde3bcde5ebdec69644036302b1a75570b910/oslo.log-4.4.0.tar.gz"
    sha256 "0883be3099cd9f8e17843b574018627e1d64243aabcf6cdbe1ebdd1cb5784448"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/0a/85/9af1feeff44ee56868145674e0c2e6654e8ff2241c5bc178bb9539065c3d/oslo.serialization-4.1.0.tar.gz"
    sha256 "cecc7794df806c85cb70dbd6c2b3af19bc68047ad29e3c6442be90a0a4de5379"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/6e/c2/2e3800122ec247efc79ee2f4a482185926613d162bfe29d74bbba81d77b0/oslo.utils-4.8.0.tar.gz"
    sha256 "193111209bed092229b75be725194a6d4f3464c2692a2ac9fb34c46cd8013edb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/cf/a1/20d00ce559a692911f11cadb7f94737aca3ede1c51de16e002c7d3a888e0/paramiko-2.7.2.tar.gz"
    sha256 "7f36f4ba2c0d81d219f4595e35f70d56cc94f9ac40a6acdf51d6ca210ce65035"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/b6/06/9da9ee59a67fae7761aab3ccc84fa4f3f33f125b370f1ccdb915bf967c11/passlib-1.7.4.tar.gz"
    sha256 "defd50f72b65c5402ab2c573830a6978e5f202ad0d984793c8dde2c4152ebe04"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/35/8c/69ed04ae31ad498c9bdea55766ed4c0c72de596e75ac0d70b58aa25e0acf/pbr-5.6.0.tar.gz"
    sha256 "42df03e7797b796625b1029c0400279c7c34fd7df24a7d7818a1abb5b38710dd"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/d4/c6/d388b3d4992acf413d1b67101107b7f4651cc2835abd0bbd6661678eb2c1/prettytable-2.1.0.tar.gz"
    sha256 "5882ed9092b391bb8f6e91f59bcdbd748924ff556bb7c634089d5519be87baa0"
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
    url "https://files.pythonhosted.org/packages/0c/fd/a7be2120e559597a5f58d269d87dcc6492aa0a01c24d1a2f20c0e1607666/pyspnego-0.1.5.tar.gz"
    sha256 "c4bef557e8571bcac72bd982c1215106661953a138cc186d568cb3ca9b85aadd"
  end

  resource "python-consul" do
    url "https://files.pythonhosted.org/packages/7f/06/c12ff73cb1059c453603ba5378521e079c3f0ab0f0660c410627daca64b7/python-consul-1.1.0.tar.gz"
    sha256 "168f1fa53948047effe4f14d53fc1dab50192e2a2cf7855703f126f469ea11f4"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/0d/17/aaaa6e508ca437360eb348486d6ac7cf17e434400acd222548361959b4bd/python-keystoneclient-4.2.0.tar.gz"
    sha256 "0248426e483b95de395086482c077d48e45990d3b1a3e334b2ec8b2e108f5a8a"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/ad/86/d38f25f73071e2d729cc505aa984b19a4656b581a861f1252b23ce0012d1/python-neutronclient-7.3.0.tar.gz"
    sha256 "41b9a4bab8ebb2428f926cd1f7077df6c1d997f384e48aa0cbec049b8b54536c"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/fc/88/be0ea1af44c3bcc54e4c41e4056986743551693c77dfe50b48a3f4ba1bf7/pywinrm-0.4.1.tar.gz"
    sha256 "4ede5c6c85b53780ad0dbf9abef2fa2ea58f44c82256a84a63eae5f1205cea81"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requests-credssp" do
    url "https://files.pythonhosted.org/packages/45/d6/c308425fe38e33b5942e7ebd0a20b0dccafc1c89b6276241ccf1ea2f0922/requests-credssp-1.2.0.tar.gz"
    sha256 "63709d23bf66cff5af0c1abab8f99c308be501f7ab4d47d896ad43d20fc441f1"
  end

  resource "requests_ntlm" do
    url "https://files.pythonhosted.org/packages/3e/02/6b31dfc8334caeea446a2ac3aea5b8e197710e0b8ad3c3035f7c79e792a8/requests_ntlm-1.1.0.tar.gz"
    sha256 "9189c92e8c61ae91402a64b972c4802b2457ce6a799d658256ebf084d5c7eb71"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/70/e2/1344681ad04a0971e8884b9a9856e5a13cc4824d15c047f8b0bbcc0b2029/rfc3986-1.4.0.tar.gz"
    sha256 "112398da31a3344dc25dbf477d8df6cb34f9278a94fee2625d89e4514be8bb9d"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/62/cf/148028462ab88a71046ba0a30780357ae9e07125863ea9ca7808f1ea3798/ruamel.yaml-0.17.4.tar.gz"
    sha256 "44bc6b54fddd45e4bc0619059196679f9e8b79c027f4131bb072e6a22f4d5e28"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/31/ea/957c864e8f0aafab52edfd18bbaacf342a1935ba3a5cb6b5704a1738ebac/scp-0.13.3.tar.gz"
    sha256 "8bd748293d7362073169b96ce4b8c4f93bcc62cfc5f7e1d949e01e406a025bd4"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/b0/a6/a83f14eca6f7223319d9d564030bd322ca52c910c34943f38a59ad2a6549/shade-1.33.0.tar.gz"
    sha256 "36f6936da93723f34bf99d00bae24aa4cc36125d597392ead8319720035d21e8"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/49/45/a16db4f0fa383aaf0676fb7e3c660304fe390415c243f41a77c7f917d59b/simplejson-3.17.2.tar.gz"
    sha256 "75ecc79f26d99222a084fbdd1ce5aad3ac3a8bd535cd9059528452da38b68841"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/95/bc/dc386a920942dbdfe480c8a4d953ff77ed3dec99ce736634b6ec4f2d97c1/stevedore-3.3.0.tar.gz"
    sha256 "3a5bbd0652bf552748871eaa73a4a8dc2899786bc497a2aa1fcb4dcdb0debeee"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/ee/ca/8e6eafd9f2d1af7f0bee4af9add66ea633c82519d3d2c40701fa5fb66ad6/transitions-0.8.8.tar.gz"
    sha256 "e7a86b31a161a76133f189b3ae9dad2755a80ea4c1e0eee1805648d021fb677d"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/48/bf/c706b56243f1641159ff211b51d3341024e1cdf63defc2b74595b6319039/websocket-client-0.59.0.tar.gz"
    sha256 "d376bd60eace9d437ab6d7ee16f4ab4e821c9dae591e1b783c58ebd8aaf80c5c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  resource "yamlordereddictloader" do
    url "https://files.pythonhosted.org/packages/56/e1/1ca77da64cc355f0de483095e841d96f2366f93b095b83869440a296c21d/yamlordereddictloader-0.4.0.tar.gz"
    sha256 "7f30f0b99ea3f877f7cb340c570921fa9d639b7f69cba18be051e27f8de2080e"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/e3/ed/2092731880f0de5b07067fc446dc0fc5166f2ee98018b6d524cd3e28a69d/zabbix-api-0.5.4.tar.gz"
    sha256 "2d6c62001cb79a7de6fe286424967276edaca09d3833b72fb04f7863f29fce4b"
  end

  # Manually updated resources
  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"

    # Fix warnings "SyntaxWarning: "is" with a literal. Did you mean "=="?" for python 3.8
    # Patch can be removed and resource can be set to auto update if v2.7.1 is ever released in pypi
    patch do
      url "https://github.com/dlitz/pycrypto/commit/4e4cc0beefbb316db2a8750e747e697df0b754d7.patch?full_index=1"
      sha256 "f82fedee6cf73c868b55af3ab2b7d2d029b84960be0dc3baf85bb4bf541e1451"
    end
  end

  resource "textfsm" do
    url "https://github.com/google/textfsm/archive/v1.1.1.tar.gz"
    sha256 "9299d54544b679ef2a477c9256ec5e906c649f8f79593b71d2bb56e1c96e6601"
  end

  def install
    ENV.prepend_path "PATH", Formula["python@3.9"].opt_libexec/"bin"

    on_macos do
      # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
      ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra
    end

    virtualenv_install_with_resources

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
