class Apm < Formula
  include Language::Python::Virtualenv

  desc "Dependency manager for AI agent configuration"
  homepage "https://microsoft.github.io/apm/"
  url "https://files.pythonhosted.org/packages/30/ac/cdfcdd0bcb7e070e3d02f901863d354bbf7b9a4bbace6babad7aace7725f/apm_cli-0.31.0.tar.gz"
  sha256 "bb1cd2e86fc04545fc2ad4cea96660614df002b78ee1dbb8085ce5141722253d"
  license "MIT"
  head "https://github.com/microsoft/apm.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7e8d7f395471b5418df63af1788bb3961940c3c98079b527cca160a05ea7c75c"
    sha256 cellar: :any, arm64_tahoe:       "a3c59b3c15b35708e08d75311cd713a3f4dcae4fd61c863833dca02094e404ce"
    sha256 cellar: :any, arm64_sequoia:     "7c34d18acfb2391a77b7e5f5bce6c36c8ed95c417d95b0a72d8e1e3d5a042e1e"
    sha256 cellar: :any, arm64_linux:       "5c243353d774c02f554583efca71c1b7ab96fc7beb4994a131a2145d3b600e1c"
    sha256 cellar: :any, x86_64_linux:      "f473de38b379b0e837ada64aeff5248cba5d3a2fc51c973f182c320933a711e9"
  end

  depends_on "rust" => :build # for jiter
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  pypi_packages package_name: "apm-cli", exclude_packages: ["certifi", "pydantic"]

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/ce/f4/eec0465c2f67b2664688d0240b3212d5196fd89e741df67ddb81f8d35658/aiohappyeyeballs-2.7.1.tar.gz"
    sha256 "065665c041c42a5938ed220bdcd7230f22527fbec085e1853d2402c8a3615d9d"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/58/d9/22ce5786ac0c1653ae8b6c23bded02c1686d11f0dbb45b31ce128e0df985/aiohttp-3.14.3.tar.gz"
    sha256 "9491196535a88924a60afd5b5f434b5b203b6cc616250878dbdb223a8f7844bc"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "azure-ai-inference" do
    url "https://files.pythonhosted.org/packages/4e/6a/ed85592e5c64e08c291992f58b1a94dab6869f28fb0f40fd753dced73ba6/azure_ai_inference-1.0.0b9.tar.gz"
    sha256 "1feb496bd84b01ee2691befc04358fa25d7c344d8288e99364438859ad7cd5a4"
  end

  resource "azure-core" do
    url "https://files.pythonhosted.org/packages/a6/f3/b416179e408990df5db0d516283022dde0f5d0111d98c1a848e41853e81c/azure_core-1.41.0.tar.gz"
    sha256 "f46ff5dfcd230f25cf1c19e8a34b8dc08a337b2503e268bb600a16c00db8ad5a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e5/3f/143b048436775b0f76ac3eec145c019e8173ccc2885c8f20319b996d5e83/charset_normalizer-3.5.1.tar.gz"
    sha256 "6117b84ea48435e5356dc737f5121485c30920ba43375fa7b434fd753df0eac3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "condense-json" do
    url "https://files.pythonhosted.org/packages/d1/a5/7158b674fa5b890d80faaf42dd438d1a765661cd22430ddf499759cf44e1/condense_json-1.1.tar.gz"
    sha256 "c455b54bbbab89a69f598b09f2003a89b738df20d30e6aa341c495401ec5b349"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/38/46/126b1831dca12060d4a8296bf9c4fe5c93c4f22197fa239cb0cc82042bba/filelock-3.32.6.tar.gz"
    sha256 "a3f55a18af3652a94d8f47d6055df434f254ca1d02ef2524850c6d249ca2512c"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/e0/db/3ca813cbacb23ab6fe46ff38a9b5ef8e73e970c8051f2ce903aacafe0446/gitpython-3.1.62.tar.gz"
    sha256 "1791de66309bc0c7cfca40bf8d2e3de7ca091cbf94e6051be1ad0722c61062af"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/15/8c/e925b1c92018abb3a1863ce1549d76d2381e334d21d65d4ac8f65dabd78a/httpcore2-2.13.0.tar.gz"
    sha256 "2adc8be4fb285fbcd6d894298db3b52c177e74b6674eda3a76bd36be3292a3db"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/b9/a0/e9deef4654132857b5a5dbe4eddd0ac59c2814500e11f2f5044cd81103ee/httpx2-2.13.0.tar.gz"
    sha256 "81bd07dc67a3701729ef1f777a3c00c915d4539604fdb5afd327f8682f6b7b44"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/5f/f7/abb373e5757eaec4b922b92f97ec8d6d7e057cf06778247604fbc4e7c3f3/idna-3.19.tar.gz"
    sha256 "5e0811a4383b21dc5838069f801c4fb62113b7447663d2530d2bd6e77b49bf15"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/54/4d/e940025e2ce31a8ce1202635910747e5a87cc3a6a6bb2d00973375014749/isodate-0.7.2.tar.gz"
    sha256 "4cd1aa0f43ca76f4a6c6c0292a85f40b35ec2e43e315b59f06e6d32171a953e6"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9c/1f/8176d92e001f86505424b41664032ae26a882bc9ca41a32c803f373f9195/jiter-0.17.0.tar.gz"
    sha256 "03e432f226a453851079fb84cd17c6da9991eab723e28d716f14ae3d906e0c12"
  end

  resource "llm" do
    url "https://files.pythonhosted.org/packages/b5/68/baeda27122a280940c5e9ae7291b821fa96ea23f50a00f568e9cff0c3aac/llm-0.35.tar.gz"
    sha256 "2ee0955b2e372408813ce966f3d03ad2c7419b85a547880c53797d31d3a3fdb6"
  end

  resource "llm-github-models" do
    url "https://files.pythonhosted.org/packages/2c/b5/714d6c7683cf5ffcf0352951a83ea9d952bd6052900b9e7ccb2a3b09ce0a/llm_github_models-0.18.0.tar.gz"
    sha256 "b778aa6fa43e53ecb3b868fcf9875bc0e760a774a1fad76ea907a269582a2043"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/14/95/989c1b5ca17b72128661530cd6e351a0a83cda9a4d6c036e9ed976c18931/multidict-6.8.0.tar.gz"
    sha256 "5cd4637ce76312ba1e05eb9c5193fec231f64fee0944e135fa1e951242355b37"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/d0/88/472211fbaee888238d2e0657bcfdba5f64f3d38899dbfdada5e632a9758f/openai-3.14.0.tar.gz"
    sha256 "714ba70b91ee1e78e75263694bebfeaca004432032685333a46d0e0206114bf9"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/a7/a6/9e6708e2a34a43f1070246c8d0e773e315cc4fdb598a9cdb8ff7d0c450b2/propcache-0.5.3.tar.gz"
    sha256 "5f283fde8fd8b1944fd1a1bd11db759b55c5f190795668d5187d3e3b1165d98b"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-frontmatter" do
    url "https://files.pythonhosted.org/packages/9d/e8/79cbe69864d44f3b48e70ebee0a872a7d5a4e7150c9f8577ed7a5beefff0/python_frontmatter-1.3.0.tar.gz"
    sha256 "acc73e477a568dc2a25c9e130c6c68ae8daa8c204c8f7e813db47d6a7280dcf2"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/d6/41/65079023c81491a21799c0120bce5925366b6913596bf797806f19973290/python_ulid-4.0.1.tar.gz"
    sha256 "bbeec02556190bb9dc3401faa7268696acbfbe7b6db9908c155dc3548629f20c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/96/3e/5688fdd83aea416de336582a274f2bc8236b5c261b04c11e17bc262786ad/rich_click-1.9.9.tar.gz"
    sha256 "324cba7513cd4187ee92b2eef21f071714e45be062458c8b157bd7e0c81103e3"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/6d/44/f5da03a8ef95d369145c5bb53050e7877c9f3d312e128605fd9504829143/setuptools-84.0.0.tar.gz"
    sha256 "f4695c21257f0d9b537ec2692c941d02ee143b7cc1276941349a546573b2ef73"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/1f/ea/49c993d6dfdd7338c9b1000a0f36817ed7ec84577ae2e52f890d1a4ff909/smmap-5.0.3.tar.gz"
    sha256 "4d9debb8b99007ae47165abc08670bd74cb74b5227dda7f643eccc4e9eb5642c"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/7e/6b/4a7b3d20c92e6c7acedc96ef620df8e1ea8f94a26a41ab788c1c08055815/sqlite_utils-4.2.1.tar.gz"
    sha256 "76114b6a5414714e6c70e5fa5c4781b301b590f6951b5da39c8cc60c21382ba1"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/94/96/e07752635b98536177fa1f37671c8f3cdde2e724c6bcf6034b2cfb571565/tomlkit-0.15.1.tar.gz"
    sha256 "e25bbf38843005246210a12982776f27f99cb9be67160e14434d0c0d21ee1e97"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "watchdog" do
    url "https://files.pythonhosted.org/packages/db/7d/7f3d619e951c88ed75c6037b246ddcf2d322812ee8ea189be89511721d54/watchdog-6.0.0.tar.gz"
    sha256 "9ddf7c82fda3ae8e24decda1338ede66e1c99883db93711d8fb941eaa2d8c282"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/75/16/e8be8e2fb175bbf41a0680381a319f1199fae256588241a2ac8677eafb49/yarl-1.25.1.tar.gz"
    sha256 "03dd38de09bc213e9a8b29761eec33ee1d5318dac0e49d8af36e4d27830e23a7"
  end

  def install
    inreplace "src/apm_cli/update_policy.py" do |s|
      s.sub! "SELF_UPDATE_ENABLED = True", "SELF_UPDATE_ENABLED = False"
      s.sub! "SELF_UPDATE_DISABLED_MESSAGE = DEFAULT_SELF_UPDATE_DISABLED_MESSAGE",
             'SELF_UPDATE_DISABLED_MESSAGE = "Self-update is disabled; use `brew upgrade apm` instead."'
    end

    virtualenv_install_with_resources
  end

  test do
    system bin/"apm", "init", "--yes", "--target", "copilot", "."
    assert_path_exists testpath/"apm.yml"
    config = (testpath/"apm.yml").read
    assert_match "name: #{testpath.basename}", config
    assert_match "version: 1.0.0", config
    assert_match(/targets:\n- copilot/, config)
  end
end
