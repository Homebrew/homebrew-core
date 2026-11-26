class Openstackclient < Formula
  include Language::Python::Virtualenv

  desc "Command-line client for OpenStack"
  homepage "https://openstack.org"
  url "https://files.pythonhosted.org/packages/77/8f/7db6475d80e19ad8436c9a59c7cc97f369a5e882aa1310f9ac6d13577d94/python_openstackclient-10.6.0.tar.gz"
  sha256 "abca80ab04e40c3045dcedeff55620b58ceb1a5cdb96f437be79f4add64d11b6"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "f90e08b30a5b1e83ce4e76d786ff94e467d63b49ca89a35141f04050fee078a6"
    sha256 cellar: :any, arm64_golden_gate: "93c941a6aff5c3268bd27eec560c9b923618526c3ce7a7d13e164d50292a3914"
    sha256 cellar: :any, arm64_tahoe:       "939449d39f1165d0676fca9779776f2efe87c1d97825f916f698f30b98f39b60"
    sha256 cellar: :any, arm64_sequoia:     "aa127091a1ac833da56b7b93ec9393c6a360b75a84c8ec833be64541d8dd7c4f"
    sha256 cellar: :any, arm64_linux:       "1df4129b2d7838475674ceeb9e1a3416ac745c475ad3b7adf889b9e90d002f70"
    sha256 cellar: :any, x86_64_linux:      "705a74e2168f91c2108206e25e43374ea7e3e6b50aae904c84000bc31df38a80"
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
    url "https://files.pythonhosted.org/packages/c2/c3/cae6d3bdefd96a941ffc247c714ac4babc488a69012e11c058f6c17c6c47/charset_normalizer-3.5.3.tar.gz"
    sha256 "a250888753faa289e2997962fbb17c4960cbdb58575533ca6fceee68c224bdff"
  end

  resource "cliff" do
    url "https://files.pythonhosted.org/packages/56/6e/489e409e86bb5e9059816154d6d3318bceb0e32f05a14e63c66e89a5edfa/cliff-4.17.0.tar.gz"
    sha256 "3ad61eee415a48784b42d88bdae4e17eef2a704ef64dbc529bb7936f68f0a200"
  end

  resource "cmd2" do
    url "https://files.pythonhosted.org/packages/79/36/ae4f8fe6314ae40ad28206e14c25aac1eb60f056589273cb6d4e11f986c8/cmd2-4.4.3.tar.gz"
    sha256 "6153a28f9b019f31c8fc784b18489edade5852609c913cf5fa36d179bd581a63"
  end

  resource "debtcollector" do
    url "https://files.pythonhosted.org/packages/53/a9/e2c78de30679b941c2cc9f818f69aec4f3207861f273bdfbdc943677717e/debtcollector-3.2.0.tar.gz"
    sha256 "8e90c35119009c35e94f0c5b101f61d1eb91c614655ce4dd5b9c6f50bb8f090f"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/4e/a2/dc08c667e7e51cb035ffab38ae98d7d0f249092591130db4f67dc26b0021/decorator-5.3.2.tar.gz"
    sha256 "d9883f1b8259e3bfc42565d0bc6fdc760012008552aa449f75efd2d48319b82b"
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
    url "https://files.pythonhosted.org/packages/9c/b5/0236966b8a3d5b9bf147ea81932c0cd59358a77497bdb95d137e5ee3f080/jsonpatch-1.48.tar.gz"
    sha256 "81e9a03754137a1201d9b534ddd599cc0eb5983fe941bce238dc8a76e442bb94"
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
    url "https://files.pythonhosted.org/packages/46/cb/2c3112a061a718d93866c2555dad1e9d53865e4703d0f3be550d252b277b/jsonpointer-3.12.tar.gz"
    sha256 "7a3dcc11b64053eaa9c549e85e413f8d40a075215f793a331bed9182a14251ae"
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
    url "https://files.pythonhosted.org/packages/75/b4/71d5bf07636cd038dd70375e3616748c41665dd15fba492cd86d6b47cabf/keystoneauth1-5.19.0.tar.gz"
    sha256 "c344dbe0d096a01b37e2c282f4ece5c6e96d50811da791c676ef8ef967f45133"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
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
    url "https://files.pythonhosted.org/packages/cc/52/1ec7ead2c7528bf3d1db73e886fa4df10f9e6f0eb7854a448b7090cfcef7/msgpack-1.2.4.tar.gz"
    sha256 "475c44e12f2a5de766a8448783f149c9b33f3f49b88953c6cd739a77d93c732c"
  end

  resource "netaddr" do
    url "https://files.pythonhosted.org/packages/54/90/188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229d/netaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "openstacksdk" do
    url "https://files.pythonhosted.org/packages/9f/85/d7ec36842c3a32b88ea22569b07674af9e30d72e05d190386ea8fd3e2020/openstacksdk-4.25.0.tar.gz"
    sha256 "23c3157032d142e2b6ad5e7582a307cbc513b240509ee2dfdcc8dea8773d2096"
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
    url "https://files.pythonhosted.org/packages/e0/de/cb1867bd233474a8c98bae730fde87d9aea2d954d05e64d5d253878f470c/oslo_config-10.8.1.tar.gz"
    sha256 "50b4f7198779de708d1389eb16121abffe5f60b2452717b253d0fc57c5febd9d"
  end

  resource "oslo-context" do
    url "https://files.pythonhosted.org/packages/2d/fa/cd59c4dbce01e86da0e3f5ab1470e2b492b1eccac39b707aa4f1b2b88609/oslo_context-6.6.0.tar.gz"
    sha256 "56287469ad75819a9beddfce17bc4250fee3f0e949842f9ee45a70718cc3155f"
  end

  resource "oslo-i18n" do
    url "https://files.pythonhosted.org/packages/5e/69/72b03bb4d33f51a157c02d5297227bae48b9c359103856942b8774b608df/oslo_i18n-6.9.0.tar.gz"
    sha256 "574bcf21873b185068bcec951de1ec093158ffdff05a8055fd18ddcb69f69e65"
  end

  resource "oslo-log" do
    url "https://files.pythonhosted.org/packages/13/99/8b0739d0856f6cfe162c99f397e321e150f1dc3d6235de8e4c4e3962f93a/oslo_log-8.4.0.tar.gz"
    sha256 "5021177a1d2b1968f100054aecaf89feb6914424644970b933475fbbb4ac55f5"
  end

  resource "oslo-serialization" do
    url "https://files.pythonhosted.org/packages/af/f5/2611fb291898fa5f3b41c68e916cb060305cb718a043fdbff25026491fc4/oslo_serialization-5.11.0.tar.gz"
    sha256 "8326e85a80856c1068007423fcf6fe29dd2fe57a32f5d87fff0120b555b4b67c"
  end

  resource "oslo-utils" do
    url "https://files.pythonhosted.org/packages/35/25/74f0b7f1d28d96953b3c9e39026f94e9bac59dcb3a0322675de2b29c2acb/oslo_utils-10.3.0.tar.gz"
    sha256 "25f4d339b42c497eae08dc0a5b8727c22cba39f2a62fbf84923d24efcc0ce738"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/c3/75/ffb1dc0ed12352139fb4ca0e3fde4325a23e3d0f3f40efe89717bc4f557b/packaging-26.4.tar.gz"
    sha256 "c4b671c41ddb9bf26e543c37723610d28fb6bf7affc4da17cf048d419d2c062a"
  end

  resource "pbr" do
    url "https://files.pythonhosted.org/packages/6b/8d/ce438c28c7958e33184e8ac851ea2225b47a41e5e9e708fa3bddba631135/pbr-7.1.3.tar.gz"
    sha256 "9a4a85b84e906337708009af0b5f5cdabeeb72d4dc213c9e97974da54fd9acc5"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/71/18/0b0d99f5bf164f04a7a9534c3dbdbe4d5fd2b382667685ad40c192c4d3d1/platformdirs-4.14.8.tar.gz"
    sha256 "96893d686e84e9e6f358a9ea41a8de544df66dbf2ba6cda250e7dc73acf85b9b"
  end

  resource "ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "prettytable" do
    url "https://files.pythonhosted.org/packages/a5/40/61fccab02f0021d99251c4a34d989a72a1b76da658f84d87541af709773e/prettytable-3.19.0.tar.gz"
    sha256 "0ecedd6d9a560b330503bef15791b77954fa46b7123203d91e463330b61959ba"
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
    url "https://files.pythonhosted.org/packages/18/39/b3927f3616f6223832f9b760e4208e8a7c7e1dea2b4d9ad7d32a5d214c3a/python_dateutil-4.0.0.tar.gz"
    sha256 "d7295ff14fdc0f92f662100bfb6c551d160ca090f2939f1ec5b9794265c03f06"
  end

  resource "python-designateclient" do
    url "https://files.pythonhosted.org/packages/c3/72/95f837ac31cad62bc62db5ebffcd995fcf58370e34f6b79b5ff95a22fd2a/python_designateclient-7.1.0.tar.gz"
    sha256 "e37c88c2c3e6b61bbd3651f24ef1a2f8b37ae272bc3466160702de67262ef10f"
  end

  resource "python-glanceclient" do
    url "https://files.pythonhosted.org/packages/6a/1d/07190e9104876c96a671f39fcdda8c3ac6daa8dbc2657c35b1d376b39c83/python_glanceclient-4.14.0.tar.gz"
    sha256 "3b619250228b62b69d743efd3114c280fdf7f850d5599dd749e3426ce24200ad"
  end

  resource "python-heatclient" do
    url "https://files.pythonhosted.org/packages/09/04/323b1f96de2880f7fd7c6b88730aae6c685f1935ffedd8b470b9605849af/python_heatclient-5.3.0.tar.gz"
    sha256 "3b34e9ab39578d0aca397863dded42a026c86ea46143ef9a490a875affabe66c"
  end

  resource "python-ironicclient" do
    url "https://files.pythonhosted.org/packages/2c/06/c68295f546559ca5f640450681c964d08aea5b31236a185980f8b7c1e132/python_ironicclient-6.4.0.tar.gz"
    sha256 "092ade0fe1bf3fd8197adf168bad2e967fac9fb82faaee6c640cc4f8f7fcfab3"
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
    url "https://files.pythonhosted.org/packages/88/e4/3255e451e799ac437bc164f941ad434a06534d6542082d2ec414c9e8ff25/python_manilaclient-6.4.0.tar.gz"
    sha256 "20d13c802f68dab33c04b204a4b8864908b4b6eb6794cc6ee5b92385e6156943"
  end

  resource "python-mistralclient" do
    url "https://files.pythonhosted.org/packages/10/02/5efe79e6be2180bb1a9d343db1f5000bc92caae35ca46bb36b2394a3e80a/python_mistralclient-6.4.0.tar.gz"
    sha256 "cca5cd88ddefdaf1375a62049150d96a4841171a2c5fa306ed8b3f3544ddc107"
  end

  resource "python-neutronclient" do
    url "https://files.pythonhosted.org/packages/ee/1f/4127071ca46967863d3bff607b82970ab4136b8394137a8481e1923c8637/python_neutronclient-14.1.0.tar.gz"
    sha256 "c9011176bfeb5a4d49766fb7cef8fc46b5f1db791e5c100849536117d03a1fe4"
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
    url "https://files.pythonhosted.org/packages/76/b8/c0b780928e2fb1c87e9e375818c6f121da2398b071012d1747be300b83f4/pyyaml-6.0.4.tar.gz"
    sha256 "e24bf71af8a432d7808fabff134d38dfe16d3cbb41f2873bb4b1e42422de0a1a"
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
    url "https://files.pythonhosted.org/packages/7a/ec/b628c3b1613fe9340de1c5daba957f5b152159ac350b6ce4ad3d2469f822/stevedore-5.10.0.tar.gz"
    sha256 "6005f32c09dc3159802a61c04862770e439e32db22f6da78ba56e8a735466882"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/7a/29/6a1391d31cd00ff9e927215a224a880e1e84e826b64ba80a499e51c074d8/tzdata-2026.6.tar.gz"
    sha256 "85d2cd9c09f81f0bb29db27759fc83af4f1e620efb814f8c5bf8b4cc4feece6d"
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
    url "https://files.pythonhosted.org/packages/8e/da/d59374b2c893ae70a41fdb064637ccef218f25df8c67e5431a96708235d9/wcwidth-0.9.5.tar.gz"
    sha256 "713534e2ecb16e0fc39f19e0a5dda997da76d010953e9e8f803e7971f8accd80"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/9c/b0/f752d19e1e83ab8bd64aeccfde32ff086aee3ef08520f7340b69a8d0a4d2/wrapt-2.5.2.tar.gz"
    sha256 "551cb49e88b3722faad780303833bc4fa70685fb1773270fb98b40d39d9fddbf"
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
