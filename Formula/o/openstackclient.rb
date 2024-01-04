class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/71/13/9556dd8c47b78a7542f5f9241f4798f66d1203b6fd5f069518f5cc51df3f/python-openstackclient-6.4.0.tar.gz"
  sha256 "0c6ab40168ea51fed68819aa251f8253de9a61dacc96dd1b64739f189fc2183f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "97fc78ab1accdefddf21f57ee75790e484e801bd6450db1a5061e34296ba2703"
    sha256 cellar: :any,                 arm64_ventura:  "a164801b9d2774db511b75e998abe4d68ff247dd3d6c511c283faf9ae2834d18"
    sha256 cellar: :any,                 arm64_monterey: "c07f59c868f1945baddac448377eaf5719f0b6f44f2f2b582103116b28cb107f"
    sha256 cellar: :any,                 sonoma:         "299eb6eadca07e23b9597f3b6e1bc0f3afe4de8ac42274c4625a6d3302171c8e"
    sha256 cellar: :any,                 ventura:        "785b21d4cff546341ebb12e9c678c4be5ae1c6730296576068c35d3c6259172d"
    sha256 cellar: :any,                 monterey:       "c1a0c33b7ac25e5fccb5370faa30ed10bbc2e9d4cfe2ab5fb62adbe95f086441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b90adebb8e94074513ed67e32ef633e0e8dd1a0ae14727f8144bbd396942390d"
  end

  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-certifi"
  depends_on "python-cryptography"
  depends_on "python-packaging"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/e3/fc/f800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650d/attrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
end
            
resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
end
            
resource "babel" do
    url "https://files.pythonhosted.org/packages/e2/80/cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7f/Babel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
end
            
resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
end
            
resource "cliff" do
    url "https://files.pythonhosted.org/packages/8a/31/0fe8226a7f6e0c99f9d850c3dc0f931c24f91daf0d742f3d5cb867d8d416/cliff-4.4.0.tar.gz"
    sha256 "aa8d404aa2d6b4d8639c61bd6dc47acb3656ebc3fc025b1b7bb07af2baef785f"
end
            
resource "cmd2" do
    url "https://files.pythonhosted.org/packages/13/04/b85213575a7bf31cbf1d699cc7d5500d8ca8e52cbd1f3569a753a5376d5c/cmd2-2.4.3.tar.gz"
    sha256 "71873c11f72bd19e2b1db578214716f0d4f7c8fa250093c601265a9a717dee52"
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
    url "https://files.pythonhosted.org/packages/26/31/03bb01f10fc326388c5637747aa0f63a29a740061ff187c871913b75e273/dogpile.cache-1.3.0.tar.gz"
    sha256 "0a387f1932c071ee8fd971d2ff51f8aba1106c559439a51b8c74a207f40e215d"
end
            
resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
end
            
resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/b4/206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84/importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
end
            
resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
end
            
resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
end
            
resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/42/78/18813351fe5d63acad16aec57f94ec2b70a09e53ca98145589e185423873/jsonpatch-1.33.tar.gz"
    sha256 "9fcd4009c41e6d12348b4a0ff2563ba56a2923a7dfee731d004e212e1ee5030c"
end
            
resource "jsonpath-rw" do
    url "https://files.pythonhosted.org/packages/71/7c/45001b1f19af8c4478489fbae4fc657b21c4c669d7a5a036a86882581d85/jsonpath-rw-1.4.0.tar.gz"
    sha256 "05c471281c45ae113f6103d1268ec7a4831a2e96aa80de45edc89b11fac4fbec"
end
            
resource "jsonpath-rw-ext" do
    url "https://files.pythonhosted.org/packages/d5/f0/5d865b2543be45e3ab7a8c2ae8dfa5c3e56cfdd48f19d4455eb02f370386/jsonpath-rw-ext-1.2.2.tar.gz"
    sha256 "a9e44e803b6d87d135b09d1e5af0db4d4cf97ba62711a80aa51c8c721980a994"
end
            
resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
end
            
resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/a8/74/77bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03aff/jsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
end
            
resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
end
            
resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/7a/28/0b760f26f0c33c48aec42003c8a9ea96b0bc409d7fb892593ee30f272a9f/keystoneauth1-5.4.0.tar.gz"
    sha256 "1ac134151ceb02e50b68ad78dec9821bf89fe53bd36fc8658501c47b07cbdf53"
end
            
resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
end
            
