class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.1.2.0.tar.gz"
  sha256 "9c37a7bd397c05ab8ca3fcc49417649ea49b9133d4cd9500408235617d1621eb"

  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "63eb3d4e55c41ae1f423eb46b112c202da7daddddafbbf26e8c1c02c98863945" => :sierra
    sha256 "a06717ed2638898280aca8a64d60192d30ad9c1f0e72bfc9e59ea146b6299971" => :el_capitan
    sha256 "4417449bb1846bc1f3c73c82c9a11dd4cd8b51edf9319455be40890063346798" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"
  depends_on "openssl"

  # Collect requirements from:
  #   ansible
  #   httplib2 (`uri` core module)
  #   docker-py
  #   pyrax (Rackspace)
  #   shade (OpenStack)
  #   pywinrm (Windows)
  #   kerberos (Windows)
  #   xmltodict (Windows)
  #   boto (AWS)
  #   boto3 (AWS)
  #   apache-libcloud (Google GCE)
  #   python-keyczar (Accelerated Mode)
  #   passlib (htpasswd core module)
  #   zabbix-api (Zabbix extras module)

  ### setup_requires dependencies
  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f7/c7/08e54702c74baf9d8f92d0bc331ecabf6d66a56f6d36370f0a672fc6a535/pytz-2016.6.1.tar.bz2"
    sha256 "b5aff44126cf828537581e534cc94299b223b945a2bb3b5434d37bf8c7f3a10c"
  end
  ### end

  ### extras for requests[security]
  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/15/1e/79c75db50e57350a7cefb70b110255757e9abd380a50ebdc0cfd853b7450/pyOpenSSL-16.1.0.tar.gz"
    sha256 "88f7ada2a71daf2c78a4f139b19d57551b4c8be01f53a1cb5c86c2f3bf01355f"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end
  ### end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/f2/2f/0b98b06a345a761bec91a079ccae392d282690c2d8272e708f4d10829e22/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/c0/41/bae1254e0396c0cc8cf1751cb7d9afc90a602353695af5952530482c963f/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/d8/6c/66246989d4f8ca6d49359d7cc173f969c2d3e1895bb8d54cb179a05736c0/apache-libcloud-1.1.0.tar.bz2"
    sha256 "94c7012bc5e821f4c89181a62d51d824ce9c5c54045f4ab4f073e5796fd1d895"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/bd/66/0a7f48a0f3fb1d3a4072bceb5bbd78b1a6de4d801fb7135578e7c7b1f563/appdirs-1.4.0.tar.gz"
    sha256 "8fc245efb4387a4e3e0ac8ebcc704582df7d72ff6a42a53f5600bbb18fdaadc5"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/c4/bb/28324652bedb4ea9ca77253b84567d1347b54df6231b51822eaaa296e6e0/boto-2.42.0.tar.gz"
    sha256 "dcf140d4ce535bb8f5266d1750c16def4d50f6c46eff27fab38b55d0d74d5ac7"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/37/1a/e271b2937c05c1da265415103725e0610fb96871a2d7ddf68b999ac5db8f/boto3-1.4.0.tar.gz"
    sha256 "c365144fb98d022ad6f6cdeb1abf8a4849f1a135e3c4ef78ef5053982ed914b3"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/54/4c/b217d400ff096970242fddc67086bb72ffd3c40a7486d4ac9200538ea51d/botocore-1.4.51.tar.gz"
    sha256 "e6216bf77f23c49eaae9fff4ad3903af2fbff0de92d2d730d8ca83447be33ad9"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/83/3c/00b553fd05ae32f27b3637f705c413c4ce71290aa9b4c4764df694e906d9/cffi-1.7.0.tar.gz"
    sha256 "6ed5dd6afd8361f34819c68aaebf9e8fc12b5a5893f91f50c9e50c8886bb60df"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/24/ce/2b525c023acda085cff13a218df95583e323c49c25dfef1acebacb527972/cliff-2.2.0.tar.gz"
    sha256 "a12a6bd3cf9085f0e0589c5019037ac4ee410413abbb76189fa62695f79f84fc"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/20/65/6e5518c6bbfe9fe33be1364a6e83d372f837019dfdb31b207b2db3d84865/cmd2-0.6.8.tar.gz"
    sha256 "ac780d8c31fc107bf6b4edcbcea711de4ff776d59d89bb167f8819d2d83764a8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6e/96/b8dab146e8be98061dae07e127f80cffa3061ab0e8da0d3d42f3308c6e91/cryptography-1.5.tar.gz"
    sha256 "52f47ec9a57676043f88e3ca133638790b6b71e56e8890d9d7f3ae4fcd75fa24"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/ae/ba/87697a1381386d353e7922a29926d02daeac2f186994848f15e40aeffdc7/debtcollector-1.8.0.tar.gz"
    sha256 "66cd8a08a585f6836896fc980389f1e57bbe36eb140494e546a439b29234d83a"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/13/8a/4eed41e338e8dcc13ca41c94b142d4d20c0de684ee5065523fee406ce76f/decorator-4.0.10.tar.gz"
    sha256 "9c6e98edcb33499881b86ede07d9968c81ab7c769e28e9af24075f0a5379f070"
  end

  resource "docker-py" do
    url "https://files.pythonhosted.org/packages/d7/32/1e6be8c9ebc7d02fe74cb1a050008bc9d7e2eb9219f5d5e257648166e275/docker-py-1.9.0.tar.gz"
    sha256 "6dc6b914a745786d97817bf35bfc1559834c08517c119f846acdfda9cc7f6d7e"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/9d/a9/ba70aadc6170841a1c6145e9039d4b1c2a4ef8c44cd0ca9b09ab79be9120/dogpile.cache-0.6.2.tar.gz"
    sha256 "73793471af07af6dc5b3ee015abfaca4220caaa34c615537f5ab007ed150726d"
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
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "httplib2" do
    url "https://files.pythonhosted.org/packages/ff/a9/5751cdf17a70ea89f6dde23ceb1705bfb638fd8cee00f845308bf8d26397/httplib2-0.9.2.tar.gz"
    sha256 "c3aba1c9539711551f4d83e857b316b5134a1c4ddce98a875b7027be7dd6d988"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/fb/84/8c27516fbaa8147acd2e431086b473c453c428e24e8fb99a1d89ce381851/idna-2.1.tar.gz"
    sha256 "ed36f281aebf3cd0797f163bb165d84c31507cedd15928b095b1675e2d04c676"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/cd/c5/bd44885274379121507870d4abfe7ba908326cf7bfd50a48d9d6ae091c0d/ipaddress-1.0.16.tar.gz"
    sha256 "5a3182b322a706525c46282ca6f064d27a02cffbd449f9f47416f1dc96aa71b0"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/c0/75/c9209ee4d1b5975eb8c2cba4428bde6b61bd55664a98290dd015cdb18e98/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/8f/d8/6e3e602a3e90c5e3961d3d159540df6b2ff32f5ab2ee8ee1d28235a425c1/jmespath-0.9.0.tar.gz"
    sha256 "08dfaa06d4397f283a01e57089f3360e3b52b5b9da91a70e1fd91e9f0cdd3d3d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/4b/2b/72f41fe41af008ebd5af3161345d7f47f2afe2b766d4ab1c412701ad71e5/jsonpatch-1.14.tar.gz"
    sha256 "776d828d6f7b4581862529cf413439a652d74b9e3a0261fa08c36fd761a78b4a"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/f6/36/6bdd302303e8bc7c25102dbc1eabb3e3d97f57b0f8f414f4da7ea7ab9dd8/jsonpointer-1.10.tar.gz"
    sha256 "9fa5dcac35eefd53e25d6cd4c310d963c9f0b897641772cd6e5e7b89df7ee0b1"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/0d/c816f5ea5adaf1293a1d81d32e4cdfdaf8496973aa5049786d7fdb14e7e7/jsonschema-2.5.1.tar.gz"
    sha256 "36673ac378feed3daa5956276a829699056523d7961027911f064b52255ead41"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/7e/84/65816c2936cf7191bcb5b3e3dc4fb87def6f8a38be25b3a78131bbb08594/keyring-9.3.1.tar.gz"
    sha256 "3be74f6568fcac1350b837d7e46bd3525e2e9fe2b78b3a3a87dc3b29f24a0c00"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/77/03/6a843e309d2dfbf45ff6ff97dd608ddc3ffc189ade4940adbaec2cd6925f/keystoneauth1-2.12.1.tar.gz"
    sha256 "939d89d2998368670f3aad736b7489b6186cceacc5e36623daebab2c07baacf0"
  end

  resource "mock" do
    url "https://files.pythonhosted.org/packages/0c/53/014354fc93c591ccc4abff12c473ad565a2eb24dcd82490fae33dbf2539f/mock-2.0.0.tar.gz"
    sha256 "b158b6df76edd239b8208d481dc46b6afd45a846b7812ff0ce58971cf5bc8bba"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/08/35/9e06c881c41962d7367e9466724beda2b1101439b149b7ff708d708890de/monotonic-1.2.tar.gz"
    sha256 "c0e1ceca563ca6bb30b0fb047ee1002503ae6ad3585fc9c6af37a8f77ec274ba"
  end

  resource "msgpack-python" do
    url "https://files.pythonhosted.org/packages/21/27/8a1d82041c7a2a51fcc73675875a5f9ea06c2663e02fcfeb708be1d081a0/msgpack-python-0.4.8.tar.gz"
    sha256 "1a2b19df0f03519ec7f19f826afb935b202d8979b0856c6fb3dc28955799f886"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/06/df/f8c11e662c80741240e48b701c6ee81723ecc6a4f81db63c664428d6f4da/munch-2.0.4.tar.gz"
    sha256 "1420683a94f3a2ffc77935ddd28aa9ccb540dd02b75e02ed7ea863db437ab8b2"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/7c/ec/104f193e985e0aa813ffb4ba5da78d6ae3200165bf583d522ac2dc40aab2/netaddr-0.7.18.tar.gz"
    sha256 "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a7/4c/8e0771a59fd6e55aac993a7cc1b6a0db993f299514c464ae6a1ecf83b31d/netifaces-0.10.5.tar.gz"
    sha256 "59d8ad52dd3116fcb6635e175751b250dc783fb011adba539558bd764e5d628b"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/08/3d/0135aec22b814c07b37cd80dc0cd2eaa4208a63863a78c810e1d2ea9d272/openstacksdk-0.9.5.tar.gz"
    sha256 "620ed52b90a6e494b0732b63766264bede8c2fe2b4394fb1dd8d4c75a43ad4c6"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/42/b3/a4d9393a9671ad9c9768be5b551b068c74edcc4a703db36bf005a38c8c68/os-client-config-1.21.1.tar.gz"
    sha256 "ad4c2d07c0468c8d11916ea690b977abb3e903e0c599f6eae02c4776edab2f96"
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

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/3c/43/32ec04a45d15641af4ff690a2f5b0d1603b272c7662a7f319567f4ad62b5/osc-lib-1.1.0.tar.gz"
    sha256 "e06ca111b2702d442f5cf70c754b6331cc7742231f0fe0b634cbd03c502610ba"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/b3/33/70ec8dfba548cbd562592892a6ae88ee0e3b961805204caa479517133dd0/oslo.config-3.17.0.tar.gz"
    sha256 "a45cb90cf999536f0f7dd3d3e578d4645d2228474f9fafba982e73c5aa1fef7a"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/4f/4d/3ff83bcf4f93c9b70f5653c52e030701e2e9964735c2aec04f76957e7a60/oslo.i18n-3.9.0.tar.gz"
    sha256 "0bcb8108cf38b9ad4feb1ee08d27e34dc358f80dc7a7fe9a5b942ebf3b07c0b5"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/af/63/cdfd2dde6380fa8b22612b00d3ee4a143c8aeb9c2fed07f7ea4bdb05fad2/oslo.serialization-2.13.0.tar.gz"
    sha256 "7bfdb1c10bc24c4887407a2ac46708b1fd16e9bc2ceb6bb3805696e8cebf6566"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/cd/87/97ba9a3bce5f03eba41e0eee9345f2c1fe533121e2880a35493854650511/oslo.utils-3.16.0.tar.gz"
    sha256 "109e018da9d95caba79c94935257d2335e5a77e65ebbff218cb9756e746630f1"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8/paramiko-2.0.2.tar.gz"
    sha256 "411bf90fa22b078a923ff19ef9772c1115a0953702db93549a2848acefd141dc"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/1e/59/d1a50836b29c87a1bde9442e1846aa11e1548491cbee719e51b45a623e75/passlib-1.6.5.tar.gz"
    sha256 "a83d34f53dc9b17aa42c9a35c3fbcc5120f3fcb07f7f8721ec45e6a27be347fc"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/83/73/1e2c630d868b73ecdea381ad7b081bc53888c07f1f9829699d277a2859a8/positional-1.1.1.tar.gz"
    sha256 "ef845fa46ee5a11564750aaa09dd7db059aaf39c44c901b37181e5ffa67034b0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/6d/31/666614af3db0acf377876d48688c5d334b6e493b96d21aa7d332169bee50/pycparser-2.14.tar.gz"
    sha256 "7959b4a74abdc27b312fed1c21e6caf9309ce0b29ea86b591fd2e99ecdf27f73"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/65/25/1bb68622ca70abc145ac9c9bcd0e837fccd2889d79cee641aa8604d18a11/pyparsing-2.1.8.tar.gz"
    sha256 "03a4869b9f3493807ee1f1cb405e6d576a1a2ca4d81a982677c0c1ad6177c56b"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/b8/00/3b456dc8423f6f6a1b9b07c92c487809307a13dee83d22edb524b6f024b4/pyrax-1.9.8.tar.gz"
    sha256 "e9db943447fdf2690046d7f98466fc4743497b74578efe6e400a6edbfd9728f5"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/02/9d/6812ac473962f03f656f13d91c3e587558df2f92331040c75b37bf144f3f/python-cinderclient-1.9.0.tar.gz"
    sha256 "17cab946a64808404c6c6840d43487a5082a730cc517d0ebbe6824b54a267fb7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/3e/f5/aad82824b369332a676a90a8c0d1e608b17e740bbb6aeeebca726f17b902/python-dateutil-2.5.3.tar.gz"
    sha256 "1408fdb07c6a1fa9997567ce3fcee6a337b39a503d80699e0f213de4aa4b32ed"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/52/24/b3971229ba7a505401966e11e9965643fb31e903d91769aeff4813b07a38/python-designateclient-2.3.0.tar.gz"
    sha256 "f41e533cd9eda72638ce288e3dfad1e18cfc4210bd9ca248d70939ff2fccf856"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/93/4d/b8ddde77ed12292e376ea10b81b34ba87152b617416d028888de02022717/python-glanceclient-2.5.0.tar.gz"
    sha256 "8c510a089fb4dc8355d5db0de608361888b5e4e0c81e0d153ae1b1366bfb8a08"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/95/5d/f5a1653e650c96b75396a9e01f295a6a67cca23b0560821e3663bd88a5ed/python-heatclient-1.4.0.tar.gz"
    sha256 "c653f145501ff4cfe2d0c2e1e0db4bccefca44224aca3bf1bea8d62908969a9b"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/93/af/ad8dcf86d4107673b730a515bac9bda41fb241a9b1bfb22835f9555dd4a7/python-ironicclient-1.7.0.tar.gz"
    sha256 "6779295a7312902d0de8115746c2fbaacc51d853d997c4e93d90e21490b4f5d6"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/f1/bd/0bcd736b3c73c4c72b93eb898469e726f7b8c24832b68a2eb72358db14d5/python-keystoneclient-3.5.0.tar.gz"
    sha256 "5a1c7f3902193c620e398c4655b7d363a7fabdb286e549fccf99ae84ed1612dd"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/9a/95/2983b7e124f2326b3f27d33bd3adfd7ad8593a1ee80d8d3e11fab8728f27/python-magnumclient-2.3.0.tar.gz"
    sha256 "f4d2420e6085c56998a41b6ade4e9a7b74058f4f20d515aff3c4e4fdf4174a2e"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/d7/a8/0b32fd8df45e0235114d374be03cfb3bc224bf4541513525ad5b2de220b3/python-mistralclient-2.1.1.tar.gz"
    sha256 "6c3d8b2d4c81490e12663e0152d92b850496403c29c232cb05095b8ea22f8984"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/50/4d/b0b3b3bfd678a0b3e0ce16bbd539dab1e7718f98d53787efbd41083828fb/python-neutronclient-6.0.0.tar.gz"
    sha256 "a30556f8b9541e94f44a9911d9af89037710761755758a2c1598fa92809293a2"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/1e/ef/60be3255a46dc7e7b2912a735163ee451d84af0d0f4e40fff26500db930c/python-novaclient-6.0.0.tar.gz"
    sha256 "68fb4e75012a66d23198ca9c6cdc425cd9e0ce750bf759af6cd48fdb19ee6068"
  end

  resource "python-openstackclient" do
    url "https://files.pythonhosted.org/packages/18/6e/2bbe4d680be08d32e5e526f09c7faa14ca09f189a390a1e43eeb29735181/python-openstackclient-3.2.0.tar.gz"
    sha256 "4f66ccbdb2b3de71d69fee305a9585435cdaa0f9e523240c2f6c756555283c7a"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/d9/7f/4e6e49f4946adb22bbd4b015cc18b3f1606f8fa0a679cef010b1e52929d4/python-swiftclient-3.1.0.tar.gz"
    sha256 "7bb5984862b85ba2a18c16b4dc6af2fd14272871ad165eec47e9da111ab3fb9a"
  end

  resource "python-troveclient" do
    url "https://files.pythonhosted.org/packages/73/ea/76350164458d0e7d3f1e4307014f0f206b32b9ddb6ba019142ee2ba4b28c/python-troveclient-2.5.0.tar.gz"
    sha256 "03fc7cf8d47f910bc64274f7c24808b6ef79a9a1f34be5b94bea7070c9e00e5b"
  end

  resource "pywinrm" do
    url "https://github.com/diyan/pywinrm/archive/v0.2.1.tar.gz"
    sha256 "b919767eb2598944c6437629de6f5da3b79374d6d409c7b99a167f376f1c6c75"
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
    url "https://files.pythonhosted.org/packages/2e/ad/e627446492cc374c284e82381215dcd9a0a87c4f6e90e9789afefe6da0ad/requests-2.11.1.tar.gz"
    sha256 "5acf980358283faba0b897c73959cecf8b841205bb4b2ad3ef545f46eae1a133"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/09/0f/b0fa2986054805114fb185b97e270e0b8b0fd4159fa7a3791b7c61a958c9/requestsexceptions-1.1.3.tar.gz"
    sha256 "d678b872f51f76d875e00e6667f4ddbf013b3a99490ae5fe07cf3e4f846e283e"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/17/b6/f2d5df2e369142010fb5d91b12a962643e1a2d3578b04ff22276a5c53238/rfc3986-0.4.1.tar.gz"
    sha256 "5ac85eb132fae7bbd811fa48d11984ae3104be30d44d397a351d004c633a68d2"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/d4/6e/1e9014fa7d3e8cd1f0c717321cea628606f61d24991c8945eb464ae4b325/s3transfer-0.1.3.tar.gz"
    sha256 "af2e541ac584a1e88d3bca9529ae784d2b25e5d448685e0ee64f4c0e1e017ed2"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/bb/0e/da77a0a6abdab40b15d02b2911d8019e260dc2d1522648f0212cc7608b72/shade-1.11.1.tar.gz"
    sha256 "eb4d21652cbefb496040ef3e74edc2745f2d58fe81cf4dea8f421105a156c318"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/f0/07/26b519e6ebb03c2a74989f7571e6ae6b82e9d7d81b8de6fcdbfc643c7b58/simplejson-3.8.2.tar.gz"
    sha256 "d58439c548433adcda98e695be53e526ba940a4b9c44fb9a05d92cd495cdd47f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/98/33/2c8003cb4294d1729bfb6cdf4bbfe74b968403b2df0a80ee876bebf20488/stevedore-1.17.1.tar.gz"
    sha256 "79414e27ece996b2e81161c1ec91536f2b15645d5f6bd28128724486e1c4b8e3"
  end

  resource "unicodecsv" do
    url "https://files.pythonhosted.org/packages/6f/a4/691ab63b17505a26096608cc309960b5a6bdf39e4ba1a793d5f9b1a53270/unicodecsv-0.14.1.tar.gz"
    sha256 "018c08037d48649a0412063ff4eda26eaa81eff1546dbffa51fa5293276ff7fc"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/0f/d4/408b936a3d9214b7685c35936bb59d9254c70ff319ee6a837b9efcf5615e/warlock-1.2.0.tar.gz"
    sha256 "7c0d17891e14cf77e13a598edecc9f4682a5bc8a219dc84c139c5ba02789ef5a"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/a3/1e/b717151e29a70e8f212edae9aebb7812a8cae8477b52d9fe990dcaec9bbd/websocket_client-0.37.0.tar.gz"
    sha256 "678b246d816b94018af5297e72915160e2feb042e0cde1a9397f502ac3a52f41"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/00/dd/dc22f8d06ee1f16788131954fc69bc4438f8d0125dd62419a43b86383458/wrapt-1.10.8.tar.gz"
    sha256 "4ea17e814e39883c6cf1bb9b0835d316b2f69f0f0882ffe7dad1ede66ba82c73"
  end

  resource "xmltodict" do
    url "https://pypi.python.org/packages/source/x/xmltodict/xmltodict-0.9.2.tar.gz"
    sha256 "275d1e68c95cd7e3ee703ddc3ea7278e8281f761680d6bdd637bcd00a5c59901"
  end

  resource "zabbix-api" do
    url "https://pypi.python.org/packages/source/z/zabbix-api/zabbix-api-0.4.tar.gz"
    sha256 "31fab8ca9b12aa5e6fe79b4463cfe62f33ded770ddc933a8d99c4debe934a0de"
  end

  def install
    inreplace "lib/ansible/constants.py" do |s|
      s.gsub! "/usr/share/ansible", pkgshare
      s.gsub! "/etc/ansible", etc/"ansible"
    end

    virtualenv_install_with_resources
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    ENV["ANSIBLE_REMOTE_TEMP"] = testpath/"tmp"
    (testpath/"playbook.yml").write <<-EOF.undent
      ---
      - hosts: all
        gather_facts: False
        tasks:
        - name: ping
          ping:
    EOF
    (testpath/"hosts.ini").write "localhost ansible_connection=local\n"
    system bin/"ansible-playbook", testpath/"playbook.yml", "-i", testpath/"hosts.ini"

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python", "-c", script
  end
end
