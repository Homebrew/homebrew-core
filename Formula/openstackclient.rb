class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/e7/7c/12bcf0aa9f564e5df663df93dacae6cbd67151df17c55f5f7d9640381a52/python-openstackclient-6.0.0.tar.gz"
  sha256 "91c3ac12da4b423c16b3917616f84a23e2961e750fce590d409ecc50ee0431ce"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "b3f851a97b9dd555314540d4fc0e04fa653318f45d49e32fc8292d008094999b"
    sha256 cellar: :any,                 arm64_monterey: "8418903ff38439bf797392bb5883cd876ce5bca1e7f690fd4aea3ca97bf66555"
    sha256 cellar: :any,                 arm64_big_sur:  "a77672b932ac3aba3d3ecbc16610ea9a34af9336a30dc3a1d3828f5918becf01"
    sha256 cellar: :any,                 ventura:        "c87a1d8a2838c27531046d9f1f6e17e517599db06e2fccf91d9dcf1813e8d77a"
    sha256 cellar: :any,                 monterey:       "fd428dae7e397eff176bf12b21e488351053ce740a3eb114295f371abeca66cb"
    sha256 cellar: :any,                 big_sur:        "c95d3a10609da60564e192fc99300159a2c310dd1686a37e92e66f0d2a2f334f"
    sha256 cellar: :any,                 catalina:       "93caa1f18daf27a0fb73d36aadc4145bc4976e7a79f4cf330c39cfa84a67a3d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c3dd6f55727a668439495e384656b13b6a8d4922593f7d6ec1a27b11c57455d6"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/36/b1/e5a1c2ebeb64ccc9c2a4ae133f5955d9824482628ed4bf0331c73323f0de/autopage-0.5.1.tar.gz"
    sha256 "01be3ee61bb714e9090fcc5c10f4cf546c396331c620c6ae50a2321b28ed3199"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/ff/80/45b42203ecc32c8de281f52e3ec81cb5e4ef16127e9e8543089d8b1649fb/Babel-2.11.0.tar.gz"
    sha256 "5ef4b3226b0180dedded4229651c8b0e1a3a6a2837d45a073272f313e4cf97f6"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/bc/62/f0d8dae6d425e3f681464aa2f85a31386d5f3ce854e7aed14f0622ce0dc4/cliff-4.0.0.tar.gz"
    sha256 "3b0d30e7acf50e3c214a39ee3e66aa2f2b5957e2a1de373e17bba8e98c7501a5"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/39/a0/830934f19f07e77c7d332fd5b41358611afc8d33d8cea78259b9a5d7f8ef/cmd2-2.4.2.tar.gz"
    sha256 "073e555c05853b0f6965f3d03329babdf9e38a5f2cea028e61a64cd7eeb74ad5"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/13/dd/a9608b7aebe5d2dc0c98a4b2090a6b815628efa46cc1c046b89d8cd25f4c/cryptography-38.0.3.tar.gz"
    sha256 "bfbe6ee19615b07a98b1d2287d6a6073f734735b49ee45b11324d85efc4d5cbd"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/c8/7d/904f64535d04f754c20a02a296de0bf3fb02be8ff5274155e41c89ae211a/debtcollector-2.5.0.tar.gz"
    sha256 "dc9d1ad3f745c43f4bbedbca30f9ffe8905a8c028c9926e61077847d5ea257ab"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/e4/11/c5c200e774fb6cca03288c25cdb600fb8c41f2ace38a7ebfedfd3de3c3e1/dogpile.cache-1.1.8.tar.gz"
    sha256 "d844e8bb638cc4f544a4c89a834dfd36fe935400b71a16cbd744ebdfb720fd4e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/7e/ec/97f2ce958b62961fddd7258e0ceede844953606ad09b672fa03b86c453d3/importlib_metadata-5.0.0.tar.gz"
    sha256 "da31db32b304314d044d3c12c79bd59e307889b287ad12ff387b3500835fc2ab"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/31/8c/1c342fdd2f4af0857684d16af766201393ef53318c15fa785fcb6c3b7c32/iso8601-1.1.0.tar.gz"
    sha256 "32811e7b81deee2063ea6d2e94f8819a86d1f3811e49d23623a41fa832bef03f"
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

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/07/41/a4b8d724a8bff89c55be8787afcaa68f60b0fc9bbab639bc7c0ed24a7a1a/keystoneauth1-5.0.0.tar.gz"
    sha256 "6ebb5f044c9dfd263087a328d51d479947d1ddc90c09daf4191df7dc71334323"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/22/44/0829b19ac243211d1d2bd759999aa92196c546518b0be91de9cacc98122a/msgpack-1.0.4.tar.gz"
    sha256 "f5d869c18f030202eb412f08b28d2afeea553d6613aee89e200d7aca7ef01f5f"
  end

  resource "munch" do
    url "https://files.pythonhosted.org/packages/43/a1/ec48010724eedfe2add68eb7592a0d238590e14e08b95a4ffb3c7b2f0808/munch-2.5.0.tar.gz"
    sha256 "2d735f6f24d4dba3417fa448cae40c6e896ec1fdab6cdb5e6510999758a4dbd2"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/c3/3b/fe5bda7a3e927d9008c897cf1a0858a9ba9924a6b4750ec1824c9e617587/netaddr-0.8.0.tar.gz"
    sha256 "d6cc57c7a07b1d9d2e917aa8b36ae8ce61c35ba3fcd1b83ca31c5a0ee2b5a243"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/ab/bd/f784962a2fe463e036b9159b98c5df0731a03369c3f19543507bf3499871/openstacksdk-0.102.0.tar.gz"
    sha256 "b2a18feba79eac2ac3469c8dafe01d4008c8ac30be3a4c6b53275b4f1c6ba2ad"
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
    url "https://files.pythonhosted.org/packages/87/ea/06418a0b00ffc10577ba8c840c6ab05ca542ee2d5bb1078789c68d12c918/osc-lib-2.6.2.tar.gz"
    sha256 "879b6c5a142f3294464748ab14adde0cba0a14a5f704a0d840c9e92144489dba"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/c0/b0/e6c8f1a543978b6909e1a8b733eb8e5e7b8ede2b29f7e83c8638169eae36/oslo.config-9.0.0.tar.gz"
    sha256 "3b6b63c43cf1e09344ba850bcb11d6f2b9201086fbeb0a97a8950e7eac3f2645"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/96/e1/7bac157e4a828b1d64510ba0b4362a74b4c68ecc8c8588d6d22145b0f4a8/oslo.context-5.0.0.tar.gz"
    sha256 "88c0c6d076681c60d560f7d66565e42ac116c5aa8a28a04db7c0ac0025133224"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/7c/d8/a56cdadc3eb21f399327c45662e96479cb73beee0d602769b7847e857e7d/oslo.i18n-5.1.0.tar.gz"
    sha256 "6bf111a6357d5449640852de4640eae4159b5562bbba4c90febb0034abc095d0"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/4e/f0/163eb0aeb4a8c281a0e977b6cfb2cacdd4861478cb1d67a6c5a2b0ad5e23/oslo.log-5.0.1.tar.gz"
    sha256 "fb65f2f9d24423fa6dd6ead8ecd21f665c62e0fd9f90bf311e4c153b5f8ab7ea"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/c0/00/166651f281396a57d5342f1d8be772c7f54bbb128b6753ee8bf3943ad7e6/oslo.serialization-5.0.0.tar.gz"
    sha256 "2845328d0f47dc8a23fed2a82253e90acff0aa731dbd24f379cf8e50e6cc66ba"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/99/5e/6f1b242ab4eb6ebe6055b1e2adb45cdedee3a3ab425c4a4ac406615bb9f5/oslo.utils-6.0.1.tar.gz"
    sha256 "9b0454f99415d0caac5c86053716d746d198ecec66e672d8e5e6386b6fbaa2b6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/52/fb/630d52aaca8fc7634a0711b6ae12a0e828b6f9264bd8051225025c3ed075/pbr-5.11.0.tar.gz"
    sha256 "b97bc6695b2aff02144133c2e7399d5885223d42b7912ffaec2ca3898e673bfe"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/51/d8/f4739a1971029c00fdb97c9ea4abbfb20ea041f6aa7613343f12a468e217/prettytable-3.5.0.tar.gz"
    sha256 "52f682ba4efe29dccb38ff0fe5bac8a23007d0780ff92a8b85af64bc4fc74d72"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/96/37/9d22c1e3f9a1ecfe3aa2ecb94ebd06d8b9f0e2131095e0dbe2115083fee8/python-cinderclient-9.1.0.tar.gz"
    sha256 "f9b30af2e6e6e5a126c2c81f35145c5aee70c20955e6dd409919be4d1b87b343"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/ec/a4/79af46d8213e0a70c768a35cc4ec9eb06a854baf4bf61488da1e9e643684/python-heatclient-3.1.0.tar.gz"
    sha256 "fd25bc8518f9f3c37efb80aecfb7a56d4d2a3befb82619b5bdad3af499cd999a"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/a0/dd/81d3d89231a09445e4b2a13a374aeed8f3abb82ff7c0ecb5da87bebb6790/python-keystoneclient-5.0.1.tar.gz"
    sha256 "a8bbf671f56c24aa5a37a225b98f2994b82063d73e3486657eb500a33a406d29"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/53/46/ab02d8ee6537409357b123560307b95a7fea115b9b81cfc37b0a13fc0806/python-neutronclient-8.1.0.tar.gz"
    sha256 "2ddb1c06109521641b020bb3b8a521a41fd59e1b4771eaac7585ec31422a1471"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/3a/99/ad7eb52f02dbae71b84c9951f9911545f331474e9d9c5da03d6a82017a6a/python-novaclient-18.1.0.tar.gz"
    sha256 "7820559d165f1a4d810e7da7c95f88425d8be495f6d1a3c6f4203b8ac187e254"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/b4/a4/362d4c68a094e6d09be8970f0898e32397178d1939d513a8e86ff49a5dcc/python-octaviaclient-3.1.0.tar.gz"
    sha256 "c46e361520a41c0383680a0dcf15ea0da20a5904e63081dc9a7b4a659909da2e"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/93/bc/e9fa2d72443623df0561d86f576aeadc1cd95a8dfe551d2724c4f6da2552/python-swiftclient-4.1.0.tar.gz"
    sha256 "f82298e4a48f7cbdd680f2638c85d1ca7ae1a76edbe30036d21b4cd7a29c09eb"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/76/63/1be349ff0a44e4795d9712cc0b2d806f5e063d4d34631b71b832fac715a8/pytz-2022.6.tar.gz"
    sha256 "e89512406b793ca39f5971bc999cc538ce125c0e51c27941bef4568b460095e2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/7a/47/c7cc3d4ed15f09917838a2fb4e1759eafb6d2f37ebf7043af984d8b36cf7/simplejson-3.17.6.tar.gz"
    sha256 "cf98038d2abf63a1ada5730e91e84c642ba6c225b0198c3684151b1f80c5f8a6"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/66/c0/26afabea111a642f33cfd15f54b3dbe9334679294ad5c0423c556b75eba2/stevedore-4.1.1.tar.gz"
    sha256 "7f8aeb6e3f90f96832c301bff21a7eb5eefbe894c88c506483d355565d88cc1a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/8d/d7/1bd1e0a5bc95a27a6f5c4ee8066ddfc5b69a9ec8d39ab11a41a804ec8f0d/zipp-3.10.0.tar.gz"
    sha256 "7a7262fd930bd3e36c50b9a64897aec3fafff3dfdeec9623ae22b40e93f99bb8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "stack list",
      "loadbalancer list",
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
