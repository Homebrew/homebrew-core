class Duplicity < Formula
  include Language::Python::Virtualenv

  desc "Bandwidth-efficient encrypted backup"
  homepage "http://www.nongnu.org/duplicity/"
  url "https://launchpad.net/duplicity/0.7-series/0.7.13.1/+download/duplicity-0.7.13.1.tar.gz"
  sha256 "adb8668fb10e0b0f91cb77f758d02c02bf5c02e6c4835904a82cbdab6db4bef2"

  bottle do
    cellar :any
    sha256 "def58ea614b08ba8523625055e8b5511926c16981f79335f6000812e7e04ed81" => :sierra
    sha256 "9178ba9dfa97f2ca0278c049042e13fff0d14acad766a67f6cf59a63b04acd3b" => :el_capitan
    sha256 "1e9e1b4798d9a834a8517b066f61cf5423fac3416b918050ca3e5315ef952379" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "librsync"
  depends_on "openssl@1.1"
  depends_on "par2" => :optional
  depends_on :gpg => :run

  # Generated with homebrew-pypi-poet from
  # for i in azure-storage boto pyrax dropbox fasteners kerberos mega.py
  # paramiko pexpect pycrypto pycryptopp python-swiftclient python-keystoneclient
  # requests requests-oauthlib; do poet -r $i >> resources; done
  # Additional dependencies of requests[security] should also be installed:
  #   ndg-httpsclient, pyOpenSSL

  # must be installed early
  resource "pytz" do
    url "https://files.pythonhosted.org/packages/a4/09/c47e57fc9c7062b4e83b075d418800d322caa87ec0ac21e6308bd3a2d519/pytz-2017.2.zip"
    sha256 "f5c056e8f62d45ba8215e5cb8f50dfccb198b4b9fbea8500674f3443e4689589"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/6e/96/ba2a2462ed25ca0e651fb7b66e7080f5315f91425a07ea5b34d7c870c114/Babel-2.3.4.tar.gz"
    sha256 "c535c4403802f6eb38173cd4863e419e2274921a01a8aad8a5b497c131c62875"
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

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/67/14/5d66588868c4304f804ebaff9397255f6ec5559e46724c2496e0f26e68d6/asn1crypto-0.22.0.tar.gz"
    sha256 "cbbadd640d3165ab24b06ef25d1dca09a3441611ac15f6a6b452474fdf0aed1a"
  end

  resource "azure-common" do
    url "https://files.pythonhosted.org/packages/85/76/8809248c38bf1c994f40bc07cf3a17dec0aa00ba0915f159c904b040893e/azure-common-1.1.8.zip"
    sha256 "25559617b41fe0902f34b215a3440a3ffa4862fe442bf351415be0e1d2eb4289"
  end

  resource "azure-storage" do
    url "https://files.pythonhosted.org/packages/94/12/a6226245f5b2512048c38ca739d56a85100c32d4d94d29e0f3223cfd4a82/azure-storage-0.35.1.tar.gz"
    sha256 "6818b6a8f68c0a6e8afec8881b833afbf206b5f669b1c2dbd6ee731bf02b157b"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/58/e9/6d7f1d883d8c5876470b5d187d72c04f2a9954d61e71e7eb5d2ea2a50442/bcrypt-3.1.3.tar.gz"
    sha256 "6645c8d0ad845308de3eb9be98b6fd22a46ec5412bfc664a423e411cdd8f5488"
  end

  resource "boto" do
    url "https://files.pythonhosted.org/packages/66/e7/fe1db6a5ed53831b53b8a6695a8f134a58833cadb5f2740802bc3730ac15/boto-2.48.0.tar.gz"
    sha256 "deb8925b734b109679e3de65856018996338758f4b916ff4fe7bb62b6d7000d1"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/20/d0/3f7a84b0c5b89e94abbd073a5f00c7176089f526edb056686751d5064cbd/certifi-2017.7.27.1.tar.gz"
    sha256 "40523d2efb60523e113b44602298f0960e900388cf3bb6043f645cf57ea9e3f5"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/5b/b9/790f8eafcdab455bcd3bd908161f802c9ce5adbf702a83aa7712fcc345b7/cffi-1.10.0.tar.gz"
    sha256 "b3b02911eb1f6ada203b0763ba924234629b51586f72a21faacc638269f4ced5"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/fc/bb/a5768c230f9ddb03acc9ef3f0d4a3cf93462473795d18e9535498c8f929d/chardet-3.0.4.tar.gz"
    sha256 "84ab92ed1c4d4f16916e05906b6b75a6c0fb5db821cc65e70cbd64a3e2a5eaae"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/9c/1a/0fc8cffb04582f9ffca61b15b0681cf2e8588438e55f61403eb9880bd8e0/cryptography-2.0.3.tar.gz"
    sha256 "d04bb2425086c3fe86f7bc48915290b13e798497839fbb18ab7f6dffcf98cc3a"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/03/53/55f00f682f3e692a85be2bf4e227a77f67f6e504d9f505e0423590bdefa6/debtcollector-1.17.0.tar.gz"
    sha256 "71e3350b6b97acede200f30b3858749b21303a70fde4ded26e4cbe599a3b0466"
  end

  resource "dropbox" do
    url "https://files.pythonhosted.org/packages/1f/7d/6e90b169fe4142b3b2332fd22d2aecfdc971e42eef19ea1c50b2384067f2/dropbox-6.9.0.tar.gz"
    sha256 "db1be6dab980f6819508c9f70d2c82b32aad4b7f5f0c52354fdb48ca4abdee49"
  end

  resource "enum34" do
    url "https://files.pythonhosted.org/packages/bf/3e/31d502c25302814a7c2f1d3959d2a3b3f78e509002ba91aea64993936876/enum34-1.1.6.tar.gz"
    sha256 "8ad8c4783bf61ded74527bffb48ed9b54166685e4230386a9ed9b1279e2df5b1"
  end

  resource "fasteners" do
    url "https://files.pythonhosted.org/packages/f4/6f/41b835c9bf69b03615630f8a6f6d45dafbec95eb4e2bb816638f043552b2/fasteners-0.14.1.tar.gz"
    sha256 "427c76773fe036ddfa41e57d89086ea03111bbac57c55fc55f3006d027107e18"
  end

  resource "funcsigs" do
    url "https://files.pythonhosted.org/packages/94/4a/db842e7a0545de1cdb0439bb80e6e42dfe82aaeaadd4072f2263a4fbed23/funcsigs-1.0.2.tar.gz"
    sha256 "a7bb0f2cf3a3fd1ab2732cb49eba4252c2af4240442415b4abce3b87022a8f50"
  end

  resource "futures" do
    url "https://files.pythonhosted.org/packages/cc/26/b61e3a4eb50653e8a7339d84eeaa46d1e93b92951978873c220ae64d0733/futures-3.1.1.tar.gz"
    sha256 "51ecb45f0add83c806c68e4b06106f90db260585b25ef2abfcda0bd95c0132fd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f4/bd/0467d62790828c23c47fc1dfa1b1f052b24efdf5290f071c7a91d0d82fd3/idna-2.6.tar.gz"
    sha256 "2c6a5de3089009e3da7c5dde64a141dbc8551d5b7f6cf4ed7c2568d0cc520a8f"
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
    url "https://files.pythonhosted.org/packages/45/13/3db24895497345fb44c4248c08b16da34a9eb02643cea2754b21b5ed08b0/iso8601-0.1.12.tar.gz"
    sha256 "49c4b20e1f38aa5cf109ddcd39647ac419f928512c869dc01d5c7098eddede82"
  end

  resource "kerberos" do
    url "https://files.pythonhosted.org/packages/46/73/1e7520780a50c9470aeba2b3c020981201c8662b618fb2889a3e3dc2aeed/kerberos-1.2.5.tar.gz"
    sha256 "b32ae66b1da2938a2ae68f83d67ce41b5c5e3b6c731407104cd209ba426dadfe"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/37/0c/034139cd798dac3ceb4fcb4ed85e20c27f3e579c25cdaf066aad1552da3d/keyring-10.4.0.tar.gz"
    sha256 "901a3f4ed0dfba473060281b58fd3b649ce70f59cb34a9cf6cb5551218283b26"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/60/84/563732a068310ee9a8c3626a037efea22b3a926431d91f1ec991db89a70e/keystoneauth1-3.1.0.tar.gz"
    sha256 "e5abfa8bbe866d52ca56afbe528d15214a60033cc1dc9804478cae7424f0f8fb"
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
    url "https://files.pythonhosted.org/packages/96/b3/3e9fa0bdf132a971571cbf0e3f0c8b38834f4f7af8ca9523794f4f5895e0/monotonic-1.3.tar.gz"
    sha256 "2b469e2d7dd403f7f7f79227fe5ad551ee1e76f8bb300ae935209884b93c7c1b"
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
    url "https://files.pythonhosted.org/packages/0c/13/7cbb180b52201c07c796243eeff4c256b053656da5cfe3916c3f5b57b3a0/netaddr-0.7.19.tar.gz"
    sha256 "38aeec7cdd035081d3a4c306394b19d677623bf76fa0913f6695127c7753aefd"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/72/01/ba076082628901bca750bf53b322a8ff10c1d757dc29196a8e6082711c9d/netifaces-0.10.6.tar.gz"
    sha256 "0c4da523f36d36f1ef92ee183f2512f3ceb9a9d2a45f7d19cda5a42c6689ebe0"
  end

  resource "oauthlib" do
    url "https://files.pythonhosted.org/packages/fa/2e/25f25e6c69d97cf921f0a8f7d520e0ef336dd3deca0142c0b634b0236a90/oauthlib-2.0.2.tar.gz"
    sha256 "b3b9b47f2a263fe249b5b48c4e25a5bce882ff20a0ac34d553ce43cff55b53ac"
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
    url "https://files.pythonhosted.org/packages/ff/86/51b3b2a094129fc70723d64d0784b4a6e5f4be97749e314ec394d2e8ec26/oslo.config-4.11.0.tar.gz"
    sha256 "1be8aaba466a3449fdb21ee8f7025b0d3d252c8c7568b8d5d05ceff58617cd05"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/37/6b/1a9ff9451a1de4b9b140d05b0bf7db2fa551d099aaa7a630e26c41806d68/oslo.i18n-3.17.0.tar.gz"
    sha256 "168b8c06f03599ac8172eb87112b5054e46bf421db03c367c059e3110d98ad31"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/e6/e8/00de1a1786b397ec82c971a0c650b8961d6d2011332b05edad7323128b19/oslo.serialization-2.20.0.tar.gz"
    sha256 "fca6fbb350d560aab8a4fdc9a1128dac3b1d38b2fc9bf5ad22136ae090854802"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/19/ea/3743c0405e50d9d18ac57c74830526a18474a7024d4d677c2580983769ea/oslo.utils-3.28.0.tar.gz"
    sha256 "46abd731d8cfdb682eb5b1d22a2da3c549d79f889bd3db998eac4b64a955769f"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/d1/0b/c8bc96c79bbda0bcc9f2912389fa59789bb8e7e161f24b01082b4c3f948d/paramiko-2.2.1.tar.gz"
    sha256 "ff94ae65379914ec3c960de731381f49092057b6dd1d24d18842ead5a2eb2277"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/d5/d6/f2bf137d71e4f213b575faa9eb426a8775732432edb67588a8ee836ecb80/pbr-3.1.1.tar.gz"
    sha256 "05f61c71aaefc02d8e37c0a3eeb9815ff526ea28b3b76324769e6158d7f95be1"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e8/13/d0b0599099d6cd23663043a2a0bb7c61e58c6ba359b2656e6fb000ef5b98/pexpect-4.2.1.tar.gz"
    sha256 "3d132465a75b57aa818341c6521392a06cc660feb3988d7f1074f39bd23c9a92"
  end

  resource "positional" do
    url "https://files.pythonhosted.org/packages/24/7e/3b1450db76eb48a54ea661a43ae00950275e11840042c5217bd3b47b478e/positional-1.2.1.tar.gz"
    sha256 "cf48ea169f6c39486d5efa0ce7126a97bed979a52af6261cf255a41f9a74453a"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/51/83/5d07dc35534640b06f9d9f1a1d2bc2513fb9cc7595a1b0e28ae5477056ce/ptyprocess-0.5.2.tar.gz"
    sha256 "e64193f0047ad603b71f202332ab5527c5e52aa7c8b609704fc28c0dc20c4365"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/b0/9e/7088f6165c40c46416aff434eb806c1d64ad6ec6dbc201f5ad4d0484704e/pyOpenSSL-17.2.0.tar.gz"
    sha256 "5d617ce36b07c51f330aa63b83bf7f25c40a0e95958876d54d1982f8c91b4834"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/17/a2/266818077dbd002d53ebe5aaaa05a04786256cea8dba1899ac0b832ef028/pyasn1-0.3.2.tar.gz"
    sha256 "90bd82e0db59d4319eaf01c2549b34c817d645275fce9ad41bac7429aa380690"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/8c/2d/aad7f16146f4197a11f8e91fb81df177adcc2073d36a17b1491fd09df6ed/pycparser-2.18.tar.gz"
    sha256 "99a8ca03e29851d96616ad0404b4aad7d9ee16f25c9f9708a11faf2810f7b226"
  end

  resource "pycrypto" do
    url "https://files.pythonhosted.org/packages/60/db/645aa9af249f059cc3a368b118de33889219e0362141e75d4eaf6f80f163/pycrypto-2.6.1.tar.gz"
    sha256 "f2ce1e989b272cfcb677616763e0a2e7ec659effa67a88aa92b3a65528f60a3c"
  end

  resource "pycryptopp" do
    url "https://files.pythonhosted.org/packages/7c/e2/7e035d306c7516c471802d7cd7b6c1e403e582489bc5c14706854a187a24/pycryptopp-0.7.1.869544967005693312591928092448767568728501330214.tar.gz"
    sha256 "08ad57a1a39b7ed23c173692281da0b8d49d98ad3dcc09f8cca6d901e142699f"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/3c/ec/a94f8cf7274ea60b5413df054f82a8980523efd712ec55a59e7c3357cf7c/pyparsing-2.2.0.tar.gz"
    sha256 "0832bcf47acd283788593e7a0f542407bd9550a55a8a8435214a1960e04bcb04"
  end

  resource "pyrax" do
    url "https://files.pythonhosted.org/packages/b8/00/3b456dc8423f6f6a1b9b07c92c487809307a13dee83d22edb524b6f024b4/pyrax-1.9.8.tar.gz"
    sha256 "e9db943447fdf2690046d7f98466fc4743497b74578efe6e400a6edbfd9728f5"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/54/bb/f1db86504f7a49e1d9b9301531181b00a1c7325dc85a29160ee3eaa73a54/python-dateutil-2.6.1.tar.gz"
    sha256 "891c38b2a02f5bb1be3e4793866c8df49c7d19baabf9c1bad62547e0b4866aca"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/a4/a8/b8a83375ee028a0bd28acfcbb9bba20ab27ae2e7e513553e0bc1b901a4e4/python-keystoneclient-3.13.0.tar.gz"
    sha256 "f897eaa6b251a12e5d23130e8435fb5d2ead6f7ea1d1d20faf2ccc1c76c51c90"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/ac/10/aa4d81bb5ceac249b7facf86d021b7008a138b447ca9cbf09557fca61046/python-novaclient-2.27.0.tar.gz"
    sha256 "d1279d5c2857cf8c56cb953639b36225bc1fec7fa30ee632940823506a7638ef"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/9a/a7/fa2e2def232d0c8b32677399f0381e3e6e602ce577e138fff57771a0b9e7/python-swiftclient-3.4.0.tar.gz"
    sha256 "54f7ae339bd076e295dd576ec98e55ba71205ee7e62964b27c8ec80c9351067d"
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
    url "https://files.pythonhosted.org/packages/b0/e1/eab4fc3752e3d240468a8c0b284607899d2fbfb236a56b7377a329aa8d09/requests-2.18.4.tar.gz"
    sha256 "9c443e7324ba5b85070c4a818ade28bfabedf16ea10206da1132edaa6dda237e"
  end

  resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/80/14/ad120c720f86c547ba8988010d5186102030591f71f7099f23921ca47fe5/requests-oauthlib-0.8.0.tar.gz"
    sha256 "883ac416757eada6d3d07054ec7092ac21c7f35cb1d2cf82faf205637081f468"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/4b/f6/8f0a24e50454494b0736fe02e6617e7436f2b30148b8f062462177e2ca2d/rfc3986-1.1.0.tar.gz"
    sha256 "8458571c4c57e1cf23593ad860bb601b6a604df6217f829c2bc70dc4b5af941b"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/08/48/c97b668d6da7d7bebe7ea1817a6f76394b0ec959cb04214ca833c34359df/simplejson-3.11.1.tar.gz"
    sha256 "01a22d49ddd9a168b136f26cac87d9a335660ce07aa5c630b8e3607d6f4325e7"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/b3/b2/238e2590826bfdd113244a40d9d3eb26918bd798fc187e2360a8367068db/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/08/58/e21f4691e8e75a290bdbfa366f06b9403c653642ef31f879e07f6f9ad7db/stevedore-1.25.0.tar.gz"
    sha256 "c8a373b90487b7a1b52ebaa3ca5059315bf68d9ebe15b2203c2fa675bd7e1e7e"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/ca/38/16ba8d542e609997fdcd0214628421c971f8c395084085354b11ff4ac9c3/typing-3.6.2.tar.gz"
    sha256 "d514bd84b284dd3e844f0305ac07511f097e325171f6cc4a20878d11ad771849"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ee/11/7c59620aceedcc1ef65e156cc5ce5a24ef87be4107c2b74458464e437a5d/urllib3-1.22.tar.gz"
    sha256 "cc44da8e1145637334317feebd728bd869a35285b93cbb4cca2577da7e62db4f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/a0/47/66897906448185fcb77fc3c2b1bc20ed0ecca81a0f2f88eda3fc5a34fc3d/wrapt-1.10.11.tar.gz"
    sha256 "d4d560d479f2c21e1b5443bbd15fe7ec4b37fe7e53d335d3b9b0a7b1226fe3c6"
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
