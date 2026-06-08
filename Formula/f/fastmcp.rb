class Fastmcp < Formula
  include Language::Python::Virtualenv

  desc "Fast, Pythonic way to build MCP servers and clients"
  homepage "https://gofastmcp.com/getting-started/welcome"
  url "https://files.pythonhosted.org/packages/29/18/46beaec18c9f86a599ae3f9cdf6677dd6b50240cfd844d18233710b47f13/fastmcp-3.4.2.tar.gz"
  sha256 "b468722946fc467c3796a6572f7a14d93d48c014cf8fea12910245220cbbe4e1"
  license "Apache-2.0"
  head "https://github.com/jlowin/fastmcp.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8d2f06dd62e7c30ca425d014281bb4769246b166a1201ea553c028dde10059a9"
    sha256 cellar: :any, arm64_sequoia: "4af4f9e5d44ca7561503a478df94805aafabe17658be42a488bc484047cad049"
    sha256 cellar: :any, arm64_sonoma:  "e633212cad12341336ea6222f42c5e7392f14e69bd233b861375646da086e3bd"
    sha256 cellar: :any, sonoma:        "0352f210c5d9afb9d515f0ce8c6a6003ade97a10ab4cf8cd7c1d46340d41a330"
    sha256 cellar: :any, arm64_linux:   "9f76a76a654bd6363ce3bed59153cc59eff03989e1c4daec34a14166c745bf55"
    sha256 cellar: :any, x86_64_linux:  "f8557324baaeb4ce1298c7d162af39bb2a4b43880c7ee993200b532b21efcc6f"
  end

  depends_on "rust" => :build # for py_key_value_aio
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage
  depends_on "uv"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic rpds-py],
                extra_packages:   %w[jeepney secretstorage]

  resource "aiofile" do
    url "https://files.pythonhosted.org/packages/48/41/2fea7e193e061ce54eacc3b7bc0e6a99e4fcff43c78cf0a76dd781ed8334/aiofile-3.11.1.tar.gz"
    sha256 "1f91912c6643d2a4e49ca4ae3514f0bf3867ce948a36d99a6411b8f4755f4cf9"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/36/98/7d93f30d029643c0275dbc0bd6d5a6f670661ee6c9a94d93af7ab4887600/authlib-1.7.2.tar.gz"
    sha256 "2cea25fefcd4e7173bdf1372c0afc265c8034b23a8cd5dcb6a9164b826c64231"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/c7/94/1009e248bbfbab11397abca7193bea6626806be9a327d399810d523a07cb/beartype-0.22.9.tar.gz"
    sha256 "8f82b54aa723a2848a56008d18875f91c1db02c32ef6a62319a002e3e25a975f"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/f4/8b/0d3945a13955303b81272f759a0331e54c5c793da455e6f5706b89d2639c/cachetools-7.1.4.tar.gz"
    sha256 "437f55a4e0c1b01a4f3077cc470e6991d47430970e36fbcb77e2be0df4fc1cd6"
  end

  resource "caio" do
    url "https://files.pythonhosted.org/packages/92/88/b8527e1b00c1811db339a1df8bd1ae49d146fcea9d6a5c40e3a80aaeb38d/caio-0.9.25.tar.gz"
    sha256 "16498e7f81d1d0f5a4c0ad3f2540e65fe25691376e0a5bd367f558067113ed10"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/34/07/bf61d13de86d96a4c46aff00c9ca0eced44bcc8c3e16280605c1253e5720/cyclopts-4.16.1.tar.gz"
    sha256 "8aa47bf92a5fb33abca5af05e576eecdb0d2f79893ad29238046df78370fc4a8"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/50/79/66800aadf48771f6b62f7eb014e352e5d06856655206165d775e675a02c9/exceptiongroup-1.3.1.tar.gz"
    sha256 "8b412432c6055b0b7d14c310000ae93352ed6754f70fa8f7c34141f91c4e3219"
  end

  resource "fastmcp-slim" do
    url "https://files.pythonhosted.org/packages/a3/2e/d627b28b7403ecc526991ef732921b08bde010006e6148635f053fd29f4c/fastmcp_slim-3.4.2.tar.gz"
    sha256 "290646e0955a516235a317151034559aa48336cb843d3f006131aedad8759bb4"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/9d/82/74f4a3310cdabfbb10da554c3a672847f1ed33c6f61dd472681ce7f1fe67/griffelib-2.0.2.tar.gz"
    sha256 "3cf20b3bc470e83763ffbf236e0076b1211bac1bc67de13daf494640f2de707e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
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
    url "https://files.pythonhosted.org/packages/36/cf/ea4ef2920830dea3f5ab2ea4da6fb67724e6dca80ee2553788c3607243d0/jaraco_functools-4.5.0.tar.gz"
    sha256 "3bb5665ea4a020cf78a7040e89154c77edadb3ca74f366479669c5999aa70b03"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/d3/c3/2f590052b55cbdd0ace470ee7ee1f685f6882051be93a9374891005623e2/joserfc-1.7.0.tar.gz"
    sha256 "4aced6ab0c47846f0a531402aec2419a874b91e918df9c4c9da8a82fb559d6c4"
  end

  resource "jsonref" do
    url "https://files.pythonhosted.org/packages/aa/0d/c1f3277e90ccdb50d33ed5ba1ec5b3f0a242ed8c1b1a85d3afeb68464dca/jsonref-1.1.0.tar.gz"
    sha256 "32fe8e1d85af0fdefbebce950af85590b22b60f9e95443176adbde4e1ecea552"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-path" do
    url "https://files.pythonhosted.org/packages/39/79/cd02a4df6d9270efdc7d3feefe6edd730b0820c39eeaa107a2faee8322d5/jsonschema_path-0.5.0.tar.gz"
    sha256 "493b156ba895c97602655b620a8456caa2ce08c1aa389f5a7addec065e6e855c"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/27/3c/347cf965d313f5d41764e7d46bea6ffe7d9ef13b983cc429b0340962a082/mcp-1.27.2.tar.gz"
    sha256 "8e02db104096d1c25b28e64bde29a5c32b31bc241710213e12fd4d84985bdfef"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/b4/1c/125e1c936c0873796771b7f04f6c93b9f1bf5d424cea90fda94a99f61da8/opentelemetry_api-1.42.1.tar.gz"
    sha256 "56c63bea9f77b62856be8c47600474acad853b2924b99b1687c4cb6297166716"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/66/f3/5a20387de9bcd0607871bfc2198ee0e15836da7baa4592ccd7f24c27c986/pathable-0.6.0.tar.gz"
    sha256 "6404b8b82aef5ff0fd478934137128b99b12212ba35afdde5525ca4f8388ea58"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/47/e4501f49c178ae1d9f4a75073fda4204f52647993f075a9db4d14930e0c5/platformdirs-4.10.0.tar.gz"
    sha256 "31e761a6a0ca04faf7353ea759bdba55652be214725111e5aac52dfa29d4bef7"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/fb/e2/d689d922894a7ecde73b6daeaf9b13dab5aae06fe6aaaf7514722644d382/py_key_value_aio-0.4.5.tar.gz"
    sha256 "c6563a2c6abe5da5e20f4f9e875c2a9b425a2244a54fadbf46cf140a9eea45d7"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/07/60/1d1e59c9c90d54591469ada7d268251f71c24bdb765f1a8a832cee8c6653/pydantic_settings-2.14.1.tar.gz"
    sha256 "e874d3bec7e787b0c9958277956ed9b4dd5de6a80e162188fdaff7c5e26fd5fa"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/57/56/3191bae66b08ccc637ea8120426068bcb361cc323c96404c310886937067/rich_rst-2.0.1.tar.gz"
    sha256 "cbe236ed0901d1ec8427cc6a50bf0a34353ba28ad014dc24def68bfe7f3b9e68"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/f7/2b/58abc2d1fd397e7dde08e947e05c884d8ef2f78d5e2588c17a12d42d6994/sse_starlette-3.4.4.tar.gz"
    sha256 "07e0fa0460138baf25cdd5fb28683472c3995dc1642225191b3832d62526bcb0"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/25/44/ec35f1b6e83094b997da438a02c8c9b0ade2b1e84cfc48bd4656780760a6/starlette-1.2.1.tar.gz"
    sha256 "9b9b5ebb992e67d6093741e63c2f59e4f6fff986f81163c087867bd7b924b3f6"
  end

  resource "uncalled-for" do
    url "https://files.pythonhosted.org/packages/b5/82/345cc927f7fbdae6065e7768759932fcc827fc20b29b45dfbafa2f1f7da4/uncalled_for-0.3.2.tar.gz"
    sha256 "89f5dbcd71e2b8f47c030b1fa302e6cce2ec795d1ac565eeb6525c5fe55cb8a2"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c4/1f/fa18009dea8469069cca78a4e877a008ab78f08b064bfc9ab891579077ff/uvicorn-0.49.0.tar.gz"
    sha256 "ebf4271aa580d9de97f93192d4595176df6e91f9aae919ca73e4fc07df1e66a3"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/cd/41/5e1a4bb12aac5f1493fa1bdc11154eca3b258ca4eba65d39c473fe19d8e9/watchfiles-1.2.0.tar.gz"
    sha256 "c995fba777f1ea992f090f9236e9284cf7a5d1a0130dd5a3d82c598cacd76838"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
  end

  def install
    without = %w[jeepney secretstorage] unless OS.linux?
    virtualenv_install_with_resources(without:)

    bin.install_symlink libexec/"bin/fastmcp"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fastmcp --version")

    (testpath/"server.py").write <<~PYTHON
      from fastmcp import FastMCP

      mcp = FastMCP("Demo 🚀")

      @mcp.tool
      def add(a: int, b: int) -> int:
          return a + b
    PYTHON

    port = free_port
    ENV["FASTMCP_STATELESS_HTTP"] = "1"
    pid = spawn bin/"fastmcp", "run", "server.py:mcp", "--transport=http", "--port=#{port}", "--no-banner"

    begin
      data = <<~JSON
        {
          "jsonrpc": "2.0",
          "id": "1",
          "method": "tools/call",
          "params": {
            "name": "add",
            "arguments": {"a": 1, "b": 2}
          }
        }
      JSON

      system "curl", "--silent",
                     "--retry", "5",
                     "--retry-connrefused",
                     "--request", "POST",
                     "--header", "Content-Type: application/json",
                     "--header", "Accept: text/event-stream, application/json",
                     "--output", testpath/"response.txt",
                     "--data", data,
                     "http://127.0.0.1:#{port}/mcp"
      assert_match '{"result":3}', (testpath/"response.txt").read
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
