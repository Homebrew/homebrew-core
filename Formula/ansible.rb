class Ansible < Formula
  include Language::Python::Virtualenv

  desc "Automate deployment, configuration, and upgrading"
  homepage "https://www.ansible.com/"
  url "https://releases.ansible.com/ansible/ansible-2.3.0.0.tar.gz"
  sha256 "299f3907cd566a20e163942fa82b6afc86ef89c2726ba503b90c1a651e82a458"
  revision 3
  head "https://github.com/ansible/ansible.git", :branch => "devel"

  bottle do
    cellar :any
    sha256 "989093992bd5858263630ff274d88193dc55c2d8f5c30b84047f601fa92aa458" => :sierra
    sha256 "2ce2531db25fe5ff9a15d478241b0f699e84edf60d7d1e48c986fc3baf45dac4" => :el_capitan
    sha256 "26455472ce074cf4eeb3e7a40cc43ce513c1e306b7cea465bcfa780e9795a464" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on :python
  depends_on "libyaml"
  depends_on "openssl@1.1"

  # Collect requirements from:
  #   ansible
  #   docker-py
  #   pyrax (Rackspace)
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

  ### setup_requires dependencies
  resource "pbr" do
    url "https://files.pythonhosted.org/packages/35/a5/3d1beff9fc149b3da814419369a8c24ecf0d1410637fc91002989f433a1a/pbr-2.0.0.tar.gz"
    sha256 "0ccd2db529afd070df815b1521f01401d43de03941170f8a800e7531faba265d"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end
  ### end

  ### extras for requests[security]
  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end
  ### end

  # The rest of this list should always be sorted by:
  # pip install homebrew-pypi-poet && poet_lint $(brew formula ansible)
  resource "Babel" do
    url "https://files.pythonhosted.org/packages/92/22/643f3b75f75e0220c5ef9f5b72b619ccffe9266170143a4821d4885198de/Babel-2.4.0.tar.gz"
    sha256 "8c98f5e5f8f5f088571f2c6bd88d530e331cbbcb95a7311a0db69d3dca7ec563"
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

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/4a/85/db5a2df477072b2902b0eb892feb37d88ac635d36245a72a6a69b23b383a/PyYAML-3.12.tar.gz"
    sha256 "592766c6303207a20efc445587778322d7f73b161bd994f227adaa341ba212ab"
  end

  resource "apache-libcloud" do
    url "https://files.pythonhosted.org/packages/1d/a6/569313d0c95b6e0bbebc5f2c8197a7261c85556a3de84d42e9093d7d6996/apache-libcloud-1.5.0.tar.bz2"
    sha256 "ea3dd7825e30611e5a018ab18107b33a9029097d64bd8b39a87feae7c2770282"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "backports.ssl_match_hostname" do
    url "https://files.pythonhosted.org/packages/76/21/2dc61178a2038a5cb35d14b61467c6ac632791ed05131dda72c20e7b9e23/backports.ssl_match_hostname-3.5.0.1.tar.gz"
    sha256 "502ad98707319f4a51fa2ca1c677bd659008d27ded9f6380c79e8932e38dcdf2"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/b1/f9/cf8fa9a4a48e651294fc88446edee96f8b965f1d3ca044befc5dd7c9449b/boto-2.46.1.tar.gz"
    sha256 "d24a68d97276445d1b5baee6537bc565ab7070afcd449a72f2541b1da1328ed4"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/58/61/50d2e459049c5dbc963473a71fae928ac0e58ffe3fe7afd24c817ee210b9/boto3-1.4.4.tar.gz"
    sha256 "518f724c4758e5a5bed114fbcbd1cf470a15306d416ff421a025b76f1d390939"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8e/7c/d30801e93b84846a2383ad1767bb0510a598c42c17df3dab5720a780f475/botocore-1.5.39.tar.gz"
    sha256 "d89c3d79beaf4555885f5c0f756e287c10075d4534ad61b9072420402157e813"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/f6/2c/21dd9e7f64d76a532c64af00848b69b005011ef6656adf18081189b303a1/cliff-2.5.0.tar.gz"
    sha256 "a6e4bbe9cfddbaf0b1a88ed3c7369781adef976c2449224584ca65c72b83b13a"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/9b/58/e88fda298b521e6073d4dd7f305cf661d805d1c06fd86f44ccc2f271a800/cmd2-0.7.0.tar.gz"
    sha256 "5ab76a1f07dd5fd1cc3c15ba4080265f33b80c7fd748d71bd69a51d60b30f51a"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/d9/cc/95f6a835f9bd9d90df3a08b9f9448b57fabc895c3229a104f8b0e416b655/debtcollector-1.13.0.tar.gz"
    sha256 "51476e048626f66ead094a14906a1352efbef4c718c86f351a660fa832e1da7a"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/cc/ac/5a16f1fc0506ff72fcc8fd4e858e3a1c231f224ab79bb7c4c9b2094cc570/decorator-4.0.11.tar.gz"
    sha256 "953d6bf082b100f43229cf547f4f97f97e970f5ad645ee7601d55ff87afdfe76"
  end

  resource "deprecation" do
    url "https://files.pythonhosted.org/packages/ab/fe/edad444ecab087e57dd32a10e38ef0d7448b3ab8ff8bfa65b022d3a43a1c/deprecation-1.0.tar.gz"
    sha256 "36d2a2356ca89fb73f72bfb866a2f28e183535a7f131a3b34036bc48590165b6"
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
    url "https://files.pythonhosted.org/packages/05/25/7b5484aca5d46915493f1fd4ecb63c38c333bd32aa9ad6e19da8d08895ae/docutils-0.13.1.tar.gz"
    sha256 "718c0f5fb677be0f34b781e04241c4067cbd9327b66bdd8e763201130f5175be"
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
    url "https://files.pythonhosted.org/packages/cc/26/b61e3a4eb50653e8a7339d84eeaa46d1e93b92951978873c220ae64d0733/futures-3.1.1.tar.gz"
    sha256 "51ecb45f0add83c806c68e4b06106f90db260585b25ef2abfcda0bd95c0132fd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/c0/75/c9209ee4d1b5975eb8c2cba4428bde6b61bd55664a98290dd015cdb18e98/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/96/6e/0723cccec195a37de6a428ad8879fe063b6debe5c855444e9285b27d253e/jmespath-0.9.2.tar.gz"
    sha256 "54c441e2e08b23f12d7fa7d8e6761768c47c969e6aed10eead57505ba760aee9"
  end

  resource "jxmlease" do
    url "https://files.pythonhosted.org/packages/80/b3/a1ffc5ea763c84780a9acfaa4f69a98f6c974eaf297e20d9d3648ef7d95b/jxmlease-1.0.1.tar.gz"
    sha256 "fb04cfd54d8d7e4cc533108750047e9ccf43139c3c0220f8a082274b19564e98"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/be/c1/947048a839120acefc13a614280be3289db404901d1a2d49b6310c6d5757/jsonpatch-1.15.tar.gz"
    sha256 "ae23cd08b2f7246f8f2475363501e740c4ef93f08f2a3b7b9bcfac0cc37fceb1"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/f6/36/6bdd302303e8bc7c25102dbc1eabb3e3d97f57b0f8f414f4da7ea7ab9dd8/jsonpointer-1.10.tar.gz"
    sha256 "9fa5dcac35eefd53e25d6cd4c310d963c9f0b897641772cd6e5e7b89df7ee0b1"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/58/b9/171dbb07e18c6346090a37f03c7e74410a1a56123f847efed59af260a298/jsonschema-2.6.0.tar.gz"
    sha256 "6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02"
  end

  resource "junos-eznc" do
    url "https://files.pythonhosted.org/packages/9b/3c/d50f8e8e8cd562bccd63bee252e65c96fb05cc293bce11846c489612e3a1/junos-eznc-2.1.1.tar.gz"
    sha256 "69f1db68bc68f9d624705c7c809a54a539762c734df69cb2d76ee3db01dc882f"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/74/12/cb9734c841f2fbd30a3dda2275438b657d075d03975891f33761de1b5b91/keystoneauth1-2.19.0.tar.gz"
    sha256 "1a249d6f2413195a86478a3de774a27b11798b4a477eb1e8217d8e40b89bfcfe"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/39/e8/a8e0b1fa65dd021d48fe21464f71783655f39a41f218293c1c590d54eb82/lxml-3.7.3.tar.gz"
    sha256 "aa502d78a51ee7d127b4824ff96500f0181d3c7826e6ee7b800d068be79361c7"
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
    url "https://files.pythonhosted.org/packages/84/dc/d897cb427f15029e04745a3de611d8ed3d97e9a0ef894547a0ba261f2807/munch-2.1.1.tar.gz"
    sha256 "648b650d1eb0173bd83c29f2eea2568b7591c1e05c87971387d170c71c6397e8"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz"
    sha256 "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a7/4c/8e0771a59fd6e55aac993a7cc1b6a0db993f299514c464ae6a1ecf83b31d/netifaces-0.10.5.tar.gz"
    sha256 "59d8ad52dd3116fcb6635e175751b250dc783fb011adba539558bd764e5d628b"
  end

  resource "ncclient" do
    url "https://files.pythonhosted.org/packages/e9/cf/cb131bcaf9b31f8d9d1b9ec3aa9a861dd72a7269a9ff07217b60157fa526/ncclient-0.5.3.tar.gz"
    sha256 "fe6b9c16ed5f1b21f5591da74bfdd91a9bdf69eb4e918f1c06b3c8db307bd32b"
  end

  resource "ntlm-auth" do
    url "https://files.pythonhosted.org/packages/ac/99/5183cbb714537e0bd31dd266f2bad894f17112f862bb5c65fd6a5367dd2b/ntlm-auth-1.0.2.zip"
    sha256 "06b8d587c757c050ec4dce75057f41d519dfae42b09686387463290826ffda63"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/23/ef/ef1ecc719b0adaa79c55d30b17f6a9f31ecbfe338f6adaff7feda440416a/openstacksdk-0.9.15.tar.gz"
    sha256 "5f311f492f975a52c33f28be69e8e6ff519e8bfb95971bf79a8cf6c373a0577b"
  end

  resource "ordereddict" do
    url "https://files.pythonhosted.org/packages/53/25/ef88e8e45db141faa9598fbf7ad0062df8f50f881a36ed6a0073e1572126/ordereddict-1.1.tar.gz"
    sha256 "1c35b4ac206cef2d24816c89f89cf289dd3d38cf7c449bb3fab7bf6d43f01b1f"
  end

  resource "os-client-config" do
    url "https://files.pythonhosted.org/packages/27/13/aca5ca37a70ffefec4e6550b766c760743ccd68a7e0b9ebd1f801e7b178b/os-client-config-1.26.0.tar.gz"
    sha256 "77cb506da9fa5e5dc53b1b8b5dca7c5d7816dea91783518e31bbdd98aa87ece9"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/e5/5b/b0c6e7d737468c6de98d880ed90cacb11d080030d24b881dcce809f9ac3e/osc-lib-1.3.0.tar.gz"
    sha256 "32bf892ba828241f93ae0ef5c94d6b92ac3deb9f061dd4ffb61e05120b4ff365"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/ec/51/dbe21933fc21b718e9e44a53cb9eab1a4b8ee8188040f9a286e538639f04/oslo.config-3.24.0.tar.gz"
    sha256 "5cb2b3de074fc8f7e28a5122b4ec434df8079420a8309ada51d20b139aea9f64"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/ea/c5/d5239fcc8c60b529e87127691a5cd5d76109ef03766333409b7424b78ba1/oslo.i18n-3.15.0.tar.gz"
    sha256 "8ec9050bdf840b3d5d0154705804e41625b373fff2bac8ada7d58003e378a71e"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/37/16/f1441bd08d68043a839f745f354446c82d0fb5fcc9031a26f17907c59552/oslo.serialization-2.18.0.tar.gz"
    sha256 "0947922f41691f77593d0574382d4bacdb471eeed28108903567415471f276be"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/ef/a1/a87cab53c2784020477a5b64aedf371293d880248982b803d1dc50f49f40/oslo.utils-3.25.0.tar.gz"
    sha256 "8751d633cc8dc9a0f52d617a9b1d53177fd631a30641541a0ac860e896360e46"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/64/79/5e8baeedb6baf1d5879efa8cd012f801efc232e56a068550ba00d7e82625/paramiko-2.1.2.tar.gz"
    sha256 "5fae49bed35e2e3d45c4f7b0db2d38b9ca626312d91119b3991d0ecf8125e310"
  end

  resource "passlib" do
    url "https://files.pythonhosted.org/packages/25/4b/6fbfc66aabb3017cd8c3bd97b37f769d7503ead2899bf76e570eb91270de/passlib-1.7.1.tar.gz"
    sha256 "3d948f64138c25633613f303bcc471126eae67c04d5e3f6b7b8ce6242f8653e0"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/83/73/1e2c630d868b73ecdea381ad7b081bc53888c07f1f9829699d277a2859a8/positional-1.1.1.tar.gz"
    sha256 "ef845fa46ee5a11564750aaa09dd7db059aaf39c44c901b37181e5ffa67034b0"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/69/17/eec927b7604d2663fef82204578a0056e11e0fc08d485fdb3b6199d9b590/pyasn1-0.2.3.tar.gz"
    sha256 "738c4ebd88a718e700ee35c8d129acce2286542daa80a82823a7073644f706ad"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/be/64/1bb257ffb17d01f4a38d7ce686809a736837ad4371bcc5c42ba7a715c3ac/pycparser-2.17.tar.gz"
    sha256 "0aac31e917c24cb3357f5a4d5566f2cc91a19ca41862f6c3c22dc60a629673b6"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyserial" do
    url "https://pypi.python.org/packages/8d/88/cf848688ae011085a6da5a470740dafa3a4b105f84a5f79c3b720c19279c/pyserial-3.3.tar.gz"
    sha256 "2949cddffc2b05683065a3cd2345114b1a49b08df8cb843d69ba99dc3e19edc2"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/46/f1/a2cbf4f76d2e5a9bf357c9f4374cfff30ebbd198b6422801554de4d51abf/python-cinderclient-2.0.1.tar.gz"
    sha256 "d86d753d47fe142e323d2c3885f8e0a0295b7105d71e241e3a6b5fa83b910df2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/51/fc/39a3fbde6864942e8bb24c93663734b74e281b984d1b8c4f95d64b0c21f6/python-dateutil-2.6.0.tar.gz"
    sha256 "62a2f8df3d66f878373fd0072eacf4ee52194ba302e00082828e0d263b0418d2"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/76/5d/7ee694c006ca5e8c075947481f6a85771e9850181ea325ec81c5cc2a5ebd/python-designateclient-2.6.0.tar.gz"
    sha256 "15bea5e50883aa9b0c8807b6e01aefb68a99755cd8b8850b4c88b16689ebc686"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/9d/8a/064a266260b42fb6f103c691dda7dffe51f55d27eb20d7fb4473c7e4560a/python-glanceclient-2.6.0.tar.gz"
    sha256 "59ce6ec4cb17e6cb5b94e12d4563a1b6fe2f6dd11c8e1d4e42e45073c76bcc0b"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/35/f2/8f93ccec7f7e07178a566b7a66cd7ff6e69d414fa2a192201e00ac8412a7/python-ironicclient-1.12.0.tar.gz"
    sha256 "0786ba6560125597dfdeeacdcb88460d04c6f58573376cf2ce5f947390b03b4e"
  end

  resource "python-keyczar" do
    url "https://files.pythonhosted.org/packages/c8/14/3ffb68671fef927fa5b60f21c43a04a4a007acbe939a26ba08b197fea6b3/python-keyczar-0.716.tar.gz"
    sha256 "f9b614112dc8248af3d03b989da4aeca70e747d32fe7e6fce9512945365e3f83"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/56/c3/e808e30c7a0b5be8702f24e8c740b50cafe105ef6973624c9a5b258bd85f/python-keystoneclient-3.10.0.tar.gz"
    sha256 "c65fa56791ec02dc942ad08e5c3634b8dca98eda76ee3c2549018b6767e67918"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/02/ca/c382cd4882bc7522e9842bc6ca0be0da43582c00a08785db6b5e31ca6b37/python-neutronclient-6.2.0.tar.gz"
    sha256 "cd888d082e6f72b35fe6eb24a970ff4a05e275dfd3dd30f7f1d9014b61f55589"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/bf/78/e0fb24eda8b6870d30f233292c6a3cdc8f0adbffd24f3ba645f8ddee6827/python-novaclient-8.0.0.tar.gz"
    sha256 "31bb67ba055f926090d69039508ee54df645aaf3beeec88095f8ce7283a35da4"
  end

  resource "python-openstackclient" do
    url "https://files.pythonhosted.org/packages/09/e5/58ff3c1529d49bb436f4d7123df33f09222a9a2dac591ec66b9e4ecc74ee/python-openstackclient-3.9.0.tar.gz"
    sha256 "74262dd62d410c5d1c4fc0ca98ffe50a0f7b55254f53d03a1dc8f5fd87fa519d"
  end

  resource "pywinrm" do
    url "https://files.pythonhosted.org/packages/0b/ca/d0ed22845185fdceb24a1e13811a993e805df9a147d223311061d2e294a7/pywinrm-0.2.2.tar.gz"
    sha256 "3030f700fbd6d06f715d4374c10b3586624bccca003b7075dd281c875705ac1b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/b6/61/7b374462d5b6b1d824977182db287758d549d8680444bad8d530195acba2/requests-2.12.5.tar.gz"
    sha256 "d902a54f08d086a7cc6e58c20e2bb225b1ae82c19c35e5925269ee94fb9fce00"
  end

  resource "requests_ntlm" do
    url "https://files.pythonhosted.org/packages/e8/96/e1a02118867a47f7618df891e5fbecd7e50cafb30b42f1429a2ed5d268ce/requests_ntlm-1.0.0.tar.gz"
    sha256 "53ca319f5538e18c38ac79ec4e0d9680bd8ea7ac05532ed8316879296e426641"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/64/61/61907e515f08cd550bac200696d66ee518fac0d7d7aa7fcfe855fe5de546/requestsexceptions-1.2.0.tar.gz"
    sha256 "8b762ba6ec5f4f5af50bdd3ab07184a0e63803d70e8b1bbbd429a8f5216fe13d"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/17/b6/f2d5df2e369142010fb5d91b12a962643e1a2d3578b04ff22276a5c53238/rfc3986-0.4.1.tar.gz"
    sha256 "5ac85eb132fae7bbd811fa48d11984ae3104be30d44d397a351d004c633a68d2"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/8b/13/517e8ec7c13f0bb002be33fbf53c4e3198c55bb03148827d72064426fe6e/s3transfer-0.1.10.tar.gz"
    sha256 "ba1a9104939b7c0331dc4dd234d79afeed8b66edce77bbeeecd4f56de74a0fc1"
  end

  resource "scp" do
    url "https://files.pythonhosted.org/packages/1d/a9/618f1e40e30c69ffab668493953e74e6c266f383af6e34e1b8f089e41139/scp-0.10.2.tar.gz"
    sha256 "18f59e48df67fac0b069591609a0f4d50d781a101ddb8ec705f0c2e3501a8386"
  end

  resource "shade" do
    url "https://files.pythonhosted.org/packages/6f/3b/f032ad756716d9604354518584be490daacaf46865065b513d43ee70b89a/shade-1.19.0.tar.gz"
    sha256 "8ab1f41eef68849baa698733c63e5740ad5d983fea61f284fe4bf9a0d69ebf31"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/40/ad/52c1f3a562df3b210e8f165e1aa243a178c454ead65476a39fa3ce1847b6/simplejson-3.10.0.tar.gz"
    sha256 "953be622e88323c6f43fad61ffd05bebe73b9fd9863a46d68b052d2aa7d71ce2"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/6e/a6/0686e6aa6c60ab8128439de0476a83ab5c28c7fa3381128f3395b0cf27c1/stevedore-1.21.0.tar.gz"
    sha256 "aa0e64490e9eef9f0ae96a3b226f963ebf54bb6a38176472d76253d015424f8b"
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
    url "https://files.pythonhosted.org/packages/a7/2b/0039154583cb0489c8e18313aa91ccd140ada103289c5c5d31d80fd6d186/websocket_client-0.40.0.tar.gz"
    sha256 "40ac14a0c54e14d22809a5c8d553de5a2ae45de3c60105fae53bcb281b3fe6fb"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/a3/bb/525e9de0a220060394f4aa34fdf6200853581803d92714ae41fc3556e7d7/wrapt-1.10.10.tar.gz"
    sha256 "42160c91b77f1bc64a955890038e02f2f72986c01d462d53cb6cb039b995cdd9"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/4a/5e/cd36c16c9eca47162fbbea9aa723b9ab3010f9ae9d4be5c9f6cb2bc147ab/xmltodict-0.10.2.tar.gz"
    sha256 "fc518ccf9adbbb917a2ddcb386be852ae6dd36935e1e8b9a3e760201abfdbf77"
  end

  resource "zabbix-api" do
    url "https://files.pythonhosted.org/packages/39/d9/6f31d35a8721364f1a3ac07dfe6f1bec4839c910a8b1dc14c9206e425d3c/zabbix-api-0.4.tar.gz"
    sha256 "31fab8ca9b12aa5e6fe79b4463cfe62f33ded770ddc933a8d99c4debe934a0de"
  end

  def install
    # https://github.com/Homebrew/homebrew-core/issues/7197
    ENV.prepend "CPPFLAGS", "-I#{MacOS.sdk_path}/usr/include/ffi"

    inreplace "lib/ansible/constants.py" do |s|
      s.gsub! "/usr/share/ansible", pkgshare
      s.gsub! "/etc/ansible", etc/"ansible"
    end

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