resource "murano-pkg-check" do
    url "https://files.pythonhosted.org/packages/a4/ef/efe83ae0d1d3fc339184cd4912841a11f589ddcf1996fcb5ed067ec57fa6/murano-pkg-check-0.3.0.tar.gz"
    sha256 "56d2c45cdaf3a51e0946e5701dfc76d38262d42c47d077680c2b56210acfd485"
end
            
resource "netaddr" do
    url "https://files.pythonhosted.org/packages/af/96/f4878091248450bbdebfbd01bf1d95821bd47eb38e756815a0431baa6b07/netaddr-0.10.1.tar.gz"
    sha256 "f4da4222ca8c3f43c8e18a8263e5426c750a3a837fdfeccf74c68d0408eaa3bf"
end
            
resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
end
            
resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/31/63/d161a1c96fd7c3210cb708f018ab0869b2b70c99095875d1362a86103331/openstacksdk-2.0.0.tar.gz"
    sha256 "697cb62515c548d3b7fc5cb3f865e279b930d39e37dceb11d871f81f9fa591e8"
end
            
resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/58/3f/09e93eb484b69d2a0d31361962fb667591a850630c8ce47bb177324910ec/os-service-types-1.7.0.tar.gz"
    sha256 "31800299a82239363995b91f1ebf9106ac7758542a1e4ef6dc737a5932878c6c"
end
            
resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/6c/46/796a178cc7ae4f1cd030e503db68ab7cf4474211ca796f7a887a0569f49d/osc-lib-2.9.0.tar.gz"
    sha256 "36757a0164d661326141ad2bb489a6887455a6f542415af37334bf1deb0f0f9b"
end
            
resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/86/df/3806c478e29866001cd0e04f22a9688851928a2da830aceb5a026d125a40/oslo.config-9.2.0.tar.gz"
    sha256 "ffeb01ca65a603d5525905f1a88a3319be09ce2c6ac376c4312aaec283095878"
end
            
resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/bd/aa/6ffc977bc9503318d8992530b249113092aaa83961490991b24783829f5a/oslo.context-5.3.0.tar.gz"
    sha256 "c5107141c628b6ae56d4feb6322b9c4a70092fd6a181e91fabeade94a09e4e38"
end
            
resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/a4/24/c4c441628dee6f6a34b8a433fb1e12853f066f9d0a0c7b7cf88cb8547b10/oslo.i18n-6.2.0.tar.gz"
    sha256 "70f8a4ce9871291bc609d07e31e6e5032666556992ff1ae53e78f2ed2a5abe82"
end
            
resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/2b/d5/b3b9a02d09eb0b7c9d05958908b881e23182dac95d448377eb564598e52f/oslo.log-5.4.0.tar.gz"
    sha256 "2eb355b58570f25811da76fa81453b875c7c944a19a23d2c305b4a4dfebbd223"
end
            
resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/1d/75/dff75372e7af48468da06f52c6a9abca63b7a4000165ce49e161011a4a10/oslo.serialization-5.2.0.tar.gz"
    sha256 "9cf030d61a6cce1f47a62d4050f5e83e1bd1a1018ac671bb193aee07d15bdbc2"
end
            
resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/dd/64/453052c33d834e4b187e5459e7a3f8ae67134d321de96aa0bd3e918c9bf2/oslo.utils-6.3.0.tar.gz"
    sha256 "758d945b2bad5bea81abed80ad33ffea1d1d793348ac5eb5b3866ba745b11d55"
end
            
resource "pbr" do
    url "https://files.pythonhosted.org/packages/8d/c2/ee43b3b11bf2b40e56536183fc9f22afbb04e882720332b6276ee2454c24/pbr-6.0.0.tar.gz"
    sha256 "d1377122a5a00e2f940ee482999518efe16d745d423a670c27773dfbc3c9a7d9"
end
            
resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
end
            
resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
end
            
resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
end
            
resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
end
            
resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
end
            
resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
end
            
resource "python-barbicanclient" do
    url "https://files.pythonhosted.org/packages/ae/32/a7ef628474160e515ed63c9b99555caa024de45cc20bd5cda7094f35488d/python-barbicanclient-5.6.1.tar.gz"
    sha256 "87a68beef82e046e2f8e90fd725f12813f92a04b8b213d44c0fe139d65bbac77"
end
            
resource "python-ceilometerclient" do
    url "https://files.pythonhosted.org/packages/0b/cc/2cffdf378357897c8f32f5202c56e16a89bee82fa5d4c5201b1831b45571/python-ceilometerclient-2.9.0.tar.gz"
    sha256 "20e4eccb27a40bc279dba3faaa8d0974680204a35c54553833ee4063cf30074a"
