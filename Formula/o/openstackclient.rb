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
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
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

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/d2/f8/f3e877361372737d83f6592d6ba2126b2018d2208472a5dcb82773694281/dogpile.cache-1.2.2.tar.gz"
    sha256 "fd9022c0d9cbadadf20942391a95adaf296be80b42daa8e202f8de1c21f198b2"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/db/5a/392426ddb5edfebfcb232ab7a47e4a827aa1d5b5267a5c20c448615feaa9/importlib_metadata-7.0.0.tar.gz"
    sha256 "7fc841f8b8332803464e5dc1c63a2e59121f46ca186c0e2e182e80bf8c1319f7"
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

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/a8/74/77bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03aff/jsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/8c/ce/1eb873a0ba153cf327464c752412b42d11b9c889d208beca7ef75540d128/jsonschema_specifications-2023.11.2.tar.gz"
    sha256 "9472fc4fea474cd74bea4a2b190daeccb5a9e4db2ea80efcf7a1b582fc9a81b8"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/7a/28/0b760f26f0c33c48aec42003c8a9ea96b0bc409d7fb892593ee30f272a9f/keystoneauth1-5.4.0.tar.gz"
    sha256 "1ac134151ceb02e50b68ad78dec9821bf89fe53bd36fc8658501c47b07cbdf53"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/c2/d5/5662032db1571110b5b51647aed4b56dfbd01bfae789fa566a2be1f385d1/msgpack-1.0.7.tar.gz"
    sha256 "572efc93db7a4d27e404501975ca6d2d9775705c2d922390d878fcf768d92c87"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/48/4c/2491bfdb868c3f40d985037fa64a3903c125f45d7d3025640e05715db7a3/netaddr-0.9.0.tar.gz"
    sha256 "7b46fa9b1a2d71fd5de9e4a3784ef339700a53a08c8040f08baf5f1194da0128"
  end

  resource "netifaces" do
    url "https://files.pythonhosted.org/packages/a6/91/86a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73/netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
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

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/86/df/3806c478e29866001cd0e04f22a9688851928a2da830aceb5a026d125a40/oslo.config-9.2.0.tar.gz"
    sha256 "ffeb01ca65a603d5525905f1a88a3319be09ce2c6ac376c4312aaec283095878"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/bd/aa/6ffc977bc9503318d8992530b249113092aaa83961490991b24783829f5a/oslo.context-5.3.0.tar.gz"
    sha256 "c5107141c628b6ae56d4feb6322b9c4a70092fd6a181e91fabeade94a09e4e38"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/a4/24/c4c441628dee6f6a34b8a433fb1e12853f066f9d0a0c7b7cf88cb8547b10/oslo.i18n-6.2.0.tar.gz"
    sha256 "70f8a4ce9871291bc609d07e31e6e5032666556992ff1ae53e78f2ed2a5abe82"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/2b/d5/b3b9a02d09eb0b7c9d05958908b881e23182dac95d448377eb564598e52f/oslo.log-5.4.0.tar.gz"
    sha256 "2eb355b58570f25811da76fa81453b875c7c944a19a23d2c305b4a4dfebbd223"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/1d/75/dff75372e7af48468da06f52c6a9abca63b7a4000165ce49e161011a4a10/oslo.serialization-5.2.0.tar.gz"
    sha256 "9cf030d61a6cce1f47a62d4050f5e83e1bd1a1018ac671bb193aee07d15bdbc2"
  end

  resource "oslo-utils" do
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

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/e1/c0/5e9c4d2a643a00a6f67578ef35485173de273a4567279e4f0c200c01386b/prettytable-3.9.0.tar.gz"
    sha256 "f4ed94803c23073a90620b201965e5dc0bccf1760b7a7eaf3158cab8aaffdf34"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/92/b7/ed31992f6a680eda4096379d16d7ce49cb9d7647a299f22882dc35472b4f/python-cinderclient-9.4.0.tar.gz"
    sha256 "a53e6470a516627b59d22505222a0c85794be1a7f2774e87796105bd47ee9695"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/77/39/256c2c4a54c5d9efe64a9c711f49d7756a4b59c802649ead4787ab24a599/python-designateclient-5.3.0.tar.gz"
    sha256 "ee7ae841eabff1cc389dc4582387366ed574a353c46b16a96fb411253d469844"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/09/ac/6707625482f57612aaeee9b39c5b830b8cb6c10a937b1574867e5c70acd4/python-heatclient-3.3.0.tar.gz"
    sha256 "a2905bf597fad2480cb41362b3673edb65464bba6c1440cf62f973ed6c8a207b"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/13/c3/456c3d3125a189adf7d23e7ca7759226d717fdce20c6c590686d03886897/python-keystoneclient-5.2.0.tar.gz"
    sha256 "72a42c3869e2128bb0c626ac856c3dbf3e38ef16d7e85dd35567b82cd24539a9"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/1e/2d/c58cc8c8831fc433d415f3d30f5a84a5da0ade1e16e20fee962d4e4fa7b8/python-neutronclient-11.1.0.tar.gz"
    sha256 "f0a5cd6e3d8ce5a26fb0f88a932148a7a304148f6d8c68bc58e9ba1cc38d7798"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/c4/c6/4ee6c69bfc7a9e9dde92d946594735f638dcf4959e6e8da1b1d920b3f0d9/python-novaclient-18.4.0.tar.gz"
    sha256 "6b6b6ae2c11eb1c108e3af55eaa7211b0fc9199935a229a6ba3e0de514c12b50"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/ed/2d/5bfd38460b8857c0485075fac757d6546a4c080d003934a38c802465a07a/python-octaviaclient-3.6.0.tar.gz"
    sha256 "96488ab87bb4566f2d36a4a17eff97d57d9875e0966a9ae296aeaafbc23788d2"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/12/69/e6c03ad881aa63d9c1aada4613e463b0af384df406d358e502d2aeaf277a/python-swiftclient-4.4.0.tar.gz"
    sha256 "a77d97ab0e4012c678732e575bdfeed282b3489b9175e82c46a47ac8491eee84"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/96/71/0aabc36753b7f4ad18cbc3c97dea9d6a4f204cbba7b8e9804313366e1c8f/referencing-0.32.0.tar.gz"
    sha256 "689e64fe121843dcfd57b71933318ef1f91188ffb45367332700a86ac8fd6161"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
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
    url "https://files.pythonhosted.org/packages/48/0b/f42f99419c5150c2741fe28bf97674d928d46ee17f46f2bc5be031cce0bc/rpds_py-0.13.2.tar.gz"
    sha256 "f8eae66a1304de7368932b42d801c67969fd090ddb1a7a24f27b435ed4bed68f"
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
    url "https://files.pythonhosted.org/packages/70/e5/81f99b9fced59624562ab62a33df639a11b26c582be78864b339dafa420d/tzdata-2023.3.tar.gz"
    sha256 "11ef1e08e54acb0d4f95bdb1be05da659673de4acbd21bf9c69e94cc5e907a3a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/d7/12/63deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24/wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/4c/063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0a/wrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
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
