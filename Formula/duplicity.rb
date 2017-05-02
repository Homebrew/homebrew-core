class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://launchpad.net/duplicity/0.7-series/0.7.12/+download/duplicity-0.7.12.tar.gz"
  sha256 "11cbad44a90891af1bf9e294260ba7c21a1660ccd3ab2c6e736ba74ac5cf0fe6"

  bottle do
    cellar :any
    sha256 "1925a84c09215552a8c2f422b9530bc5a2247b96b8dcac52c29444bdb7569375" => :sierra
    sha256 "2aa6ad3d05ec04dda268adc929bd41aaaef55a969b29151e65ac79bd160fefcd" => :el_capitan
    sha256 "f3b5d8808429d7301515f68fae652d8f525653f730f0b3c9709e6af88f36d023" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "openssl@1.1"
  depends_on "par2" => :optional
  depends_on :gpg => :run

  # Generated with homebrew-pypi-poet from
  # for i in boto pyrax dropbox mega.py paramiko pexpect pycrypto
  # lockfile python-swiftclient python-keystoneclient; do poet -r $i >>
  # resources; done
  # Additional dependencies of requests[security] should also be installed:
  #   ndg-httpsclient, pyOpenSSL

  # must be installed early
  resource "pytz" do
    url "https://files.pythonhosted.org/packages/53/35/6376f58fb82ce69e2c113ca0ebe5c0f69b20f006e184bcc238a6007f4bdb/pytz-2016.7.tar.bz2"
    sha256 "6eab31709e3a4aea748457707da45e805b650cbb352583805d2417de2a1dd71e"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
  end

  resource "PrettyTable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/48/69/d87c60746b393309ca30761f8e2b49473d43450b150cb08f3c6df5c11be5/appdirs-1.4.3.tar.gz"
    sha256 "9e5896d1372858f8dd3344faf4e5014d21849c756c8d5701f78f8a103b372d92"
  end

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/68/4a/48b302989cbc3e6c64a16da5ec807bb7b36d8e8d3428579addde2eb1f671/boto-2.43.0.tar.gz"
    sha256 "de4449cdc671939ecea6121c05587b25e73ac0c057bf1278a44bbc1974d5fd94"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a1/32/e3d6c3a8b5461b903651dd6ce958ed03c093d2e00128e3f33ea69f1d7965/cffi-1.9.1.tar.gz"
    sha256 "563e0bd53fda03c151573217b3a49b3abad8813de9dd0632e10090f6190fdaf8"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/ec/5f/d5bc241d06665eed93cd8d3aa7198024ce7833af7a67f6dc92df94e00588/cryptography-1.8.1.tar.gz"
    sha256 "323524312bb467565ebca7e50c8ae5e9674e544951d28a2904a50012a8828190"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/72/2a/6f2cf50c86a09f4b0f745c13c9f05b597264af38850a870ba37990ee2eea/debtcollector-1.9.0.tar.gz"
    sha256 "ca0c89618f2e655921896c5f7f0bd0bae1008f0c78a6a8560adba8971ba33d70"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/19/a2/690e468e815cb80175677d2d1990e81367c641f75da4bf35461315a27936/dropbox-7.1.1.tar.gz"
    sha256 "8f362c443b50da516bb42b291e655390331b2005da1fae70898697c3d0127fdc"
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
    url "https://files.pythonhosted.org/packages/55/db/97c1ca37edab586a1ae03d6892b6633d8eaa23b23ac40c7e5bbc55423c78/futures-3.0.5.tar.gz"
    sha256 "0542525145d5afc984c88f914a0c85c77527f65946617edb5274f72406f981df"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/d8/82/28a51052215014efc07feac7330ed758702fc0581347098a81699b5281cb/idna-2.5.tar.gz"
    sha256 "3cb5ce08046c4e3a560fc02f138d0ac63e00f8ce5901a56b32ec8b7994082aab"
  end

  resource "ip_associations_python_novaclient_ext" do
    url "https://files.pythonhosted.org/packages/01/4e/230d9334ea61efb16dda8bef558fd11f8623f6f3ced8a0cf68559435b125/ip_associations_python_novaclient_ext-0.2.tar.gz"
    sha256 "e4576c3ee149bcca7e034507ad9c698cb07dd9fa10f90056756aea0fa59bae37"
  end

  resource "ipaddress" do
    url "https://files.pythonhosted.org/packages/4e/13/774faf38b445d0b3a844b65747175b2e0500164b7c28d78e34987a5bfe06/ipaddress-1.0.18.tar.gz"
    sha256 "5d8534c8e185f2d8a1fda1ef73f2c8f4b23264e8e30063feeb9511d492a413e1"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/c0/75/c9209ee4d1b5975eb8c2cba4428bde6b61bd55664a98290dd015cdb18e98/iso8601-0.1.11.tar.gz"
    sha256 "e8fb52f78880ae063336c94eb5b87b181e6a0cc33a6c008511bac9a6e980ef30"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/2b/b2/ccc3d598524a179b9ebbb9887885c8e1e428bd21b892a1f83cf774b1378c/keyring-10.0.2.tar.gz"
    sha256 "91c31fd805b3ce6343406c7c51437f7505f3e9abb6e14ccac8242ea1fc912d77"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/f2/9b/4dc2981dcf7d2f0304ad45969150f93725293bc7f6194e7c29d54d4596b6/keystoneauth1-2.15.0.tar.gz"
    sha256 "52f387d35e2a2ba456427fb92b43631fc884173d77e76ba4d276f3938cd83a84"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "mega.py" do
    url "https://files.pythonhosted.org/packages/13/d2/cbbc5d21f2281fb59e27085c98b33bc93616be314b6fda5ad5d1955136ac/mega.py-0.9.18.tar.gz"
    sha256 "f3e15912ce2e5de18e31e7abef8a819a5546c184aa09586bfdaa42968cc827bf"
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

  resource "ndg-httpsclient" do
    url "https://files.pythonhosted.org/packages/a2/a7/ad1c1c48e35dc7545dab1a9c5513f49d5fa3b5015627200d2be27576c2a0/ndg_httpsclient-0.4.2.tar.gz"
    sha256 "580987ef194334c50389e0d7de885fccf15605c13c6eecaabd8d6c43768eb8ac"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/7c/ec/104f193e985e0aa813ffb4ba5da78d6ae3200165bf583d522ac2dc40aab2/netaddr-0.7.18.tar.gz"
    sha256 "a1f5c9fcf75ac2579b9995c843dade33009543c04f218ff7c007b3c81695bd19"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a7/4c/8e0771a59fd6e55aac993a7cc1b6a0db993f299514c464ae6a1ecf83b31d/netifaces-0.10.5.tar.gz"
    sha256 "59d8ad52dd3116fcb6635e175751b250dc783fb011adba539558bd764e5d628b"
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

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/d3/51/900b3b68bb948ffc0eb13cd4d8dc6041f38b7e69abeec7afbeeaf21501c6/oslo.config-3.19.0.tar.gz"
    sha256 "73bf513a94f5d91b393e415cf99e1368cf49c90dfccf86c9d834be99d8ece0f0"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/be/51/45cebdb4a95124a6e7fa704f9c8d2deaa5f0a2d067e294742b8c8d21e351/oslo.i18n-3.10.0.tar.gz"
    sha256 "eb55cb3c1bdb4d8ff0eee70561244f412d539e505ad52e324c7be6ebd74c616f"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/d2/ee/f6132ba8b3a31c811bfad4d49606d651aa2ac4543456891a873cebf9ffca/oslo.serialization-2.14.0.tar.gz"
    sha256 "533a353ced83d65e8c9d59b81fa10aeae267ca47b117b490bdf74fb6f0a62354"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/8e/c0/b152d17300f444ca555f88c2f2048099c802ffa910bfd57e4fef79811b1c/oslo.utils-3.18.0.tar.gz"
    sha256 "aec779132f7bb59dc12a941550fa1bb142149276722e1a96ce601e536bcd9b4b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c6/70/bb32913de251017e266c5114d0a645f262fb10ebc9bf6de894966d124e35/packaging-16.8.tar.gz"
    sha256 "5d50835fdf0a7edf0b55e311b7c887786504efea1177abd7e69329a8e5ea619e"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/6b/4e/971b8c917456a2ec9666311f7e695493002a64022397cd668150b5efd2a8/paramiko-2.0.2.tar.gz"
    sha256 "411bf90fa22b078a923ff19ef9772c1115a0953702db93549a2848acefd141dc"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/c3/2c/63275fab26a0fd8cadafca71a3623e4d0f0ee8ed7124a5bb128853d178a7/pbr-1.10.0.tar.gz"
    sha256 "186428c270309e6fdfe2d5ab0949ab21ae5f7dea831eab96701b86bd666af39c"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/83/73/1e2c630d868b73ecdea381ad7b081bc53888c07f1f9829699d277a2859a8/positional-1.1.1.tar.gz"
    sha256 "ef845fa46ee5a11564750aaa09dd7db059aaf39c44c901b37181e5ffa67034b0"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/db/d7/b465161910f3d1cef593c5e002bff67e0384898f597f1a7fdc8db4c02bf6/ptyprocess-0.5.1.tar.gz"
    sha256 "0530ce63a9295bfae7bd06edc02b6aa935619f486f0f1dc0972f516265ee81a6"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/0c/d6/b1fe519846a21614fa4f8233361574eddb223e0bc36b182140d916acfb3b/pyOpenSSL-16.2.0.tar.gz"
    sha256 "7779a3bbb74e79db234af6a08775568c6769b5821faecf6e2f4143edb227516e"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/f7/83/377e3dd2e95f9020dbd0dfd3c47aaa7deebe3c68d3857a4e51917146ae8b/pyasn1-0.1.9.tar.gz"
    sha256 "853cacd96d1f701ddd67aa03ecc05f51890135b7262e922710112f12a2ed2a7f"
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

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/b8/00/3b456dc8423f6f6a1b9b07c92c487809307a13dee83d22edb524b6f024b4/pyrax-1.9.8.tar.gz"
    sha256 "e9db943447fdf2690046d7f98466fc4743497b74578efe6e400a6edbfd9728f5"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/bb/3f/8fef032b60c8392d2d6646b115b938229c8d447bcbd33e4791a0fa3c8eb5/python-keystoneclient-3.6.0.tar.gz"
    sha256 "9b02364926323b14760719f7162fc38a99b9d2acb7241298a991023c87ad91b0"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/ac/10/aa4d81bb5ceac249b7facf86d021b7008a138b447ca9cbf09557fca61046/python-novaclient-2.27.0.tar.gz"
    sha256 "d1279d5c2857cf8c56cb953639b36225bc1fec7fa30ee632940823506a7638ef"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/d9/7f/4e6e49f4946adb22bbd4b015cc18b3f1606f8fa0a679cef010b1e52929d4/python-swiftclient-3.1.0.tar.gz"
    sha256 "7bb5984862b85ba2a18c16b4dc6af2fd14272871ad165eec47e9da111ab3fb9a"
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
    url "https://files.pythonhosted.org/packages/b6/61/7b374462d5b6b1d824977182db287758d549d8680444bad8d530195acba2/requests-2.12.5.tar.gz"
    sha256 "d902a54f08d086a7cc6e58c20e2bb225b1ae82c19c35e5925269ee94fb9fce00"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/17/b6/f2d5df2e369142010fb5d91b12a962643e1a2d3578b04ff22276a5c53238/rfc3986-0.4.1.tar.gz"
    sha256 "5ac85eb132fae7bbd811fa48d11984ae3104be30d44d397a351d004c633a68d2"
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
    url "https://files.pythonhosted.org/packages/d4/19/59008484543224f5ae9ca3940f6245b204102bc1080e9a5455066d3aabec/stevedore-1.18.0.tar.gz"
    sha256 "992f5d3c77a17ac283dc62626ff7bb24042e9c54bec2977395b45539f5d2aeb9"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/19/2f/b1090ace275335a9c0dde9a4623b109b7960a2b5370ae59d1eb1539afd8a/typing-3.5.2.2.tar.gz"
    sha256 "2bce34292653af712963c877f3085250a336738e64f99048d1b8509bebc4772f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/08/37/48b443a36af9eda6274f673b70a9140c13e2409edb2ef20b2d8a620efef5/urllib3-1.19.tar.gz"
    sha256 "87f362d061184191d07ced0b947d8526f3e1884f21b0fe97fab313dedcb895be"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/00/dd/dc22f8d06ee1f16788131954fc69bc4438f8d0125dd62419a43b86383458/wrapt-1.10.8.tar.gz"
    sha256 "4ea17e814e39883c6cf1bb9b0835d316b2f69f0f0882ffe7dad1ede66ba82c73"
  end

  def install
    virtualenv_install_with_resources
    inreplace Dir[bin/"*"], %r{^#!/usr/bin/env python.*$},
                            "#!#{libexec}/bin/python"
    man1.install Dir[libexec/"share/man/man1/*"]
  end

  test do
    Gpg.create_test_key(testpath)
    (testpath/"test/hello.txt").write "Hello!"
    (testpath/"command.sh").write <<-EOS.undent
      #!/usr/bin/expect -f
      set timeout -1
      spawn #{bin}/duplicity #{testpath} "file://test"
      expect -exact "Local and Remote metadata are synchronized, no sync needed."
      expect -exact "Last full backup date: none"
      expect -exact "GnuPG passphrase:"
      send -- "brew\n"
      expect -exact "Retype passphrase to confirm:"
      send -- "brew\n"
      expect -exact "No signatures found, switching to full backup."
      expect eof
    EOS
    chmod 0755, testpath/"command.sh"
    system "./command.sh"
    assert_match "duplicity-full-signatures", Dir["test/*"].to_s

    # Ensure requests[security] is activated
    script = "import requests as r; r.get('https://mozilla-modern.badssl.com')"
    system libexec/"bin/python", "-c", script
  end
end
