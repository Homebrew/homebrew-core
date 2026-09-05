class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/9a/d8/cda0230fb90cfc40b5977beecc1f063e6bb7042ae5db1fac05c9d8ccfc64/python_openstackclient-10.3.0.tar.gz"
  sha256 "6bcc2344d5dca9a4c4920998c0616eb82e9431e41033c91719247c72c61cca4d"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "d05497a2e4490e476edaab42520c4d7b4961a3179c99519235c542929273d70a"
    sha256 cellar: :any, arm64_sequoia: "a10ae29a4f55d9a6973278dc77f5e17a1e3728c1da5191a0076ef4e4f96f8f16"
    sha256 cellar: :any, arm64_sonoma:  "eabea67a6de9b4a0ddb44c65d61e200f5ed755a3411ba3bab47e9b9b37247e69"
    sha256 cellar: :any, arm64_linux:   "75bfe5241aa82b6ac043f57ea02e88dbf8f8a59281ba6cf1f5ec752bdeeee75d"
    sha256 cellar: :any, x86_64_linux:  "bb8cdbf5f89bc2486ec123e7e7d04bf6fea769495ec899576871b07fc0fd2c3b"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages extra_packages:   %w[keyring osc-placement python-barbicanclient
                                     python-cloudkittyclient python-designateclient
                                     python-glanceclient python-heatclient python-ironicclient
                                     python-magnumclient python-manilaclient python-mistralclient
                                     python-neutronclient python-octaviaclient],
                exclude_packages: %w[certifi cryptography gnureadline rpds-py]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "autopage" do
    url "https://files.pythonhosted.org/packages/75/76/9078d8db91f29af9ac5a359757f63f2d0fa869aba704d5ef0f836db62ea1/autopage-0.6.0.tar.gz"
    sha256 "42d07de90de63e83762828028bfd56d19906a18f7c951ef6eef3e9ad48a3071d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/83/4a/908e0d2a7d81e3a199c24b8bf787670ba4ec15105785ff3834f1d4e16a84/cliff-4.16.0.tar.gz"
    sha256 "85314ad49bd62f90a51094d4e31b1cb4d3b92fb83cb3935eeba0236c32839e75"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/64/16/6864f7f344c0c83fbe78fdaf4c4ea280631ce2ad49efed98c61209106b3a/cmd2-4.2.3.tar.gz"
    sha256 "b5543c81e01eea9445f1248879855b727c949d5af27c0390fbb8796f782783e9"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/ad/57/1bbe02be744995408d944cf46b8c818cf072873064b1cd3c79c11618b216/debtcollector-3.1.0.tar.gz"
    sha256 "278a45608cf16e79c0ae10851d869185c6b78f86610df8f27a451a18c1fec732"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/60/8b/32f9823da46cde7df2087faa08cd98d01b908f8dcab982cdba9c84e85355/decorator-5.3.1.tar.gz"
    sha256 "4cbcdd55a6efadb9dbea26b858f4fb3264567b52d69ca0d25b721b553f60ea82"
  end

  resource "dogpile-cache" do
    url "https://files.pythonhosted.org/packages/e7/c8/301ff89746e76745b937606df4753c032787c59ecb37dd4d4250bddc8929/dogpile_cache-1.5.0.tar.gz"
    sha256 "849c5573c9a38f155cd4173103c702b637ede0361c12e864876877d0cd125eec"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "iso8601" do
    url "https://files.pythonhosted.org/packages/b9/f3/ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15/iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
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
    url "https://files.pythonhosted.org/packages/18/c7/af399a2e7a67fd18d63c40c5e62d3af4e67b836a2107468b6a5ea24c4304/jsonpointer-3.1.1.tar.gz"
    sha256 "0b801c7db33a904024f6004d526dcc53bbb8a4a0f4e32bfd10beadf60adf1900"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "keystoneauth1" do
    url "https://files.pythonhosted.org/packages/68/84/a76c0819add727693d89b152c11452650036fcd481274756a33172e386e7/keystoneauth1-5.17.0.tar.gz"
    sha256 "82359acc20c754fcb22818e090e2fea647e4c5c1137a6addb4984e9fba708ab3"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/6d/44/ea2100ec54d30c46ee9dba10a3bfb79b655e96c6df237238a3234c75869b/msgpack-1.2.2.tar.gz"
    sha256 "9eb0b0e602064527a045ea28c4f174ed69383587e29cebe28947e3b84106eb2a"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/38/3b/7d0bb61a25002fb0023e2f0e620cb7e78dcd7b79d555005700fc13d92888/openstacksdk-4.20.0.tar.gz"
    sha256 "f533050d7441b6d41c53488434d2f2df79f1f963a4b431695b4c7f49380ea85c"
  end

  resource "os-service-types" do
    url "https://files.pythonhosted.org/packages/86/ae/fe7ac23155ae0b4b9779e06e9c5bb4070f2315dc4ca886a88fa3230d344b/os_service_types-1.9.0.tar.gz"
    sha256 "1f2e5fb71d1f6f4ff31d8992674f2368465bc2f25cd94018015c3ddbfc5c617f"
  end

  resource "osc-lib" do
    url "https://files.pythonhosted.org/packages/eb/80/37ac2a46cc3ea9348ea670fd76dad72888726191f5875278a3d85034a9d8/osc_lib-4.7.0.tar.gz"
    sha256 "5b896de12ed69fb1111d2971467d403b838d414fc27df2024fc50e8652a53f2b"
  end

  resource "osc-placement" do
    url "https://files.pythonhosted.org/packages/54/c9/4a0ed15fc1e67cfa81004ad87cf1d969647964d59d78a8808dba85280e88/osc_placement-4.9.1.tar.gz"
    sha256 "56bd8134b482882531e87921513b45871aa7a988071ad1fbbf23fd68be3060c4"
  end

  resource "oslo-config" do
    url "https://files.pythonhosted.org/packages/74/cd/e9e312ca216eaa9e0fa76f8d8fb9aeb14ea56f136136ec6753a11df24237/oslo_config-10.7.0.tar.gz"
    sha256 "4f0fd4ca7ecfe511fbc0e012d3c63fce57009f360199e9e9cc2329ed55ec911e"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/5b/6b/71f00290f6fb7302178422d3478093aacf972ab3e6e0f4b9a91026f533f8/oslo_context-6.5.0.tar.gz"
    sha256 "7e1fb03c6a97167959f37d930300154e0ee837ecdb85798c2bbe8878b56caaaf"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/5e/69/72b03bb4d33f51a157c02d5297227bae48b9c359103856942b8774b608df/oslo_i18n-6.9.0.tar.gz"
    sha256 "574bcf21873b185068bcec951de1ec093158ffdff05a8055fd18ddcb69f69e65"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/48/b4/3bac6f385b81fc3e8a998e9de5301e345bbdfbdf19724db6039e61b81e56/oslo_log-8.3.1.tar.gz"
    sha256 "1a1eba5af4cb5c3e65e35567969178ad46675ec78a93f9113b0cd23d6ac8b210"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/af/f5/2611fb291898fa5f3b41c68e916cb060305cb718a043fdbff25026491fc4/oslo_serialization-5.11.0.tar.gz"
    sha256 "8326e85a80856c1068007423fcf6fe29dd2fe57a32f5d87fff0120b555b4b67c"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/47/fd/7915fc0e2c959bcb3dbbe608deeeefe4264d03ba89a4fd75d74524326652/oslo_utils-10.2.0.tar.gz"
    sha256 "ba839dea2c1eb415e3ee151c4cc688f52e283f59bc1f77cc86772190a8b34259"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/5e/ab/1de9a4f730edde1bdbbc2b8d19f8fa326f036b4f18b2f72cfbea7dc53c26/pbr-7.0.3.tar.gz"
    sha256 "b46004ec30a5324672683ec848aed9e8fc500b0d261d40a3229c2d2bbfcedc29"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/69/b7/802a56eca9f2fac455b8bab5375a2647b0f0e14a2cd63ef077de3c4a7658/platformdirs-4.11.7.tar.gz"
    sha256 "4f41487eeeeeb07f3a6625e61d9bc0ae6809f92d3386dbd74392fbb76108104d"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/81/74/ba08d81e668ccfe8658d7520a307e63c19862c08eb4ccb26f356c5239a7a/prettytable-3.18.0.tar.gz"
    sha256 "439217116152244369caf3d9f1caf2f9fe29b03bd79e88d2928c8e718c95d680"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyopenssl" do
    url "https://files.pythonhosted.org/packages/3f/e8/7325d258199b159eb2c03fe32107533e2832e70e63f4fb88a6aa00023201/pyopenssl-26.4.0.tar.gz"
    sha256 "28dfcce0162b9211413e26dfbfdf1d24317fbeba18fc93c12400a1856b2a0bc7"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-barbicanclient" do
    url "https://files.pythonhosted.org/packages/d0/a5/db5f8c3f831155c7f44720ae917cbba23aab8a482790ffb221f4674fa3eb/python_barbicanclient-7.6.0.tar.gz"
    sha256 "d2a79dfe49e0f7ab7412911b62147c7941dd9f9770323eb050a53c31b9322821"
  end

  resource "python-cloudkittyclient" do
    url "https://files.pythonhosted.org/packages/0b/3d/6a56a5be7e9b0332902b33e938eb26a53bf94ad65c80205d4ef858fe2f99/python_cloudkittyclient-6.2.0.tar.gz"
    sha256 "8e46335916e6de7427d6a0cf772f65ea56f6536ad225c95b06d41c77f1518763"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/92/66/9e39949850a7f086641508805ebeab1553451eabde353e05788288e3e80b/python_designateclient-7.0.0.tar.gz"
    sha256 "d9a1086e7bf81f4034ca0ec7a243cbd8b344bfb6095e2903c553cc3807d2bed2"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/66/ea/d65c3c097d1ab72aca5fde2149fd35f70d08521473711acb82a3f8af0abf/python_glanceclient-4.13.0.tar.gz"
    sha256 "fa3359bc8bd93e7aebca372dafec8e19003b4c1f64499e2eb82b2771da8fa41c"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/09/04/323b1f96de2880f7fd7c6b88730aae6c685f1935ffedd8b470b9605849af/python_heatclient-5.3.0.tar.gz"
    sha256 "3b34e9ab39578d0aca397863dded42a026c86ea46143ef9a490a875affabe66c"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/0d/2b/b23d717dda75942f98490588b878825f43260c95193039d58be12965eafa/python_ironicclient-6.3.0.tar.gz"
    sha256 "ea3f9d4d0f6aeda0db78cc5d73a1a48b230fe6200abf5e5c5f05c437a596e4d7"
  end

  resource "python-keystoneclient" do
    url "https://files.pythonhosted.org/packages/47/84/c24d6ec1b0a1c012b38fd00bc1699dacd998877ed6b28567249e5035ed47/python_keystoneclient-6.0.0.tar.gz"
    sha256 "d6ac3a09adf2319aaac5728e3bf7cbeaf952c295bd7831f1df9a573b25fbcf82"
  end

  resource "python-magnumclient" do
    url "https://files.pythonhosted.org/packages/55/60/01b883211b9b503ac342891bf2faa55581cf275c332ec5df8e6909e9f6fa/python_magnumclient-5.0.0.tar.gz"
    sha256 "0bd601347d438dfc68af9823d488ba1efbb0788d04d34f7d99a6876e79fe157e"
  end

  resource "python-manilaclient" do
    url "https://files.pythonhosted.org/packages/35/dd/281e8a33f71ecadc3dec266c6797da8170c704edf17669bc2a69e8d12abf/python_manilaclient-6.3.0.tar.gz"
    sha256 "92d73667a1ac20ab083588e8912b59769be0706f20fb6e9845ec06d3d72723d4"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/4b/e3/fa677f40e65eaf027a4942000a71a26faca401039c95ff8c1db967eb638e/python_mistralclient-6.3.0.tar.gz"
    sha256 "e12850903fc479794e528447c83f8d983fa677cf0dba25f942c2a2bc9d0d68de"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/b4/5b/1af04d85cf6c3340686d058eb5580e2bbc3249084cdbe60391bbfa57a2a6/python_neutronclient-14.0.0.tar.gz"
    sha256 "9f7ba93e6845e381b833eb54c8fd143160b8fa026c383078f9ac39de7f3c5d19"
  end

  resource "python-octaviaclient" do
    url "https://files.pythonhosted.org/packages/3e/3e/786de2bf88f5df9682b5997a85aa9f840c24402001ec2b4f79d23978ae33/python_octaviaclient-3.15.0.tar.gz"
    sha256 "b099024634386fa243b4554fd5ec7996cb02df337c6dc413a4a3ff8475aeaa3b"
  end

  resource "python-swiftclient" do
    url "https://files.pythonhosted.org/packages/bf/91/631ff6c1f6420f8e5017e60d0e66246d1dd5b9a61a70038a198bab404416/python_swiftclient-4.11.0.tar.gz"
    sha256 "9d96146f5c2948c08cbf221eecfc3b87f2f631f1995e5e5d6e1b800ea74233cc"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rfc3986" do
    url "https://files.pythonhosted.org/packages/85/40/1520d68bfa07ab5a6f065a186815fb6610c86fe957bc065754e47f7b0840/rfc3986-2.0.0.tar.gz"
    sha256 "97aacf9dbd4bfd829baad6e6309fa6573aaf1be3f6fa735c8ab05e46cecb261c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-argparse" do
    url "https://files.pythonhosted.org/packages/6a/e5/1064c43203a357d668cd42435f7a15fe6af51512d85b2104fecb937aa861/rich_argparse-1.8.0.tar.gz"
    sha256 "679df3d832fa94ad6e4bdb07ded088cd7ea2dddc58ae9b2b46346a40b06cbc0c"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "stevedore" do
    url "https://files.pythonhosted.org/packages/db/a1/3b8ed9c1fc3aa6eebb57732d924ddaa0500ecc3b638d0454816320994383/stevedore-5.9.1.tar.gz"
    sha256 "e97a2667923efda926e8713fde6a73616df68210a3cbc6f02b48967b676fd8bf"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/29/c2/3ba4daeddd47f1cfdbc703048cbee27bcbc50535261a2bbe36412565f3c9/warlock-2.1.0.tar.gz"
    sha256 "82319ba017341e7fcdc81efc2be9dd2f8237a0da07c71476b5425651b317b1c9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/36/57/ed58088fafdf4c55a0ad6bde846502567645424d7ebf325230b9237f4085/wcwidth-0.8.3.tar.gz"
    sha256 "d128512515fbf4612e0ff21fd6380399210318b7b54a9af59dff8454cf9730eb"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/65/ba/8dc25478ed234dacc7d83c671634f347d0bdfb65bf0502f41879cf2f15a9/wrapt-2.4.0.tar.gz"
    sha256 "7082fc1f94b020ac275870c4af71b09cff22876fe6e9c4c0ad01ea21d217b288"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"openstack", "-h"
    openstack_subcommands = [
      "server list",
      "resource provider list", # osc-placement
      "stack list", # python-heatclient
      "loadbalancer list", # python-octaviaclient
      "rating summary get", # python-cloudkittyclient
      "zone list", # python-designateclient
      "secret list", # python-barbicanclient
      "share list", # python-manilaclient
      "workflow list", # python-mistralclient
      "coe cluster list", # python-magnumclient
      "baremetal node list", # python-ironicclient
      "vpn ike policy list", # python-neutronclient
    ]
    openstack_subcommands.each do |subcommand|
      output = shell_output("#{bin}/openstack #{subcommand} 2>&1", 1)
      assert_match "Missing value auth-url required", output
    end
  end
end