end
            
resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/92/b7/ed31992f6a680eda4096379d16d7ce49cb9d7647a299f22882dc35472b4f/python-cinderclient-9.4.0.tar.gz"
    sha256 "a53e6470a516627b59d22505222a0c85794be1a7f2774e87796105bd47ee9695"
end
            
resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/48/6b/a09ec4fef07a228dbb5d699009d22ff204ec52159de3b9cbc0f39163ef9a/python-cloudkittyclient-4.8.0.tar.gz"
    sha256 "ef2d2e3b0f14b720343add556aa4900e74a210d49d673b098047bfdc73d48573"
end
            
resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
end
            
resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/77/39/256c2c4a54c5d9efe64a9c711f49d7756a4b59c802649ead4787ab24a599/python-designateclient-5.3.0.tar.gz"
    sha256 "ee7ae841eabff1cc389dc4582387366ed574a353c46b16a96fb411253d469844"
end
            
resource "python-fuelclient" do
    url "https://files.pythonhosted.org/packages/e5/c2/1204599d76c2f044d9171896b694857e3990c3b6b946e96395d56e8a9f64/python-fuelclient-11.0.0.tar.gz"
    sha256 "320a4a81387b375579eaa5e92a3c73d359386859b190b213b076fb96eb8be385"
end
            
resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/76/b6/582ca4c2a5fe5010247e4459836acf8e6abb88462c9a25094e023a63abc6/python-glanceclient-4.4.0.tar.gz"
    sha256 "7a366e1ff66bdb76e627eecf7cd4053bd94f35fa3cdc690d29aff47e976e0532"
end
            
resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/09/ac/6707625482f57612aaeee9b39c5b830b8cb6c10a937b1574867e5c70acd4/python-heatclient-3.3.0.tar.gz"
    sha256 "a2905bf597fad2480cb41362b3673edb65464bba6c1440cf62f973ed6c8a207b"
end
            
resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/13/c3/456c3d3125a189adf7d23e7ca7759226d717fdce20c6c590686d03886897/python-keystoneclient-5.2.0.tar.gz"
    sha256 "72a42c3869e2128bb0c626ac856c3dbf3e38ef16d7e85dd35567b82cd24539a9"
end
            
resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/d5/a7/a0da4839ef91babf4166eec2b395f85737c0b816816f3ab3970a528f9a59/python-magnumclient-4.3.0.tar.gz"
    sha256 "b6cafb1069a0ec6a636b89639e82cbe6bc6903fb1ccdd583f9c3fd868d275b34"
end
            
resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/a4/60/b9143015703487519c6bbd8ae70e6ca84a9d42361c211d9f620d4428d150/python-manilaclient-4.7.0.tar.gz"
    sha256 "6e5904fa92f3650f0108702693ac8d8f3a9b04094ad9a6f5172486141fe43767"
end
            
resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/27/6e/18c53ae5a3766e7872ad2732971ea35fd2e40a4bc91fbd71a128dfce0da0/python-mistralclient-5.1.0.tar.gz"
    sha256 "104d1e93404bc90c430ec8ad1ba9a333224d5cf9684bac702ca724560fbe9739"
end
            
resource "python-monascaclient" do
    url "https://files.pythonhosted.org/packages/42/64/2e668680115c24499cdc5fba54022f154aa1760b4a2c5fe4c21d27dd00d3/python-monascaclient-2.8.0.tar.gz"
    sha256 "efe223d59a6bf2e0f24e4af70be4d2382a3cec4076fa7f40a5aa70adf05a12d2"
end
            
resource "python-muranoclient" do
    url "https://files.pythonhosted.org/packages/6e/90/d73d6be423c097021d7c54a74a3640120ad06dad1a8fd5718ce99861059b/python-muranoclient-2.7.0.tar.gz"
    sha256 "df96c5ded0ba0299ca0fe38e3f5775c889c03923fc8d7e94f6b96dbf679e19d6"
end
            
resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/1e/2d/c58cc8c8831fc433d415f3d30f5a84a5da0ade1e16e20fee962d4e4fa7b8/python-neutronclient-11.1.0.tar.gz"
    sha256 "f0a5cd6e3d8ce5a26fb0f88a932148a7a304148f6d8c68bc58e9ba1cc38d7798"
end
            
resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/c4/c6/4ee6c69bfc7a9e9dde92d946594735f638dcf4959e6e8da1b1d920b3f0d9/python-novaclient-18.4.0.tar.gz"
    sha256 "6b6b6ae2c11eb1c108e3af55eaa7211b0fc9199935a229a6ba3e0de514c12b50"
end
            
resource "python-openstackclient" do
    url "https://files.pythonhosted.org/packages/71/13/9556dd8c47b78a7542f5f9241f4798f66d1203b6fd5f069518f5cc51df3f/python-openstackclient-6.4.0.tar.gz"
    sha256 "0c6ab40168ea51fed68819aa251f8253de9a61dacc96dd1b64739f189fc2183f"
end
            
resource "python-saharaclient" do
    url "https://files.pythonhosted.org/packages/ef/25/5069709b75465537a4bb4871d3272e2b2c425637c0fc40e9282e3335ddb4/python-saharaclient-4.2.0.tar.gz"
    sha256 "ff7846c244ee3a5c219310f4b0873011919c213db9ab413b79f0dace09491c33"
end
            
resource "python-senlinclient" do
    url "https://files.pythonhosted.org/packages/82/fd/db692d04dc3f78cf4561080209ccedbb04e5bbf6059af44e9ab110138ea3/python-senlinclient-3.1.0.tar.gz"
    sha256 "f1af72fc25ca7e7ec66e53dbdd0053d1df79f8483361550319b40823daaa7cad"
end
            
resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/12/69/e6c03ad881aa63d9c1aada4613e463b0af384df406d358e502d2aeaf277a/python-swiftclient-4.4.0.tar.gz"
    sha256 "a77d97ab0e4012c678732e575bdfeed282b3489b9175e82c46a47ac8491eee84"
end
            
resource "python-troveclient" do
    url "https://files.pythonhosted.org/packages/34/8b/9f102b2bb0471425ae2b5cb83c1a0bce92fb4d47f14dde935cd43a844192/python-troveclient-8.2.1.tar.gz"
    sha256 "5e1f2809f1acfe9129038e035dbcbf16248c1edccad1c709641293a979897ff7"
end
            
resource "referencing" do
    url "https://files.pythonhosted.org/packages/96/71/0aabc36753b7f4ad18cbc3c97dea9d6a4f204cbba7b8e9804313366e1c8f/referencing-0.32.0.tar.gz"
    sha256 "689e64fe121843dcfd57b71933318ef1f91188ffb45367332700a86ac8fd6161"
end
            
resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
end
            
resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
end
            
resource "requests-oauthlib" do
    url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
    sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
end
            
resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
end
            
resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
end
            
resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/c2/63/94a1e9406b34888bdf8506e91d654f1cd84365a5edafa5f8ff0c97d4d9e1/rpds_py-0.16.2.tar.gz"
    sha256 "781ef8bfc091b19960fc0142a23aedadafa826bc32b433fdfe6fd7f964d7ef44"
end
            
resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
end
            
resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
end
            
resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
end
            
resource "tzdata" do
    url "https://files.pythonhosted.org/packages/4d/60/acd18ca928cc20eace3497b616b6adb8ce1abc810dd4b1a22bc6bdefac92/tzdata-2023.4.tar.gz"
    sha256 "dd54c94f294765522c77399649b4fefd95522479a664a0cec87f41bebc6148c9"
end
            
resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
end
            
resource "warlock" do
    url "https://files.pythonhosted.org/packages/de/cf/ba9ac96d09b797c377e2c12c0eb6b19565f3b2a2efb55932d319e319b622/warlock-2.0.1.tar.gz"
    sha256 "99abbf9525b2a77f2cde896d3a9f18a5b4590db063db65e08207694d2e0137fc"
end
            
resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
end
            
resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
end
            
resource "yaql" do
    url "https://files.pythonhosted.org/packages/f9/00/2cc9f993b5a6a12c2baccfb110232de9a58f819a1cc2a8288f3dfb845dc4/yaql-2.0.0.tar.gz"
    sha256 "b000a84b78a9c23b9952bf8c45f6e92e752797df27cea7f54c328a9f025147af"
end
            
resource "zipp" do
    url "https://files.pythonhosted.org/packages/58/03/dd5ccf4e06dec9537ecba8fcc67bbd4ea48a2791773e469e73f94c3ba9a6/zipp-3.17.0.tar.gz"
    sha256 "84e64a1c28cf7e91ed2078bb8cc8c259cb19b76942096c8d7b84947690cabaf0"
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
