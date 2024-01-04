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
  depends_on "python-attrs"
  depends_on "python-certifi"
  depends_on "python-charset-normalizer"
  depends_on "python-cryptography"
  depends_on "python-idna"
  depends_on "python-jmespath"
  depends_on "python-msgpack"
  depends_on "python-packaging"
  depends_on "python-pbr"
  depends_on "python-platformdirs"
  depends_on "python-ply"
  depends_on "python-pyparsing"
  depends_on "python-pytz"
  depends_on "python-requests"
  depends_on "python-requests-oauthlib"
  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "python-urllib3"
  depends_on "python-wcwidth"

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/9f/9e/559b0cfdba9f3ed6744d8cbcdbda58880d3695c43c053a31773cefcedde3/autopage-0.5.2.tar.gz"
    sha256 "826996d74c5aa9f4b6916195547312ac6384bac3810b8517063f293248257b72"
end
            
resource "Babel" do
    url "https://files.pythonhosted.org/packages/17/e6/ec9aa6ac3d00c383a5731cc97ed7c619d3996232c977bb8326bcbb6c687e/Babel-2.9.1.tar.gz"
    sha256 "bc0c176f9f6a994582230df350aa6e05ba2ebe4b3ac317eab29d9be5d2768da0"
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
            
resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/b4/206081fca69171b4dc1939e77b378a7b87021b0f43ce07439d49d8ac5c84/importlib_metadata-7.0.1.tar.gz"
    sha256 "f238736bb06590ae52ac1fab06a3a9ef1d8dce2b7a35b5ab329371d6c8f5d2cc"
end
            
resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
end
            
resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/22/02/7750e826154f5014d3457b4badc094930234cd3128cc953f811e773bfce5/jsonpatch-1.9.tar.gz"
    sha256 "e997076450992aa7af2f4ae6c3e7767d390ddb6746979c74fd2092bb8fbdf5b2"
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
    url "https://files.pythonhosted.org/packages/e6/a9/569ad03b90093c956bd396a6b3151c17e6005d8ac139d9419e89339c02df/jsonschema-4.9.1.tar.gz"
    sha256 "408c4c8ed0dede3b268f7a441784f74206380b04f93eb2d537c7befb3df3099f"
end
            
resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
end
            
resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/7a/28/0b760f26f0c33c48aec42003c8a9ea96b0bc409d7fb892593ee30f272a9f/keystoneauth1-5.4.0.tar.gz"
    sha256 "1ac134151ceb02e50b68ad78dec9821bf89fe53bd36fc8658501c47b07cbdf53"
end
            
resource "murano-pkg-check" do
    url "https://files.pythonhosted.org/packages/a4/ef/efe83ae0d1d3fc339184cd4912841a11f589ddcf1996fcb5ed067ec57fa6/murano-pkg-check-0.3.0.tar.gz"
    sha256 "56d2c45cdaf3a51e0946e5701dfc76d38262d42c47d077680c2b56210acfd485"
end
            
resource "netaddr" do
    url "https://files.pythonhosted.org/packages/48/4c/2491bfdb868c3f40d985037fa64a3903c125f45d7d3025640e05715db7a3/netaddr-0.9.0.tar.gz"
    sha256 "7b46fa9b1a2d71fd5de9e4a3784ef339700a53a08c8040f08baf5f1194da0128"
end
            
resource "netifaces" do
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
end
            
resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/31/63/d161a1c96fd7c3210cb708f018ab0869b2b70c99095875d1362a86103331/openstacksdk-2.0.0.tar.gz"
    sha256 "697cb62515c548d3b7fc5cb3f865e279b930d39e37dceb11d871f81f9fa591e8"
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
            
resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
end
            
resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
end
            
resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/bf/a0/e667c3c43b65a188cc3041fa00c50655315b93be45182b2c94d185a2610e/pyOpenSSL-23.3.0.tar.gz"
    sha256 "6b2cba5cc46e822750ec3e5a81ee12819850b11303630d575e98108a079c2b12"
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
    url "https://files.pythonhosted.org/packages/53/2e/94df81419a9ceca873cb37caf43313b44e130468306477c0e942ccc32072/python-fuelclient-9.0.0.tar.gz"
    sha256 "a09e3526d9f5bb2aa1182cc6b207c31bc20b8c86a4f23c31cc06d679ffb131dd"
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
    url "https://files.pythonhosted.org/packages/ef/e4/107865bfbdd8153e15431e2fb9988a29b69de5558b928fd4a4671ceed972/python-neutronclient-9.0.0.tar.gz"
    sha256 "a4062d10052940b31dbeb4479c99de4281b32f343998177195a36860e2eb04db"
