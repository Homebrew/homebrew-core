class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/22/71/6d547b55339323f2e1c681956baeb36559486c6dccb8b20aa9de03a5dbf5/python_openstackclient-10.5.0.tar.gz"
  sha256 "a9c77b8d2b53a9413794daa5d60cbb4fa669af64799b704cfb96d75f2e002e8e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4b837a418215dafccf7ee37126a46e2b247feedebacca1640238cc8014a9ae1c"
    sha256 cellar: :any, arm64_tahoe:       "8a76e413d3e9383505dade9eac353ba35ded8f61e4f714a8a60535552a6efb5c"
    sha256 cellar: :any, arm64_sequoia:     "4c302988039fd46e143af221ce64878fec2bb4f6521823971b9a4447a7b08a62"
    sha256 cellar: :any, arm64_linux:       "0e6cc1aff9ffc6e76b78ee140fdf3d5a562879b496396071f2ed8f41fbb5c6d8"
    sha256 cellar: :any, x86_64_linux:      "b896f9e1b28c58e3b494596017af06901072e79319717eb5f1ea6868cbb75396"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.15"
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
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/56/6e/489e409e86bb5e9059816154d6d3318bceb0e32f05a14e63c66e89a5edfa/cliff-4.17.0.tar.gz"
    sha256 "3ad61eee415a48784b42d88bdae4e17eef2a704ef64dbc529bb7936f68f0a200"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/59/3d/00013c589942389ffb3db58160f062c7e2a496b5c31c370aab88c25e5588/cmd2-4.3.0.tar.gz"
    sha256 "3f6c4b9619dbd0d1ba75789a099be82b65daf8ac1d97b8e4ecb112e76c72b100"
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
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
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

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "jsonpatch" do
    url "https://files.pythonhosted.org/packages/8e/39/c534bb172e9318400d5631074b1eda6c78b7c918d0f04233b50caa8e2c10/jsonpatch-1.36.tar.gz"
    sha256 "7e110cb3c5a1c8768f7170bf8fb9887c4aa575fba74c95239e868b494bd9a522"
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
    url "https://files.pythonhosted.org/packages/52/77/9be5cce647fa4d7afa9047c0c1029bc73292c27430e64fc9d2393ccf6727/jsonpointer-3.4.tar.gz"
    sha256 "e57015ae65af3821c6a3976069860789cf326103f38b22b2178d41d021adad25"
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
    url "https://files.pythonhosted.org/packages/04/af/268e14554c6bd4a2614872fb2b8431e466ce01415a9783b260ce7fb7ae5c/keystoneauth1-5.18.1.tar.gz"
    sha256 "8970f9d103f335c39151366d70c001d1bb99b00d73845f03d47825e8dc35ff78"
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
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/0a/e7/bb605a7bab2d8425a64b3fa762b39dc1bf1c7e3f11ba6fb5413d6db0ff8c/msgpack-1.2.3.tar.gz"
    sha256 "32edb81a2b5eb7cd7c9d941b2bfbbb082fd2cd09e0e725930316af6b708db186"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/36/de/da119a0fd6ad3794ccc55c4723a50e6db415d495f77ae083622a275d94a3/openstacksdk-4.22.0.tar.gz"
    sha256 "757f399346f804d0a70b83fead919c498521e509889cd8973ece5cf7a640e6f9"
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
    url "https://files.pythonhosted.org/packages/11/ae/aad4d9ae5afdca9d09d41b498fced798dbda03f0e64281f9d410f72a639e/oslo_log-8.3.2.tar.gz"
    sha256 "478a5cbae4375c42f2e114ea0aafda105b8753b9b8bd1acc09d154a254048002"
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
    url "https://files.pythonhosted.org/packages/6b/8d/ce438c28c7958e33184e8ac851ea2225b47a41e5e9e708fa3bddba631135/pbr-7.1.3.tar.gz"
    sha256 "9a4a85b84e906337708009af0b5f5cdabeeb72d4dc213c9e97974da54fd9acc5"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
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
    url "https://files.pythonhosted.org/packages/e4/11/b213bebff182584360cb8d17c72c1677fec5c5c228de439e63bcf8ab1c8f/pyparsing-3.3.3.tar.gz"
    sha256 "928ae7e20211f3b6f3915a72f06a0cfd29ab9d24279dd6346b6b1a7146397d36"
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
    url "https://files.pythonhosted.org/packages/0e/df/f15f80383f152452d8985b36d95cb8751f901a3e0ff4cd27f7e118f168e2/python_dateutil-3.0.0.tar.gz"
    sha256 "7ebcb3c29a92f3ceafe79a7a48a5c45677e9e004bbeec5742ac0bbb00560b7a2"
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

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/70/b3/c19426f783614d625699a4b247faf628ea9ab1db228674491767b417f9e1/setuptools-84.2.1.tar.gz"
    sha256 "3ff8b3b5492a0aa66960f4419365a86b84e013070d4313e4d4a6894f5d64d6bc"
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

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/d9/68/f1b440335057bfce71b6e50a9d09445aa2ecbd08359a337976627b8409e7/tzdata-2026.5.tar.gz"
    sha256 "8cc73c0a0bfca7dbfa59235d60b2eff82231dee33f53d206db1acd9173cfc0a7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "warlock" do
    url "https://files.pythonhosted.org/packages/29/c2/3ba4daeddd47f1cfdbc703048cbee27bcbc50535261a2bbe36412565f3c9/warlock-2.1.0.tar.gz"
    sha256 "82319ba017341e7fcdc81efc2be9dd2f8237a0da07c71476b5425651b317b1c9"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/69/4a/82d61476a1ccc20d43d0805724c5de4baa4971131a8db1816705ef53fe16/wcwidth-0.9.3.tar.gz"
    sha256 "dfe7cfbd4cb59db9fe0931bd6091ab4a95b3acc5d56bfb50fa9fef0ccba5dc5c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/04/22/89e2f3bdae5cb34e0cab0cd86d7172dbf418de4b46c9b17b9c7a560dfa44/wrapt-2.5.1.tar.gz"
    sha256 "f595bb0185aab3e9dc31950c95d914f56ea8278810c3b928f3426e12ed6d27bc"
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
