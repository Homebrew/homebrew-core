class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/72/24/36f74f0df77b69449115d781de680207c82b33af6ad9af7b280b88bf9474/python-openstackclient-5.5.0.tar.gz"
  sha256 "8d40491374172f9375ce1642ac2230b1cbb5a564320edbcc2a9ebe857fd9a880"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2f29787b721969574fd33180a44413ca53716ba6398abd393a786e912580136a"
    sha256 cellar: :any, big_sur:       "bccccc98d1077c9fbabb2a01016b8f9c69dba2d4aba4950ba31e57f617f997eb"
    sha256 cellar: :any, catalina:      "03d89b5f94e1d72df64ccf3b5b616d0a085cc787fcf8b0d15144a010f5d16c4d"
    sha256 cellar: :any, mojave:        "1d9ebfa870d73deb2de20e96320ee401f56794443f3ff722476e52727324adda"
  end

  depends_on "rust" => :build
  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/f0/cb/80a4a274df7da7b8baf083249b0890a0579374c3d74b5ac0ee9291f912dc/attrs-20.3.0.tar.gz"
    sha256 "832aa3cde19744e49938b91fea06d69ecb9e649c93ba974535d08ad92164f700"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/41/1b/5ed6e564b9ca54318df20ebe5d642ab25da4118df3c178247b8c4b26fa13/Babel-2.9.0.tar.gz"
    sha256 "da031ab54472314f210b0adcff1588ee5d1d1d0ba4dbd07b94dba82bde791e05"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/a9/cd1fd8ee13f73a4d4f491ee219deeeae20afefa914dfb4c130cfc9dc397a/certifi-2020.12.5.tar.gz"
    sha256 "1a4995114262bffbc2413b159f2a1a480c969de6e6eb13ee966d470af86af59c"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/a8/20/025f59f929bbcaa579704f443a438135918484fffaacfaddba776b374563/cffi-1.14.5.tar.gz"
    sha256 "fd78e5fee591709f32ef6edb9a015b4aa1a5022598e36227500c8f4e02328d9c"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/24/fd/49d46908eb2cf67e4fcd304aab2b295b8269e2fe62461fd6fb9b9a1e6e1c/cliff-3.7.0.tar.gz"
    sha256 "389c81960de13f05daf1cbd546f33199e86c518ba4266c79ec7a153a280980ea"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/00/65/f580d23070a3f4eadaece9e4edcea002bc7fed639debc63c7b81a42fbe7f/cmd2-1.5.0.tar.gz"
    sha256 "701a8c9975c4abc45e5d13906ab149f959f812869106347323a3f89ac0e82a62"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/2d/2154d8cb773064570f48ec0b60258a4522490fcb115a6c7c9423482ca993/cryptography-3.4.6.tar.gz"
    sha256 "2d32223e5b0ee02943f32b19245b61a62db83a882f0e76cc564e1cec60d48f87"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/43/db/878dd456ccdbba6e466fc91e2534fd183a345a3fe261c4780a0e46c6dab0/debtcollector-2.2.0.tar.gz"
    sha256 "787981f4d235841bf6eb0467e23057fb1ac7ee24047c32028a8498b9128b6829"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/da/93/84fa12f2dc341f8cf5f022ee09e109961055749df2d0c75c5f98746cfe6c/decorator-4.4.2.tar.gz"
    sha256 "e3a62f0520172440ca0dcc823749319382e377f37f140a0b99ef45fecb84bfe7"
  end

  resource "dogpile.cache" do
    url "https://files.pythonhosted.org/packages/55/51/24484f0f713f3499da44f5b4483cf0e5b5284572980530065b97b3d41c83/dogpile.cache-1.1.2.tar.gz"
    sha256 "2134464672a3deb7ef1366a8691726686d8c62540e4208f1a40c9aaa1a0b6a45"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/f9/ed/b97abc7877e5b253eef96a469f47d617b0ebcccc735405fa1a620c7ee833/iso8601-0.1.14.tar.gz"
    sha256 "8aafd56fa0290496c5edbb13c311f78fa3a241f0853540da09d9363eae3ebd79"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/21/67/83452af2a6db7c4596d1e2ecaa841b9a900980103013b867f2865e5e1cf0/jsonpatch-1.32.tar.gz"
    sha256 "b6ddfe6c3db30d81a96aaeceb6baf916094ffa23d7dd5fa2c13e13f8b6e600c2"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/6b/35/400557d3df63269a4c010cbd4865910b3c1718fbfe8d83210b216cd3efcf/jsonpointer-2.1.tar.gz"
    sha256 "5a34b698db1eb79ceac454159d3f7c12a451a91f6334a4f638454327b7a89962"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/d3/65/e6a02ffec522bc5382438b1c4c855899f4d65978d4cfc23cded2dcab931e/keystoneauth1-4.3.1.tar.gz"
    sha256 "93605430a6d1424f31659bc5685e9dc1be9a6254e88c99f00cffc0a60c648a64"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
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
    url "https://files.pythonhosted.org/packages/0d/18/fd6e9c71a35b67a73160ec80a49da63d1eed2d2055054cc2995714949132/netifaces-0.10.9.tar.gz"
    sha256 "2dee9ffdd16292878336a58d04a20f0ffe95555465fee7c9bd23b3490ef2abf3"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/cb/6a/8a11e91f03ca4361a8dc7758d2e8ad702b0a30475f0b550fca5f7aee8c1f/openstacksdk-0.55.0.tar.gz"
    sha256 "8ee4d8fe8bc97bc57b2152aaf44b8fda1178e9acb3dbc51a88bc52fb34ab6407"
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
    url "https://files.pythonhosted.org/packages/f4/70/a92bb13b8eaf13be71e72d5137c338279eb139dddc8b146b9849f5e20259/osc-lib-2.3.1.tar.gz"
    sha256 "f7d178dc6fcf5e5c069206e4fcf7206bf6369e3c855ec5b8498c7f6bb28be75e"
  end

  resource "oslo.config" do
    url "https://files.pythonhosted.org/packages/ef/ac/b9015ba65085e73971ec0caa34e99e0a5e16fd7e521274d5224507b004a4/oslo.config-8.5.0.tar.gz"
    sha256 "f50bb71439af4515bce3cf1c2b60d36da70c3cfbf5b1b7e3cd4c4cf868f2c3e9"
  end

  resource "oslo.context" do
    url "https://files.pythonhosted.org/packages/22/4e/336321171977ea62711f5d896e0d597346ca4f290e0caa2de1b10f748838/oslo.context-3.2.0.tar.gz"
    sha256 "0e7d96a95c276de2da0f458ef34153347327ac34fe33b264be2bb59eac51e620"
  end

  resource "oslo.i18n" do
    url "https://files.pythonhosted.org/packages/de/6f/e8343be26e69e42b3d30610c3ffee576e5b901be6792e5c3af1384613b40/oslo.i18n-5.0.1.tar.gz"
    sha256 "3484b71e30f75c437523302d1151c291caf4098928269ceec65ce535456e035b"
  end

  resource "oslo.log" do
    url "https://files.pythonhosted.org/packages/e0/2b/30e41e5cef9da3aafe8a174fde3bcde5ebdec69644036302b1a75570b910/oslo.log-4.4.0.tar.gz"
    sha256 "0883be3099cd9f8e17843b574018627e1d64243aabcf6cdbe1ebdd1cb5784448"
  end

  resource "oslo.serialization" do
    url "https://files.pythonhosted.org/packages/0a/85/9af1feeff44ee56868145674e0c2e6654e8ff2241c5bc178bb9539065c3d/oslo.serialization-4.1.0.tar.gz"
    sha256 "cecc7794df806c85cb70dbd6c2b3af19bc68047ad29e3c6442be90a0a4de5379"
  end

  resource "oslo.utils" do
    url "https://files.pythonhosted.org/packages/6e/c2/2e3800122ec247efc79ee2f4a482185926613d162bfe29d74bbba81d77b0/oslo.utils-4.8.0.tar.gz"
    sha256 "193111209bed092229b75be725194a6d4f3464c2692a2ac9fb34c46cd8013edb"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/65/e2/8cb5e718a3a63e8c22677fde5e3d8d18d12a551a1bbd4557217e38a97ad0/pbr-5.5.1.tar.gz"
    sha256 "5fad80b613c402d5b7df7bd84812548b2a61e9977387a80a5fc5c396492b13c9"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/ef/30/4b0746848746ed5941f052479e7c23d2b56d174b82f4fd34a25e389831f5/prettytable-0.7.2.tar.bz2"
    sha256 "853c116513625c738dc3ce1aee148b5b5757a86727e67eff6502c7ca59d43c36"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "python-cinderclient" do
    url "https://files.pythonhosted.org/packages/83/d2/4bde089484ebe1125fd71f7a41da498a67a1344263187f4f10adda06d149/python-cinderclient-7.4.0.tar.gz"
    sha256 "dec1998badfcf3af0a1bf47bbafd3a4f3415c18e1f9fbeceab77737da99b7c28"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/21/3e/9b8291832fa40bb39d46e13a8327705460ab3fb25c46c950f0fafec9ceaf/python-heatclient-2.3.0.tar.gz"
    sha256 "d6fe15e610523f96e1ee26e84e9d5fd06846a3fa72d352c38f1fc79abe7eb44a"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/0d/17/aaaa6e508ca437360eb348486d6ac7cf17e434400acd222548361959b4bd/python-keystoneclient-4.2.0.tar.gz"
    sha256 "0248426e483b95de395086482c077d48e45990d3b1a3e334b2ec8b2e108f5a8a"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/ad/86/d38f25f73071e2d729cc505aa984b19a4656b581a861f1252b23ce0012d1/python-neutronclient-7.3.0.tar.gz"
    sha256 "41b9a4bab8ebb2428f926cd1f7077df6c1d997f384e48aa0cbec049b8b54536c"
  end

  resource "python-novaclient" do
    url "https://files.pythonhosted.org/packages/df/2e/5f41b6c012f2295cc6cca8fd5d853d4ad4cccf4dc6211e710cee28763544/python-novaclient-17.4.0.tar.gz"
    sha256 "bca1a3899c0ecf0f63a9b3e97c5d56557186bece1e2a585b26d7c5727d461822"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/93/54/6d734af443f2f9d670009387b3a3d8f4fb9d2f9f20e2eb23030b40016806/python-octaviaclient-2.3.0.tar.gz"
    sha256 "5150cab6aef0b0c479d133f10c4733266d197a568c02a339e6230637a24221f0"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/bd/fd/502864fc1312218454646dc6e18fce8cf67c7693c2801f692c4bcffece86/python-swiftclient-3.11.1.tar.gz"
    sha256 "06919d59676d3e215f4da4f3f930d71880dda3528289842b25199509df712411"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/b0/61/eddc6eb2c682ea6fd97a7e1018a6294be80dba08fa28e7a3570148b4612d/pytz-2021.1.tar.gz"
    sha256 "83a4a90894bf38e243cf052c8b58f381bfe9a7a483f6a9cab140bc7f702ac4da"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "requestsexceptions" do
    url "https://files.pythonhosted.org/packages/82/ed/61b9652d3256503c99b0b8f145d9c8aa24c514caff6efc229989505937c1/requestsexceptions-1.4.0.tar.gz"
    sha256 "b095cbc77618f066d459a02b137b020c37da9f46d9b057704019c9f77dba3065"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/70/e2/1344681ad04a0971e8884b9a9856e5a13cc4824d15c047f8b0bbcc0b2029/rfc3986-1.4.0.tar.gz"
    sha256 "112398da31a3344dc25dbf477d8df6cb34f9278a94fee2625d89e4514be8bb9d"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/49/45/a16db4f0fa383aaf0676fb7e3c660304fe390415c243f41a77c7f917d59b/simplejson-3.17.2.tar.gz"
    sha256 "75ecc79f26d99222a084fbdd1ce5aad3ac3a8bd535cd9059528452da38b68841"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/95/bc/dc386a920942dbdfe480c8a4d953ff77ed3dec99ce736634b6ec4f2d97c1/stevedore-3.3.0.tar.gz"
    sha256 "3a5bbd0652bf552748871eaa73a4a8dc2899786bc497a2aa1fcb4dcdb0debeee"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/cb/cf/871177f1fc795c6c10787bc0e1f27bb6cf7b81dbde399fd35860472cecbc/urllib3-1.26.4.tar.gz"
    sha256 "e7b021f7241115872f92f43c6508082facffbd1c048e3c6e2bb9c2a157e28937"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
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