end
            
resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/01/1e/f2401e9f9628c401d976d925d7e4dfa46a35448ec023e60860338f6fd92a/python-novaclient-9.1.3.tar.gz"
    sha256 "ddd2cac1d020bb3af4bdc559c8cf525360a96b37042a25f6755a2e9f264dcec8"
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
    url "https://files.pythonhosted.org/packages/3a/2c/6c5c6451d2818adfd99b87a8aa1c5147f6d9097d31cfee6a020418f9b02c/referencing-0.9.2.tar.gz"
    sha256 "d632b3e12d6923c60b0a5c8205a2f71326c46e758723b95c16125454a7888946"
end
            
resource "requests" do
    url "https://files.pythonhosted.org/packages/64/20/2133a092a0e87d1c250fe48704974b73a1341b7e4f800edecf40462a825d/requests-2.9.2.tar.gz"
    sha256 "d8be941a08cf36e4f424ac76073eb911e5e646a33fcb3402e1642c426bf34682"
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
    url "https://files.pythonhosted.org/packages/da/3c/fa2701bfc5d67f4a23f1f0f4347284c51801e9dbc24f916231c2446647df/rpds_py-0.9.2.tar.gz"
    sha256 "8d70e8f14900f2657c249ea4def963bed86a29b81f81f5b76b5a9215680de945"
end
            
resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/cb/56/4aa487b46d09646eb1863faa7026551d8309ece2281794bf13b20f28ab94/semantic_version-2.9.0.tar.gz"
    sha256 "abf54873553e5e07a6fd4d5f653b781f5ae41297a493666b59dcf214006a12b2"
end
            
resource "simplejson" do
    url "https://files.pythonhosted.org/packages/81/b6/9a4d0107b1a8929c77f88bb816c64da25aacba6ef1ac080d39e46d8f1307/simplejson-3.9.0.tar.gz"
    sha256 "e9abeee37424f4bfcd27d001d943582fb8c729ffc0b74b72bd0e9b626ed0d1b6"
end
            
resource "stevedore" do
    url "https://files.pythonhosted.org/packages/ac/d6/77387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780/stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
end
            
resource "tzdata" do
    url "https://files.pythonhosted.org/packages/4d/60/acd18ca928cc20eace3497b616b6adb8ce1abc810dd4b1a22bc6bdefac92/tzdata-2023.4.tar.gz"
    sha256 "dd54c94f294765522c77399649b4fefd95522479a664a0cec87f41bebc6148c9"
end
            
resource "warlock" do
    url "https://files.pythonhosted.org/packages/de/cf/ba9ac96d09b797c377e2c12c0eb6b19565f3b2a2efb55932d319e319b622/warlock-2.0.1.tar.gz"
    sha256 "99abbf9525b2a77f2cde896d3a9f18a5b4590db063db65e08207694d2e0137fc"
end
            
resource "wrapt" do
    url "https://files.pythonhosted.org/packages/66/19/d2fe20975dc799e2116f6ddee2643b6a882f6b36d86108f3ecb42d5c1d46/wrapt-1.9.0.tar.gz"
    sha256 "ac6a5bad9bd5efd9c6010de01a9a203634efb841d7f86d4e1e1f7e2c233a83fd"
end
            
resource "yaql" do
    url "https://files.pythonhosted.org/packages/f9/00/2cc9f993b5a6a12c2baccfb110232de9a58f819a1cc2a8288f3dfb845dc4/yaql-2.0.0.tar.gz"
    sha256 "b000a84b78a9c23b9952bf8c45f6e92e752797df27cea7f54c328a9f025147af"
end
            
resource "zipp" do
    url "https://files.pythonhosted.org/packages/21/40/791c00c9788d8a8b005a20248a9ce2fb46aaf12fa12b0ff9e1639aea04af/zipp-3.9.1.tar.gz"
    sha256 "97276b5f589df6611b416f839d9e212d9122eadf8dbf2a7be39b74968d681c52"
end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "stack list", # senlin
      "loadbalancer list", # octavia
      "secret list", # barbican
      "database db list", # trove
      "dataprocessing job list", # sahara
      "firewall group list", # neutron
      "orchestration service list", # heat
      "package list", # murano
      "rating module list", # cloud kitty
      "recordset list", # designate
      "share list", # manila

    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
