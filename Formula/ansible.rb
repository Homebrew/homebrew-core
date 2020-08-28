class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.9.11.tar.gz"
  sha256 "88f9d033ece7fd51eca3abb4f02e13b63c924b97f9705a997d5a711c0cf42ab1"
  license "GPL-3.0"
  head "https://github.com/ansible/ansible.git", branch: "devel"

  livecheck do
    url "https://releases.ansible.com/ansible/"
    regex(/href=.*?ansible[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "a34259e91253838f02bf51c987cccfc56e8b756b6035bf85221d973a49911efe" => :catalina
    sha256 "f7abe5a6aa6d20b69671ac6c2d683a9f4f402ed102a05eeb0e71af430751ff72" => :mojave
    sha256 "3920c151d1a517bf76ac13f61868200fd327f772dc78d72ee285c20f7e299205" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@3.8"

  uses_from_macos "libffi"
  uses_from_macos "libxslt"

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
  #   requests-credssp (CredSSP support for windows hosts)
  #   openshift (k8s module support)
  #   pexpect (expect module support)

  ### setup_requires dependencies
  resource "pbr" do
    url "https://files.pythonhosted.org/packages/8a/a8/bb34d7997eb360bc3e98d201a20b5ef44e54098bb2b8e978ae620d933002/pbr-5.4.5.tar.gz"
    sha256 "07f558fece33b05caf857474a366dfcc00562bca13dd8b47b2b3e22d9f9bf55c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f4/f6/94fee50f4d54f58637d4b9987a1b862aeb6cd969e73623e02c5c00755577/pytz-2020.1.tar.gz"
    sha256 "c35965d010ce31b23eeb663ed3cc8c906275d6be1a34393a1d73a41febf4a048"
  end
  ### end

  ### extras for requests[security]
  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/bf/ac/552fc8729d90393845cc3a2062facf4a89dcbe206fa78771d60ddaae7554/cryptography-3.0.tar.gz"
    sha256 "8e924dbc025206e97756e8903039662aa58aa9ba357d8e1d8fc29e3092322053"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0d/1d/6cc4bd4e79f78be6640fab268555a11af48474fac9df187c3361a1d1d2f0/pyOpenSSL-19.1.0.tar.gz"
    sha256 "9a24494b2602aaf402be5c9e30a0b82d4a5c67528fe8fb475e3f3bc00dd69507"
  end
  ### end

  # The rest of this list should always be sorted by:
  # pip install homebrew-pypi-poet && poet_lint $(brew formula ansible)
  resource "Babel" do
    url "https://files.pythonhosted.org/packages/34/18/8706cfa5b2c73f5a549fdc0ef2e24db71812a2685959cff31cbdfc010136/Babel-2.8.0.tar.gz"
    sha256 "1aac2ae2d0d8ea368fa90906567f5c08463d98ade155c0c4bfedd6a0f7160e38"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/64/a7/45e11eebf2f15bf987c3bc11d37dcc838d9dc81250e67e4c5968f6008b6c/Jinja2-2.11.2.tar.gz"
    sha256 "89aab215427ef59c34ad58735269eb58b1a5808103067f7bb9d5836c651b3bb0"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/b9/2e/64db92e53b86efccfaea71321f597fa2e1b2bd3853d8ce658568f7a13094/MarkupSafe-1.1.1.tar.gz"
    sha256 "29872e92839765e546828bb7754a68c418d927cd064fd4708fab9fe9c8bb116b"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "PyNaCl" do
    url "https://files.pythonhosted.org/packages/cf/5a/25aeb636baeceab15c8e57e66b8aa930c011ec1c035f284170cacb05025e/PyNaCl-1.4.0.tar.gz"
    sha256 "54e9a2c849c742006516ad56a88f5c74bf2ce92c9f67435187c3c5953b346505"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/ae/dd/a505a95ef51f097125cbd277280601e92c26a9ad18986b2846d306f73aca/apache-libcloud-3.1.0.tar.gz"
    sha256 "bbb858e045ba5e06d61632c08b9828625766aae30ff4fe727f2bee598c9048ac"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/9f/3d/8beae739ed8c1c8f00ceac0ab6b0e97299b42da869e24cf82851b27a9123/asn1crypto-1.3.0.tar.gz"
    sha256 "5a215cb8dc12f892244e3a113fe05397ee23c5c4ca7a69cd6e69811755efc42d"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/ff/2b/8265224812912bc5b7a607c44bf7b027554e1b9775e9ee0de8032e3de4b2/backports.ssl_match_hostname-3.7.0.1.tar.gz"
    sha256 "bb82e60f9fbf4c080eabd957c39f0641f0fc247d9a16e31e26d594d8f42b9fd2"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/fa/aa/025a3ab62469b5167bc397837c9ffc486c42a97ef12ceaa6699d8f5a5416/bcrypt-3.1.7.tar.gz"
    sha256 "0b0069c752ec14172c5f78208f1863d7ad6755a6fae6fe76ec2c80d13be41e42"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c8/af/54a920ff4255664f5d238b5aebd8eedf7a07c7a5e71e27afcfe840b82f51/boto-2.49.0.tar.gz"
    sha256 "ea0d3b40a2d852767be77ca343b58a9e3a4b00d9db440efb8da74b4e58025e5a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/4d/b9/3d3c712e2b74a5f8fe3b5c0c498d753d13a888dcf317ff69b70c16ab107d/boto3-1.14.28.tar.gz"
    sha256 "ec3a7662e318455727b4b36f4a57ba473a90b6526cebf1fc10e847182f1fd917"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c2/97/5dd8f82db3516407b3936b9d2b012ffb725e89bd749ff425c8dfc93ee4cb/botocore-1.17.28.tar.gz"
    sha256 "71d45ae51c4c1a7ae485836016170a817d8d53292d940d04d72e49e473b98127"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/fc/c8/0b52cf3132b4b85c9e83faa3e4d375575afeb3a1710c40b2b2cd2a3e5635/cachetools-4.1.1.tar.gz"
    sha256 "bbaa39c3dede00175df2dc2b03d0cf18dd2d32a7de7beb68072d13043c9edb20"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/40/a7/ded59fa294b85ca206082306bba75469a38ea1c7d44ea7e1d64f5443d67a/certifi-2020.6.20.tar.gz"
    sha256 "5930595817496dd21bb8dc35dad090f1c2cd0adfaf21204bf6732ca5d8ee34d3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/05/54/3324b0c46340c31b909fcec598696aaec7ddc8c18a63f2db352562d3354c/cffi-1.14.0.tar.gz"
    sha256 "2d384f4a127a15ba701207f7639d94106693b6cd64173d6c8988e2c25f3ac2b6"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/c7/c4/38ea8a52809dd2fd7b6282d21bb17a5f3d13d79df57b53b96dddb41dc2b6/cliff-3.3.0.tar.gz"
    sha256 "611595ad7b4bdf57aa252027796dac3273ab0f4bc1511e839cce230a351cb710"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/d3/1e/224b4d3fcf96e5fa571efa0deb0a9a0485e7582ff76f1b6351dc0fe9a355/cmd2-1.2.1.tar.gz"
    sha256 "5a5d3361fadada16cae0c99b65eba5d49d587fc2e02b3afb058da1872871e7a9"
  end

  resource "contextlib2" do
    url "https://files.pythonhosted.org/packages/02/54/669207eb72e3d8ae8b38aa1f0703ee87a0e9f88f30d3c0a47bebdb6de242/contextlib2-0.6.0.post1.tar.gz"
    sha256 "01f490098c18b19d2bd5bb5dc445b2054d2fa97f09a4280ba2c5f3c394c8162e"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/a1/09/d463e1514308f0c04a46cdcc2502fb2d652f6b19659a403d0592ae6e6f6f/debtcollector-2.1.0.tar.gz"
    sha256 "a25fc6215560d81cb9f2a0b58d6c834f2a24010987027bde169599e138a205af"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/5a/d3/8ae2869247df154b64c1884d7346d412fed0c49df84db635aab2d1c40e62/deprecation-2.1.0.tar.gz"
    sha256 "72b3bde64e5d778694b0cf68178aed03d15e15477116add3fb773e581f9518ff"
  end

  resource "dictdiffer" do
    url "https://files.pythonhosted.org/packages/08/bf/9e878ffc50cbe57b63b46dee9f7689c8e1d6fa1c6b65f18a582c3e1a5ebd/dictdiffer-0.8.1.tar.gz"
    sha256 "1adec0d67cdf6166bda96ae2934ddb5e54433998ceab63c984574d187cc563d2"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/67/d0/639a9b5273103a18c5c68a7a9fc02b01cffa3403e72d553acec444f85d5b/dnspython-2.0.0.zip"
    sha256 "044af09374469c3a39eeea1a146e8cac27daec951f1f1f157b1962fc7cb9d1b7"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/fa/2d/906afc44a833901fc6fed1a89c228e5c88fbfc6bd2f3d2f0497fdfb9c525/docker-py-1.10.6.tar.gz"
    sha256 "4c2a75875764d38d67f87bc7d03f7443a3895704efc57962bdf6500b8d4bc415"
  end

  resource "docker-pycreds" do
    url "https://files.pythonhosted.org/packages/c5/e6/d1f6c00b7221e2d7c4b470132c931325c8b22c51ca62417e300f5ce16009/docker-pycreds-0.4.0.tar.gz"
    sha256 "6ce3270bcaf404cc4c3e27e4b6c70d3521deae82fb508767870fdbf772d584d4"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/93/22/953e071b589b0b1fee420ab06a0d15e5aa0c7470eb9966d60393ce58ad61/docutils-0.15.2.tar.gz"
    sha256 "a2aeea129088da402665e92e0b25b04b073c04b2dce4ab65caaa38b7ce2e1a99"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/8a/d7/89c3115c0420cdea892fe4ed004ee94a9af130f3dcf60d8f55f6b3521a1a/dogpile.cache-1.0.1.tar.gz"
    sha256 "695dd61f32d97233d5c5e1d7ac1238f5116391ea990b4b24a239229e280bf36e"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/bd/fe/163ecab1eb07dd208a923e0d9bc36c26ac72fc8a4c0b182a193f83ba3679/google-auth-1.19.2.tar.gz"
    sha256 "f404448f3d3c91944b1d907427d4a0c48f465898e9dbacf1bdebf95c5fe03273"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/b9/9a/3e9da40ea28b8210dd6504d3fe9fe7e013b62bf45902b458d1cdc3c34ed9/ipaddress-1.0.23.tar.gz"
    sha256 "b7f8e0369580bb4a24d5ba1d7cc29660a4a6987763faf1d8a8046830e020e7e2"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz"
    sha256 "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/69/72/24826f61fe4ba535207ed8efe17c82a5e9f9fdf2247054ae829b5c134b71/jsonpatch-1.26.tar.gz"
    sha256 "e45df18b0ab7df1925f20671bbc3f6bd0b4b556fb4b9c5d97684b0a7eac01744"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/52/e7/246d9ef2366d430f0ce7bdc494ea2df8b49d7a2a41ba51f5655f68cfe85f/jsonpointer-2.0.tar.gz"
    sha256 "c192ba86648e05fdae4f08a17ec25180a9aef5008d973407b581798a83975362"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/10/e7/ccfa9b66eca51ec361a87b1a31a7a88d7b445b8c5cc0d0ee10d4990cb968/junos-eznc-2.5.0.tar.gz"
    sha256 "78bd915bd7c39fa7b232f20d0ae5329f554b2bef2b6eb1f18d103ec1c19468f0"
  end

  resource "jxmlease" do
    url "https://files.pythonhosted.org/packages/8d/6a/b2944628e019c753894552c1499bf60e2cef9efea138756c5d66f0d5eb98/jxmlease-1.0.3.tar.gz"
    sha256 "612c1575d8a87026dea096bb75acec7302dd69040fa23d9116e71e30d5e0839e"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/34/18/9c86fdfdb27e0f7437b7d5a9e22975dcc382637b2a68baac07843be512fc/kerberos-1.3.0.tar.gz"
    sha256 "f039b7dd4746df56f6102097b3dc250fe0078be75130b9dc4211a85a3b1ec6a4"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/60/0c/0d8ed208821c40a4c55c1d206658c4c7cd69d3d041a3202feef5c0eca902/keystoneauth1-4.2.0.tar.gz"
    sha256 "000ffd0d752f13eb235dae06f5f5dea16a2ca1f737fe3339632bd696b12489f7"
  end

  resource "kubernetes" do
    url "https://files.pythonhosted.org/packages/60/3f/2fef94fb65e8f94d768356e5fb9be222d18027e6167ccc65e2090917a771/kubernetes-11.0.0.tar.gz"
    sha256 "1a2472f8b01bc6aa87e3a34781f859bded5a5c8ff791a53d889a8bd6cc550430"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2c/4d/3ec1ea8512a7fbf57f02dee3035e2cce2d63d0e9c0ab8e4e376e01452597/lxml-4.5.2.tar.gz"
    sha256 "cdc13a1682b2a6241080745b1953719e7fe0850b40a5c71ca574f090a1391df6"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/19/c1/27f722aaaaf98786a1b338b78cf60960d9fe4849825b071f4e300da29589/monotonic-1.5.tar.gz"
    sha256 "23953d55076df038541e648a53676fb24980f7a1be290cdda21300b3bc21dfb0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/e4/4f/057549afbd12fdd5d9aae9df19a6773a3d91988afe7be45b277e8cee2f4d/msgpack-1.0.0.tar.gz"
    sha256 "9534d5cc480d4aff720233411a1f765be90885750b07df772380b34c10ecb5c0"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/43/a1/ec48010724eedfe2add68eb7592a0d238590e14e08b95a4ffb3c7b2f0808/munch-2.5.0.tar.gz"
    sha256 "2d735f6f24d4dba3417fa448cae40c6e896ec1fdab6cdb5e6510999758a4dbd2"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/dd/7f/700ffea36c4c1c72d7581ef3dc3f40ec9756fd161816cd258cd303cd9f39/ncclient-0.6.7.tar.gz"
    sha256 "efdf3c868cd9f104d4e9fe4c233df78bfbbed4b3d78ba19dc27cec3cf6a63680"
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
    url "https://files.pythonhosted.org/packages/60/d9/7909bc125c6291b7bf7f5d552b284b200ad5ecc2330432ed82f3aeaed64f/ntc_templates-1.5.0.tar.gz"
    sha256 "ec4bb9e23d2e8c724613c699cd9a7413c22d02ff73a47868b970e24904f9d483"
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
    url "https://files.pythonhosted.org/packages/2a/f2/978b34965425fa737464082ad96d46646ada88fb94f6f84ee2f8581df305/openshift-0.11.2.tar.gz"
    sha256 "110b0d3c84a83500f0fd150ab26dee29615157e6659bf72808788aa79fc17afc"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/66/3e/f108d20a306763a4826630f0b79c1037b8c46a65eb5b789f9220dea1b1be/openstacksdk-0.48.0.tar.gz"
    sha256 "8652664a30041325a980d03a37c92ca546ed923d26c246a2bb3c92fc5f24243c"
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
    url "https://files.pythonhosted.org/packages/ad/71/ee714a1bc985f6153cf91941c1de9c7664d8d9527706344051e9f416f1e9/osc-lib-2.2.0.tar.gz"
    sha256 "fcfce4d63a633c3161e2a6666764446e3f32668e814a94ab98da12e3908ee1d6"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/a4/5d/bbbb01a4e080997939de2b3c1ce7e99fab9997c898e3d451fc4402c8be12/oslo.config-8.3.0.tar.gz"
    sha256 "74e93053559c16cbce894c4897065f6d4199fcab7c6153fc8586499c7d7750b7"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/10/bd/63ec243afb7724dc48425c11295d061062738591acaf35eaa987b0f4a773/oslo.context-3.1.0.tar.gz"
    sha256 "2546ccef19ad7b62b0d3a57ab7cce714b1dfb0b39c4563f9b655c4f9fe128e54"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/fe/40/8cbad079b6930ce7958af9187c208789bb77b90815eea6b01af169ea8f86/oslo.i18n-5.0.0.tar.gz"
    sha256 "2e71ae3ec73a74ac71f8f407e6653243dc267eed404624255a296c34f1fc6887"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/a5/4f/53aabb1f8e3782bceb8f7e78d184706c2ac08051d90966e768f11c0f79c1/oslo.log-4.3.0.tar.gz"
    sha256 "a1b21317bf01e894c80836c01bea526d58138ad97b70f304df3d360c76a87bbb"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/0f/42/3625893aee1450957caf49514810e13514c1b00b0cfbe2a08194bf392aa5/oslo.serialization-4.0.0.tar.gz"
    sha256 "f465df171be564282cb3e86ec895f5b6ae5e5b0760e9af2be96a942a5255a860"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/ea/c7/20cb0c1947b7e32313cc6e2de3addc3c33923a3314787bcbf215f83390b8/oslo.utils-4.3.0.tar.gz"
    sha256 "c608d9676974ae7e81ce51eeecd122690881c3bdc31b26f51c42327a350bd313"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/55/fd/fc1aca9cf51ed2f2c11748fa797370027babd82f87829c7a8e6dbe720145/packaging-20.4.tar.gz"
    sha256 "4357f74f47b9c12db93624a82154e9b120fa8293699949152b22065d556079f8"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/ac/15/4351003352e11300b9f44a13576bff52dcdc6e4a911129c07447bda0a358/paramiko-2.7.1.tar.gz"
    sha256 "920492895db8013f6cc0179293147f830b8c7b21fdfc839b6bad760c27459d9f"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/6d/6b/4bfca0c13506535289b58f9c9761d20f56ed89439bfe6b8e07416ce58ee1/passlib-1.7.2.tar.gz"
    sha256 "8d666cef936198bc2ab47ee9b0410c94adf2ba798e5a84bf220be079ae7ab6a8"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/7d/2d/e4b8733cf79b7309d84c9081a4ab558c89d8c89da5961bf4ddb050ca1ce0/ptyprocess-0.6.0.tar.gz"
    sha256 "923f299cc5ad920c68f2bc0bc98b75b9f838b93b599941a6b63ddbc2476394c0"
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

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"

    # Fix warnings "SyntaxWarning: "is" with a literal. Did you mean "=="?" for python 3.8
    patch do
      url "https://github.com/dlitz/pycrypto/commit/4e4cc0beefbb316db2a8750e747e697df0b754d7.patch?full_index=1"
      sha256 "f82fedee6cf73c868b55af3ab2b7d2d029b84960be0dc3baf85bb4bf541e1451"
    end
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/f6/5b/55866e1cde0f86f5eec59dab5de8a66628cb0d53da74b8dbc15ad8dabda3/pyperclip-1.8.0.tar.gz"
    sha256 "b75b975160428d84608c26edba2dec146e7799566aea42c1fe1b32e72b6028f2"
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
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/3e/36/425bb8232f7ed1d6fab04d480fbec532eb41963c93839b0f9deeaf20ab7d/python-keystoneclient-4.1.0.tar.gz"
    sha256 "7b9b99021358a4db20673d338ba42bc2bd8e7e969cfd777f68c600ae6a39cb1b"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/9c/f0/2b9b1642dad5f175eabbd8bf1681aa250dc795bd3f34d363a6f71f8e9ac3/python-neutronclient-7.2.0.tar.gz"
    sha256 "8beb4a60a0db6e9f3806659091b1e228287bbf3904b7dfce038d1c1b63f91a85"
  end

  resource "python-string-utils" do
    url "https://files.pythonhosted.org/packages/10/91/8c883b83c7d039ca7e6c8f8a7e154a27fdeddd98d14c10c5ee8fe425b6c0/python-string-utils-1.0.0.tar.gz"
    sha256 "dcf9060b03f07647c0a603408dc8b03f807f3b54a05c6e19eb14460256fac0cb"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/fc/88/be0ea1af44c3bcc54e4c41e4056986743551693c77dfe50b48a3f4ba1bf7/pywinrm-0.4.1.tar.gz"
    sha256 "4ede5c6c85b53780ad0dbf9abef2fa2ea58f44c82256a84a63eae5f1205cea81"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/da/67/672b422d9daf07365259958912ba533a0ecab839d4084c487a5fe9a5405f/requests-2.24.0.tar.gz"
    sha256 "b3559a131db72c33ee969480840fff4bb6dd111de7dd27c8ee1f820f4f00231b"
  end

  resource "requests-credssp" do
    url "https://files.pythonhosted.org/packages/d3/19/3f8cd9319717d66a0147185bd750fe25f7d85cb669f0316a44f26e071eab/requests-credssp-1.1.1.tar.gz"
    sha256 "39910218561df398adca166e2f145ba6cb4a21450009cad96d1afb1c7e1741c3"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/23/eb/68fc8fa86e0f5789832f275c8289257d8dc44dbe93fce7ff819112b9df8f/requests-oauthlib-1.3.0.tar.gz"
    sha256 "b4261601a71fd721a8bd6d7aa1cc1d6a8a93b4a9f5e96626f8e4d91e8beeaa6a"
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
    url "https://files.pythonhosted.org/packages/70/e2/1344681ad04a0971e8884b9a9856e5a13cc4824d15c047f8b0bbcc0b2029/rfc3986-1.4.0.tar.gz"
    sha256 "112398da31a3344dc25dbf477d8df6cb34f9278a94fee2625d89e4514be8bb9d"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/a2/d5/04b8a9719149583fec76efdff2e7a81c6e3cc34909ee818d3fbf115edc2e/rsa-4.6.tar.gz"
    sha256 "109ea5a66744dd859bf16fe904b8d8b627adafb9408753161e766a92e7d681fa"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/16/8b/54a26c1031595e5edd0e616028b922d78d8ffba8bc775f0a4faeada846cc/ruamel.yaml-0.16.10.tar.gz"
    sha256 "099c644a778bf72ffa00524f78dd0b6476bca94a1da344130f4bf3381ce5b954"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/92/28/612085de3fae9f82d62d80255d9f4cf05b1b341db1e180adcf28c1bf748d/ruamel.yaml.clib-0.2.0.tar.gz"
    sha256 "b66832ea8077d9b3f6e311c4a53d06273db5dc2db6e8a908550f3c14d67e718c"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/50/de/2b688c062107942486c81a739383b1432a72717d9a85a6a1a692f003c70c/s3transfer-0.3.3.tar.gz"
    sha256 "921a37e2aefc64145e7b73d50c71bb4f26f46e4c9f414dc648c6245ff92cf7db"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/05/e0/ac4169e773e12a08d941ca3c006cb8c91bee9d6d80328a15af850b5e7480/scp-0.13.2.tar.gz"
    sha256 "ef9d6e67c0331485d3db146bf9ee9baff8a48f3eb0e6c08276a8584b13bf34b3"
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
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/bc/3e/0f33515b3b1638e839219f14c09b9b75f86f630c47ad9e79137f73e99a97/stevedore-3.2.0.tar.gz"
    sha256 "38791aa5bed922b0a844513c5f9ed37774b68edc609e5ab8ab8d8fe0ce4315e5"
  end

  resource "subprocess32" do
    url "https://files.pythonhosted.org/packages/32/c8/564be4d12629b912ea431f1a50eb8b3b9d00f1a0b1ceff17f266be190007/subprocess32-3.5.4.tar.gz"
    sha256 "eb2937c80497978d181efa1b839ec2d9622cf9600a039a79d0e108d1f9aec79d"
  end

  resource "textfsm" do
    url "https://github.com/google/textfsm/archive/v1.1.0.tar.gz"
    sha256 "b750de2986ef78696e686b510a96aa23206a575580daf2b1eb7e17525ed33045"
  end

  resource "transitions" do
    url "https://files.pythonhosted.org/packages/7a/d2/7ebb533f9c5ff5a5245ced529bc8ac7df69d16cc1f85da10751fff891b8e/transitions-0.8.2.tar.gz"
    sha256 "6ff7a3bfa4ac64b62993bb19dc2bb6a0ccbdf4e70b2cbae8350de6c916d77748"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/81/f4/87467aeb3afc4a6056e1fe86626d259ab97e1213b1dfec14c7cb5f538bf0/urllib3-1.25.10.tar.gz"
    sha256 "91056c15fa70756691db97756772bb1eb9678fa585d9184f24534b100dc60f4a"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "websocket_client" do
    url "https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c/websocket_client-0.57.0.tar.gz"
    sha256 "d735b91d6d1692a6a181f2a8c9e0238e5f6373356f561bb9dc4c7af36f452010"
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

  def install
    ENV.prepend_path "PATH", Formula["python@3.8"].opt_libexec/"bin"

    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version <= :sierra

    # Work around Xcode 11 clang bug
    # https://code.videolan.org/videolan/libbluray/issues/20
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
