class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/58/04/77e6b898346584df8b1e7206cf9f9a0f7f7d0c773a4015ed16a12dd6b97e/python-openstackclient-6.2.0.tar.gz"
  sha256 "7c53abe1b73b453f59da7b73679c3b759b48e51b8b054864b5fdea2ea82727d6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "216aa2134d03c439796c960a8050fb2e267e74fd5d817ded79991d4cd27ab550"
    sha256 cellar: :any,                 arm64_monterey: "49071cb473934fca3da6f671742870c8b9b348eaf9617928a0c52c4e4dc4bc84"
    sha256 cellar: :any,                 arm64_big_sur:  "fa61ba782830d8ff475101dd50b593df38e3493f43cd14cd98777ecc6e50f5cd"
    sha256 cellar: :any,                 ventura:        "40f5dd1589bb2d4328a335b14fa3e5e18ee50aba0a1388bdb8e5f50f4c955aaa"
    sha256 cellar: :any,                 monterey:       "11ab0cf7803452fa5bb3bd0bc6dc073bcd3abf9cc24ed8065d81ba0bc08eda88"
    sha256 cellar: :any,                 big_sur:        "888444d1d2076a87b0084629bca8f314a461721fb8382f430662b7280dd03f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8e9377f847affb2f27c1adcd22e5c82ed316de3603947b2a60442acc45faf95"
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
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/36/b1/e5a1c2ebeb64ccc9c2a4ae133f5955d9824482628ed4bf0331c73323f0de/autopage-0.5.1.tar.gz"
    sha256 "01be3ee61bb714e9090fcc5c10f4cf546c396331c620c6ae50a2321b28ed3199"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/ba/42/54426ba5d7aeebde9f4aaba9884596eb2fe02b413ad77d62ef0b0422e205/Babel-2.12.1.tar.gz"
    sha256 "cc2d99999cd01d44420ae725a21c9e3711b3aadc7976d6147f622d8581963455"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/fe/6b/f9b689bef6ec161cb96a9f863fde77079c7edeb4cf5fa33561ee3ec22a61/cliff-4.2.0.tar.gz"
    sha256 "97fc31e93552e3bec664be9d55ad7f90dc2ab42aad8df29a5b985b644c9b8cf2"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
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
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
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
    url "https://files.pythonhosted.org/packages/2a/3c/6b7882c3f16acdc0321d538db8d4dc79846e7fe93c1729926e91e6512261/keystoneauth1-5.1.2.tar.gz"
    sha256 "d9f7484ad5fc9b0bbb7ecc3cbf3795a170694fbd848251331e54ba48bbeecc72"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
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
    url "https://files.pythonhosted.org/packages/94/47/76d19285d0f4a631c1b01bec39f4cccb7fc613d23bcd5a2785012346a290/openstacksdk-1.0.1.tar.gz"
    sha256 "365e5dcca64e16e74a4f9f9d2a1f2207970e946d9a5c482549cfa5ec02ca2c98"
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
    url "https://files.pythonhosted.org/packages/c9/1a/29836591c14ac7e41bc83996e58b4bc3f9d20d9b14f342775f6e8d819347/osc-lib-2.7.0.tar.gz"
    sha256 "b6263ff5d03b47f243fafc96a02b0a9558dc706bc609d7e52a7070cd6a27b000"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/c2/f1/9012e248ca4a53d64aa2db2a9aad1c38861ec77237a149a521d00cf95c0a/oslo.config-9.1.1.tar.gz"
    sha256 "b07654b53d87792ae8e739962ad729c529c9938a118d891ece9ee31d59716bc9"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/bc/ea/a81a65b2b322d7f71bb5764c7fb61f9636fbc1f8291e4984e8d3b1a1ab0e/oslo.context-5.1.1.tar.gz"
    sha256 "2f2e79171044efd1807c55713ed2c7f4068b18d73d027819165c4819b287cfaf"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/52/7a/655c1c95666d30400d59612a67f510a5395d821f7ae9e306b3fa2a2102e0/oslo.i18n-6.0.0.tar.gz"
    sha256 "ed10686b75f7c607825177a669155f4e259ce39f6143a375f6359bbcaa4a35cd"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/46/9b/0bed0585d484b4da92278a572803db4bd9f056b907ea6dbcdc7220b5fdc9/oslo.log-5.1.0.tar.gz"
    sha256 "f6ac37af95918e05d7a1dd7d0b0552ba8b22b2e430862eb336de592d25c84f29"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/57/7c/fb7ac9b6fd5137763bb1265c85134decfbe3c6a3ee398e1a4b70a8183bad/oslo.serialization-5.1.1.tar.gz"
    sha256 "8abbda8b1763a06071fc28c5d8a9be547ba285f4830e68a70ff88fe11f16bf43"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/f7/49/7f6790af38e9ce1a1418dd74c7d07492d711384269b1cecc69bef136b033/oslo.utils-6.1.0.tar.gz"
    sha256 "76bc0108d50aca972b68fec8298e791b5fbcbeb9a51a27c6986b41b0a6a62eeb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/02/d8/acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817/pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ba/b6/8e78337766d4c324ac22cb887ecc19487531f508dbf17d922b91492d55bb/prettytable-3.6.0.tar.gz"
    sha256 "2e0026af955b4ea67b22122f310b90eae890738c08cb0458693a49b6221530ac"
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
    url "https://files.pythonhosted.org/packages/65/9e/00a4c9687423ebfc7d1dc1ae9cf3f77a431528d9cc183a2c5ba898c9bff7/python-cinderclient-9.3.0.tar.gz"
    sha256 "9a6aa30feff48c0c0fd188e6d5150dbdd91e3fd5b10d2db9d78b9812ab14af88"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/21/a3/03ba1273b5576fe0006233e5f4bed246a74bffbb7dae10ed4ca7e139d92f/python-heatclient-3.2.0.tar.gz"
    sha256 "2d88d18c3799a7b2d07901572e88321b2e0b1206b04d0103fb9a91bbbf7db563"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/bb/57/f59abb588eb28c1b5a8432e3163a2135183672e2dceb747aed0b26f3db01/python-keystoneclient-5.1.0.tar.gz"
    sha256 "ba09bdfeafa2a2196450a327cd3f46f2a8a9dd9d21b838f8cb9b17a99740c6a1"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/ef/e4/107865bfbdd8153e15431e2fb9988a29b69de5558b928fd4a4671ceed972/python-neutronclient-9.0.0.tar.gz"
    sha256 "a4062d10052940b31dbeb4479c99de4281b32f343998177195a36860e2eb04db"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/d5/b7/f5e17da2e21a40f5e45b1d0d49044e02644e6e6d5492841b0b53ec985080/python-novaclient-18.3.0.tar.gz"
    sha256 "50f7587c7a2b2528f73505817f9437ac5c1d04d576e9be264d2deeffdb745a76"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/d8/00/9c96f125090e87536ff8657b19948707abfc988963eabbdf8d581445c122/python-octaviaclient-3.4.0.tar.gz"
    sha256 "da96e0a9c746ec707cfab8292bb1e7d98d2ca6e970dd17b4864b8d76189e1997"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/5a/90/ea9381f2cab0212f51e22d948953f3d626b33288cc4fa386ad0371e5edf1/python-swiftclient-4.2.0.tar.gz"
    sha256 "a3f627ce9fb54b57d30fdb41dc305bd5e60533eeb69ae79e496ad4ec5e848c85"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
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
    url "https://files.pythonhosted.org/packages/b1/86/a67f6f595c5da14fa80bb4a8f7084c391ac1bfd3208ea4906307afc2b181/simplejson-3.18.3.tar.gz"
    sha256 "ebb53837c5ffcb6100646018565d3f1afed6f4b185b14b2c9cbccf874fe40157"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/f1/25/993d09dc7be3e7927228853c75324104d734bb784bd766b025ebf9f47b16/stevedore-5.0.0.tar.gz"
    sha256 "2c428d2338976279e8eb2196f7a94910960d9f7ba2f41f3988511e95ca447021"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
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
