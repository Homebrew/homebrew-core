class AnsibleAT20 < Formula
  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.0.2.0.tar.gz"
  sha256 "373a2e50319d90da50948e3faf1c033464b7302200e0199da8981d24646d4387"
  revision 3

  bottle do
    cellar :any
    sha256 "1dbd189832d8349598f132536ad1ce6436912ba27fba6c497d2ecfabeb2cb260" => :mojave
    sha256 "e24d7bfe5d4794f8363abb47301a8d2067179f6c809ca1697bba0af777895a56" => :high_sierra
    sha256 "5079825fdc43fd2e573d8b74e4f0e9bb3b27ecbdacb44d57db3a25f70adadcf3" => :sierra
  end

  keg_only :versioned_formula

  depends_on "pkg-config" => :build
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "python@2" # does not support Python 3

  #
  # ansible (core dependencies)
  #
  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/source/s/setuptools/setuptools-20.8.1.tar.gz"
    sha256 "f49be4963e2d985bf12768f46cbfe4b016787f2c0ed1f8f62c3d2bc0362586da"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/source/p/paramiko/paramiko-1.16.0.tar.gz"
    sha256 "3297ebd3cd072f573772f7c7426939a443c62c458d54bb632ff30fd6ecf96892"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/source/p/pycrypto/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  #
  # Required by the 'paramiko' core module
  # https://github.com/paramiko/paramiko)
  #
  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/source/e/ecdsa/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  #
  # Required by the 'uri' core module
  # See https://docs.ansible.com/uri_module.html#requirements)
  #
  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/source/h/httplib2/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  #
  # Resources required by docker-py, pyrax, and shade (see below).
  # Install requests with [security]
  #
  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/e7/a7/4cd50e57cc6f436f1cc3a7e8fa700ff9b8b4d471620629074913e3735fb2/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/b2/faa78c1ab928d2b2c634c8b41ff1181f0abdd9adf9193211bd606ffa57e2/cryptography-2.2.2.tar.gz"
    sha256 "9fc295bf69130a342e7a19a39d7bbeb15c0bcaabc7382ec33ef3b2b7d18d2f63"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/97/8d/77b8cedcfbf93676148518036c6b1ce7f8e14bf07e95d7fd4ddcb8cc052f/ipaddress-1.0.22.tar.gz"
    sha256 "b146c751ea45cad6188dd6cf2d9b757f6f4f8d6ffb96a023e6f2e26eea02a72c"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/source/n/ndg-httpsclient/ndg_httpsclient-0.4.0.tar.gz"
    sha256 "e8c155fdebd9c4bcb0810b4ed01ae1987554b1ee034dd7532d7b8fdae38a6274"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/source/p/pyasn1/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/source/r/requests/requests-2.9.1.tar.gz"
    sha256 "c577815dd00f1394203fc44eb979724b098f88264a9ef898ee45b8e5e9cf587f"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/source/r/requestsexceptions/requestsexceptions-1.1.1.tar.gz"
    sha256 "21853958a2245d6dc1c851cf31ccc24ab5142efa67d73cca4b7678f604bbaf52"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/16/d8/bc6316cf98419719bd59c91742194c111b6f2e85abac88e496adefaf7afe/six-1.11.0.tar.gz"
    sha256 "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9"
  end

  #
  # docker-py (for Docker support)
  #
  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/source/b/backports.ssl_match_hostname/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/source/d/docker-py/docker-py-1.8.0.tar.gz"
    sha256 "09ccd3522d86ec95c0659887d1da7b2761529020694efb0eeac87074cb4536c2"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/source/w/websocket-client/websocket_client-0.37.0.tar.gz"
    sha256 "678b246d816b94018af5297e72915160e2feb042e0cde1a9397f502ac3a52f41"
  end

  #
  # pywinrm (for Windows support)
  #
  resource "isodate" do
    url "https://files.pythonhosted.org/packages/source/i/isodate/isodate-0.5.4.tar.gz"
    sha256 "42105c41d037246dc1987e36d96f3752ffd5c0c24834dd12e4fdbe1e79544e31"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/source/p/pywinrm/pywinrm-0.1.1.tar.gz"
    sha256 "0230d7e574a5375e8a0b46001a2bce2440aba2b866629342be0360859f8d514d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/source/x/xmltodict/xmltodict-0.9.2.tar.gz"
    sha256 "275d1e68c95cd7e3ee703ddc3ea7278e8281f761680d6bdd637bcd00a5c59901"
  end

  #
  # kerberos (for Windows support)
  #
  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/source/k/kerberos/kerberos-1.2.2.tar.gz"
    sha256 "070ff6d9baf3752323283b1c8ed75e2edd0ec55337359185abf5bb0b617d2f5d"
  end

  #
  # boto/boto3 (for AWS support)
  #
  resource "boto" do
    url "https://files.pythonhosted.org/packages/source/b/boto/boto-2.39.0.tar.gz"
    sha256 "950c5bf36691df916b94ebc5679fed07f642030d39132454ec178800d5b6c58a"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/source/b/boto3/boto3-1.3.0.tar.gz"
    sha256 "8f85b9261a5b4606d883248a59ef1a4e82fd783602dbec8deac4d2ad36a1b6f4"
  end

  #
  # Required by the 'boto3' module
  # https://github.com/boto/boto3
  #
  resource "botocore" do
    url "https://files.pythonhosted.org/packages/source/b/botocore/botocore-1.4.11.tar.gz"
    sha256 "96295db1444e9a458a3018205187ec424213e0a69c937062347f88b7b7e078fb"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/source/j/jmespath/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/source/p/python-dateutil/python-dateutil-2.5.2.tar.gz"
    sha256 "063907ef47f6e187b8fe0728952e4effb587a34f2dc356888646f9b71fbb2e4b"
  end

  #
  # apache libcloud (for Google GCE cupport)
  #
  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/source/a/apache-libcloud/apache-libcloud-0.20.1.tar.gz"
    sha256 "f36dcf8e6a4270c86b521ab4868fd762a7ec217195e126a8ccb028a82cf55466"
  end

  #
  # pyrax (for Rackspace support)
  #
  resource "Babel" do
    url "https://files.pythonhosted.org/packages/source/B/Babel/Babel-2.3.3.tar.gz"
    sha256 "12dff9afa9c6cd6e2a39960d3cd4b46b2b98768cdc6646833c66b20799c1c58e"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/source/d/debtcollector/debtcollector-1.3.0.tar.gz"
    sha256 "9a65cf09239eab75b961ef609b3176ed2487bedcfa0a465331661824e1c8db8f"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/source/d/dnspython/dnspython-1.12.0.zip"
    sha256 "63bd1fae61809eedb91f84b2185816fac1270ae51494fbdd36ea25f904a8502f"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/source/f/funcsigs/funcsigs-1.0.0.tar.gz"
    sha256 "2310f9d4a77c284e920ec572dc2525366a107b08d216ff8dbb891d95b6a77563"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/source/i/ip_associations_python_novaclient_ext/ip_associations_python_novaclient_ext-0.1.tar.gz"
    sha256 "a709b8804364afbbab81470b57e8df3f3ea11dff843c6cb4590bbc130cea94f7"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/source/i/iso8601/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/source/k/keyring/keyring-9.0.tar.gz"
    sha256 "1c1222298da2100128f821c57096c69cb6cec0d22ba3b66c2859ae95ae473799"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/source/k/keystoneauth1/keystoneauth1-2.6.0.tar.gz"
    sha256 "b89a5eab3bb4bd6b36dc0c34903dbc37f531fbef4c74722cc62bffd730d1d854"
  end

  resource "mock" do
    # NOTE: mock versions above 1.0.1 fail to install due to a broken setuptools version check.
    url "https://files.pythonhosted.org/packages/source/m/mock/mock-1.0.1.tar.gz"
    sha256 "b839dd2d9c117c701430c149956918a423a9863b48b09c90e30a6013e7d2f44f"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/source/m/monotonic/monotonic-1.0.tar.gz"
    sha256 "47d7d045b3f2a08bffe683d761ef7f9131a2598db1cec7532a06720656cf719d"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/source/m/msgpack-python/msgpack-python-0.4.7.tar.gz"
    sha256 "5e001229a54180a02dcdd59db23c9978351af55b1290c27bc549e381f43acd6b"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/source/n/netaddr/netaddr-0.7.18.tar.gz"
    sha256 "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/source/n/netifaces/netifaces-0.10.4.tar.gz"
    sha256 "9656a169cb83da34d732b0eb72b39373d48774aee009a3d1272b7ea2ce109cde"
  end

  resource "os_diskconfig_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/source/o/os_diskconfig_python_novaclient_ext/os_diskconfig_python_novaclient_ext-0.1.3.tar.gz"
    sha256 "e7d19233a7b73c70244d2527d162d8176555698e7c621b41f689be496df15e75"
  end

  resource "os_networksv2_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/source/o/os_networksv2_python_novaclient_ext/os_networksv2_python_novaclient_ext-0.25.tar.gz"
    sha256 "35ba71b027daf4c407d7a2fd94604d0437eea0c1de4d8d5d0f8ab69100834a0f"
  end

  resource "os_virtual_interfacesv2_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/source/o/os_virtual_interfacesv2_python_novaclient_ext/os_virtual_interfacesv2_python_novaclient_ext-0.19.tar.gz"
    sha256 "5171370e5cea447019cee5da22102b7eca4d4a7fb3f12875e2d7658d98462c0a"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/source/o/oslo.config/oslo.config-3.9.0.tar.gz"
    sha256 "ec7bdf4a3d85f90cf07d2fa03a20783558ad0f490d71bd8faf50bf4ee2923df1"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/source/o/oslo.i18n/oslo.i18n-3.5.0.tar.gz"
    sha256 "5fff5f6ceabed9d09b18d83e049864c29eff038efbbe67e03fe68c49cc189f10"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/source/o/oslo.serialization/oslo.serialization-2.4.0.tar.gz"
    sha256 "9b95fc07310fd6df8cab064f89fd15327b259dec17a2e2b9a07b9ca4d96be0c6"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/source/o/oslo.utils/oslo.utils-3.8.0.tar.gz"
    sha256 "c0e935b86e72facc02264271ed09dd9c5879d52452d7a1b4a116a6c7d05077aa"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/source/p/pytz/pytz-2016.3.tar.bz2"
    sha256 "c193dfa167ac32c8cb96f26cbcd92972591b22bda0bac3effdbdb04de6cc55d6"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/source/p/pbr/pbr-1.9.1.tar.gz"
    sha256 "3997406c90894ebf3d1371811c1e099721440a901f946ca6dc4383350403ed51"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/source/p/positional/positional-1.0.1.tar.gz"
    sha256 "54a73f3593c6e30e9cdd0a727503b7c5dddbb75fb78bb681614b08dfde2bc444"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/source/P/PrettyTable/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/source/p/pyrax/pyrax-1.9.7.tar.gz"
    sha256 "6f2e2bbe9d34541db66f5815ee2016a1366a78a5bf518810d4bd81b71a9bc477"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-keystoneclient/python-keystoneclient-2.3.1.tar.gz"
    sha256 "89e93551071cf29780eeafe7a61114cd36b1c2192813d3c2a58a348a6a3ac6ff"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-novaclient/python-novaclient-2.27.0.tar.gz"
    sha256 "d1279d5c2857cf8c56cb953639b36225bc1fec7fa30ee632940823506a7638ef"
  end

  resource "rackspace-auth-openstack" do
    url "https://files.pythonhosted.org/packages/source/r/rackspace-auth-openstack/rackspace-auth-openstack-1.3.tar.gz"
    sha256 "c4c069eeb1924ea492c50144d8a4f5f1eb0ece945e0c0d60157cabcadff651cd"
  end

  resource "rackspace-novaclient" do
    url "https://files.pythonhosted.org/packages/source/r/rackspace-novaclient/rackspace-novaclient-1.5.tar.gz"
    sha256 "0fcde7e22594d9710c65e850d11898bd342fa83849dc8ef32c2a94117f7132b1"
  end

  resource "rax_default_network_flags_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/source/r/rax_default_network_flags_python_novaclient_ext/rax_default_network_flags_python_novaclient_ext-0.3.2.tar.gz"
    sha256 "bf18d534f6ab1ca1c82680a71d631babee285257c7d99321413a19d773790915"
  end

  resource "rax_scheduled_images_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/source/r/rax_scheduled_images_python_novaclient_ext/rax_scheduled_images_python_novaclient_ext-0.3.1.tar.gz"
    sha256 "f170cf97b20bdc8a1784cc0b85b70df5eb9b88c3230dab8e68e1863bf3937cdb"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/source/s/simplejson/simplejson-3.8.2.tar.gz"
    sha256 "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/source/s/stevedore/stevedore-1.10.0.tar.gz"
    sha256 "f5d689ef38e0ca532d57a03d1ab95e89b17c57f97b58d10c92da94699973779f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/source/w/wrapt/wrapt-1.10.6.tar.gz"
    sha256 "9576869bb74a43cbb36ee39dc3584e6830b8e5c788e83edf0a397eba807734ab"
  end

  #
  # python-keyczar (for Accelerated Mode support)
  #
  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/source/p/python-keyczar/python-keyczar-0.715.tar.gz"
    sha256 "f43f9f15b0b719de94cab2754dcf78ef63b40ee2a12cea296e7af788b28501bb"
  end

  # also required by the htpasswd core module
  resource "passlib" do
    url "https://files.pythonhosted.org/packages/source/p/passlib/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  #
  # shade (for OpenStack support)
  #
  resource "anyjson" do
    url "https://files.pythonhosted.org/packages/source/a/anyjson/anyjson-0.3.3.tar.gz"
    sha256 "37812d863c9ad3e35c0734c42e0bf0320ce8c3bed82cd20ad54cb34d158157ba"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/source/a/appdirs/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/source/c/cliff/cliff-1.15.0.tar.gz"
    sha256 "f5ba6fe0940547549947d5a24ca3354145a603d3a9ba054f209d20b66dc02be7"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/source/c/cmd2/cmd2-0.6.8.tar.gz"
    sha256 "ac780d8c31fc107bf6b4edcbcea711de4ff776d59d89bb167f8819d2d83764a8"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/source/d/decorator/decorator-4.0.6.tar.gz"
    sha256 "1c6254597777fd003da2e8fb503c3dbf3d9e8f8d55f054709c0e65be3467209c"
  end

  resource "dogpile" do
    url "https://files.pythonhosted.org/packages/source/d/dogpile/dogpile-0.2.2.tar.gz"
    sha256 "bce7e7145054af20d4bef01c7b2fb4266fa88dca107ed246c395558a824e9bf0"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/source/d/dogpile.cache/dogpile.cache-0.5.7.tar.gz"
    sha256 "dcf99b09ddf3d8216b1b4378100eb0235619612fb0e6300ba5d74f10962d0956"
  end

  resource "dogpile.core" do
    url "https://files.pythonhosted.org/packages/source/d/dogpile.core/dogpile.core-0.4.1.tar.gz"
    sha256 "be652fb11a8eaf66f7e5c94d418d2eaa60a2fe81dae500f3743a863cc9dbed76"
  end

  resource "functools32" do
    url "https://files.pythonhosted.org/packages/source/f/functools32/functools32-3.2.3-2.tar.gz"
    sha256 "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/source/f/futures/futures-3.0.4.tar.gz"
    sha256 "19485d83f7bd2151c0aeaf88fbba3ee50dadfb222ffc3b66a344ef4952b782a3"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/source/j/jsonpatch/jsonpatch-1.12.tar.gz"
    sha256 "2e1eb457f9c8dd5dae837ca93c0fe5bd2522c9d44b9b380fb1aab2ab4dec04b1"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/source/j/jsonpointer/jsonpointer-1.10.tar.gz"
    sha256 "9fa5dcac35eefd53e25d6cd4c310d963c9f0b897641772cd6e5e7b89df7ee0b1"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/source/j/jsonschema/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/source/l/lxml/lxml-3.4.4.tar.gz"
    sha256 "b3d362bac471172747cda3513238f115cbd6c5f8b8e6319bf6a97a7892724099"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/source/m/munch/munch-2.0.4.tar.gz"
    sha256 "1420683a94f3a2ffc77935ddd28aa9ccb540dd02b75e02ed7ea863db437ab8b2"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/source/o/os-client-config/os-client-config-1.14.0.tar.gz"
    sha256 "d12e92d461abbba9f87d722a28927ba4241d29abbaea520f2a44146b9eeec118"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/source/p/pyOpenSSL/pyOpenSSL-0.15.1.tar.gz"
    sha256 "f0a26070d6db0881de8bcc7846934b7c3c930d8f9c79d45883ee48984bc0d672"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-cinderclient/python-cinderclient-1.5.0.tar.gz"
    sha256 "4c4f5f4500afa2d3b6de183a0da573b6a04d18c92d01cc27dd29d0b5ec815d60"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-designateclient/python-designateclient-1.5.0.tar.gz"
    sha256 "bbd93cca7eb966a270b5c49247b12fb2bf8fbb80a8577574d5c1bc8812de9cf2"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-glanceclient/python-glanceclient-1.1.0.tar.gz"
    sha256 "59ff30927468215131a68ffbfb9b2cb15d636a17cf702d87d0370957b553f25e"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-heatclient/python-heatclient-0.9.0.tar.gz"
    sha256 "3a393de49239c3e6a82e2ce819684f262cb6f48ec70542d1d3dfb7aa690c7574"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-ironicclient/python-ironicclient-1.1.0.tar.gz"
    sha256 "4c83c4799f4a52f3ad1167ae66214265ec4bba3eab4b9518b0ff003662f40f4a"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-neutronclient/python-neutronclient-4.0.0.tar.gz"
    sha256 "13f4255b698bfcb19acbc8b2550ea10fd41f64e39b7951f0f2af8bec4f077191"
  end

  resource "python-openstackclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-openstackclient/python-openstackclient-2.0.0.tar.gz"
    sha256 "f89d838966fd3a6fbdc635f82ba91d5318292cef851a084e8fa01fcbf4bef62f"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-swiftclient/python-swiftclient-2.7.0.tar.gz"
    sha256 "013f3d8296f5b4342341e086e95c4a1fc85a24caa22a9bcc7de6716b20de2a55"
  end

  resource "python-troveclient" do
    url "https://files.pythonhosted.org/packages/source/p/python-troveclient/python-troveclient-2.0.0.tar.gz"
    sha256 "43e7116c23f0e533560df5cbc3dbfb5e6db6ea779f7f32e31ba4ff8c038145f5"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/source/s/shade/shade-1.4.0.tar.gz"
    sha256 "ad94109d9f1379104cfeee9f7de0b16741b50f1d9c99fa662717861ca8ed1981"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/source/u/unicodecsv/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/source/w/warlock/warlock-1.2.0.tar.gz"
    sha256 "7c0d17891e14cf77e13a598edecc9f4682a5bc8a219dc84c139c5ba02789ef5a"
  end

  def install
    vendor_site_packages = libexec/"vendor/lib/python2.7/site-packages"
    ENV.prepend_create_path "PYTHONPATH", vendor_site_packages

    # Fix "ld: file not found: /usr/lib/system/libsystem_darwin.dylib" for lxml
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    # ndg is a namespace package
    touch vendor_site_packages/"ndg/__init__.py"

    inreplace "lib/ansible/constants.py" do |s|
      s.gsub! "/usr/share/ansible", pkgshare
      s.gsub! "/etc/ansible", etc/"ansible"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    man1.install Dir["docs/man/man1/*.1"]
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  def caveats; <<~EOS
    Homebrew writes wrapper scripts that set PYTHONPATH in ansible's
    execution environment, which is inherited by Python scripts invoked
    by ansible. If this causes problems, you can modify your playbooks
    to invoke python with -E, which causes python to ignore PYTHONPATH.
  EOS
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
  end
end
