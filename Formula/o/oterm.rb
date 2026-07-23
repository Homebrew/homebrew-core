class Oterm < Formula
  include Language::Python::Virtualenv

  desc "Terminal client for Ollama"
  homepage "https://github.com/ggozad/oterm"
  url "https://files.pythonhosted.org/packages/1d/19/23455c1d66786bca4d4c35fec11dfd92cd1b7eaad53d04ef4465b39950ca/oterm-0.20.0.tar.gz"
  sha256 "0974b01d228124426dd9178ff5e2682d4317f3814d927e385ae3389e7ad46e3d"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "58d2034ed936ff64d154fa3d16ce541a1133b66f47c8bcfe52a4cdb8c59cd810"
    sha256 cellar: :any, arm64_sequoia: "2905055e7cd9c3cb4b36fe301f033449ad46fa922b11ab67f9101d7eb2739fd4"
    sha256 cellar: :any, arm64_sonoma:  "aae8f9d5849ed6cfe35060963df15a0c880617449438036d2b277b3511b7a6ee"
    sha256 cellar: :any, sonoma:        "6f7586f05429ce4f16f4713c48d8223a9d00ccc3d5526a6b36af1db2046bf760"
    sha256 cellar: :any, arm64_linux:   "fd00fd67ab6c80fe167c876082de10fd5beafadfe8a7895ac191a8465382184d"
    sha256 cellar: :any, x86_64_linux:  "37624244a9a97d27955cdd4ea9defd7386c60092acd16f51864d21c05c210ad9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for textual_speedups
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  on_linux do
    depends_on "openssl@3"
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic rpds-py],
                extra_packages:   %w[jeepney secretstorage]

  resource "aiofile" do
    url "https://files.pythonhosted.org/packages/48/41/2fea7e193e061ce54eacc3b7bc0e6a99e4fcff43c78cf0a76dd781ed8334/aiofile-3.11.1.tar.gz"
    sha256 "1f91912c6643d2a4e49ca4ae3514f0bf3867ce948a36d99a6411b8f4755f4cf9"
  end

  resource "aiosql" do
    url "https://files.pythonhosted.org/packages/dc/31/97ebbd15ead5cf9c3951d6e8dfafc5e7b7e8c52148768cb7b95cd443fc8a/aiosql-15.0.tar.gz"
    sha256 "744939fdfb3e0c36d88ccaf1f73cb1cf8cc38e7052666b884502db99aff8f3fd"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/41/0d/8f71d535edb0d438f023bd825fb65f67c14fa88a2bd6b75f292a58a63de4/anthropic-0.117.0.tar.gz"
    sha256 "98107f2b76439641e0ae2a1754087534b8f178dbab99d6eb1bc4b7bc8c744496"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
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

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/d8/93/5f98e422ced57a359e3b7827ab79b359d67456abb9c5840b0c5eb7b90e6b/boto3-1.43.52.tar.gz"
    sha256 "3da09a393c050906d407023bee5fb5b5fb333378513af1a1a51159db870b572f"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/4d/18/f6f02b1acea9a7c42571813ad4c3e19460206e67ca99af402b7ae3d7584d/botocore-1.43.52.tar.gz"
    sha256 "3c25e11796ae6e295f1cc3a7760e808c26c432cd580d6a608f32da24715c389b"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/f4/8b/0d3945a13955303b81272f759a0331e54c5c793da455e6f5706b89d2639c/cachetools-7.1.4.tar.gz"
    sha256 "437f55a4e0c1b01a4f3077cc470e6991d47430970e36fbcb77e2be0df4fc1cd6"
  end

  resource "caio" do
    url "https://files.pythonhosted.org/packages/92/88/b8527e1b00c1811db339a1df8bd1ae49d146fcea9d6a5c40e3a80aaeb38d/caio-0.9.25.tar.gz"
    sha256 "16498e7f81d1d0f5a4c0ad3f2540e65fe25691376e0a5bd367f558067113ed10"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "cohere" do
    url "https://files.pythonhosted.org/packages/23/d7/3706b69660b24f82e530b31d74956a2e717de09cebce3a538429fef17698/cohere-7.0.7.tar.gz"
    sha256 "a4be903dbe5800ed27430d08896dbd92f854f35ca288764b6459bd5874c50730"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
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

  resource "eval-type-backport" do
    url "https://files.pythonhosted.org/packages/1c/15/273a4baf8248d6d76220723c3caf039d283774b31a7c46ba686120145b76/eval_type_backport-0.4.0.tar.gz"
    sha256 "8397d25e6524c2e67b9576bb0636be27dea2192017711220c534ec2de921e9b0"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/50/79/66800aadf48771f6b62f7eb014e352e5d06856655206165d775e675a02c9/exceptiongroup-1.3.1.tar.gz"
    sha256 "8b412432c6055b0b7d14c310000ae93352ed6754f70fa8f7c34141f91c4e3219"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/cc/28/c14e053b6762b1044f34a13aab6859bbf40456d37d23aa286ac24cfd9a5d/executing-2.2.1.tar.gz"
    sha256 "3632cc370565f6648cc328b32435bd120a1e4ebb20c77e3fdde9a13cd1e533c4"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/6e/5b/ccb338db71f347e3bc031d268bf6dc41e5ead63b6997b8e72af92f05e18e/fastavro-1.12.2.tar.gz"
    sha256 "3c79502d56cf6b76210032e1c53494ddfbc73c140bccf2ef4092b3f0825323ab"
  end

  resource "fastmcp-slim" do
    url "https://files.pythonhosted.org/packages/45/79/f35661c6a1d76dfbe17a079f912d96fffcfdd40fad5a9144bb9e7dfb1fdf/fastmcp_slim-3.4.4.tar.gz"
    sha256 "dcaa3e0be2127d7eacdce592c2ef0039204923dc0ec396454615cb4a3275b078"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/99/2c/c603f8aedff281295f7afce455d5c05f33459c7bf684abb46228f844a1f0/filelock-3.31.2.tar.gz"
    sha256 "e6d35965c709527915a184837a8421826d18bc3f9d7e9a5a0c8114a782475d66"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/10/a1/ae4e3e5003468d6391d2c77b6fa1cd73bd5d13511d81c642d7b28ac90ed4/fsspec-2026.6.0.tar.gz"
    sha256 "f5bac145310fe30e16e1471bd6840b2d990d609e872251d7e674241822abf01a"
  end

  resource "genai-prices" do
    url "https://files.pythonhosted.org/packages/1d/e4/5072862613fba039da2b7c981a8649c6c6bbcb2863bd8bc81617c09ce5ee/genai_prices-0.0.71.tar.gz"
    sha256 "de4db34ec38404f9ef383cb1ab29e204d16ccf27071af0b16d5747ee7affe36b"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/79/b9/e370d86fea3da13ec0256df30323dd26c0cb9c8c85f0c6ec42ac9df0106b/google_auth-2.55.2.tar.gz"
    sha256 "97ae7790ff740f2bc9db60eb864a7804f4ac19f5f02c38b3d942f2fea6e9b9ae"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/96/59/9ea84cbeb8f09694564d3b0ee9dd59003551b308d47b61f251415df93982/google_genai-2.12.1.tar.gz"
    sha256 "78c25217885d63dc430ca7c4526853512b164a25a93a8a0d0af5b85971aa1db0"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/33/e4/8d187ea29c2e30b3a09505c567513077d6117861bde1fbd997a167f262ec/griffelib-2.1.0.tar.gz"
    sha256 "762a186d2c6fd6794d4ea20d428d597ffb857cb56b66421651cbba15bdd5e813"
  end

  resource "groq" do
    url "https://files.pythonhosted.org/packages/0b/3a/31c54e35d694ba9c263939ecae0874c78fc51f22b9fb13d2dab50edf6e3c/groq-1.5.0.tar.gz"
    sha256 "8648388f8668629490bb0eab11252b4cc43316149fda9c6343e9a9577fe7df88"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/53/92/ec9ad04d0b5728dca387a45af7bc98fbb0d73b2118759f5f6038b61a57e8/hf_xet-1.4.3.tar.gz"
    sha256 "8ddedb73c8c08928c793df2f3401ec26f95be7f7e516a7bee2fbb546f6676113"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/d5/fe/6a3f9f1a8bb8733326140737446aaf72fddb8b54b8f202302f5c84960613/httpcore2-2.7.0.tar.gz"
    sha256 "6dc0fedf329a52a990930a5579edfebaea81118ea700ea0dd7de2b5e5be49efc"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/a3/4a/129b2e21b90ac2985d3928d96792bccc39bc6dfe796c5eee2d8ec06d4105/httpx2-2.7.0.tar.gz"
    sha256 "8b30709aed5c8465b0dd3b95c09ce301c8f79e7e7a2d00ab0af551e0d0375b07"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/48/0f/ed994dbade67a54407c28cab96ef845e0e6d25500be56aca6394f8bfc9dd/huggingface_hub-1.16.1.tar.gz"
    sha256 "7f1dc4c5ec21aed69be630ad0c3378616be16f3de1a47b141c0e812965d9c832"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/f3/49/3b30cad09e7771a4982d9975a8cbf64f00d4a1ececb53297f1d9a7be1b10/importlib_metadata-8.7.1.tar.gz"
    sha256 "49fef1ae6440c182052f407c8d34a68f72efc36db9ca90dc0113398f2fdde8bb"
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

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1d/1f/10936e16d8860c70698a1aa939a46aa0224813b782bce4e000e637da0b2d/jiter-0.16.0.tar.gz"
    sha256 "7b24c3492c5f4f84a37946ad9cf504910cf6a782d6a4e0689b6673c5894b4a1c"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/c7/e0/27a6a081ae25420eda6768ceae05d7022a7f2447f420588843f2a44e4298/joserfc-1.7.4.tar.gz"
    sha256 "b3bc561672ae541b17a9237053b48a03dacddd92d68047b3ecdfb4b5714a88ed"
  end

  resource "jsonpath-python" do
    url "https://files.pythonhosted.org/packages/98/18/4ca8742534a5993ff383f7602e325ce2d5d7cc93d72ac5e1cdedbea8a458/jsonpath_python-1.1.6.tar.gz"
    sha256 "dded9932b4ec41fb8726e09c83afa4e6be618f938c2db287cc2a81723c639671"
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

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/2e/c9/06ea13676ef354f0af6169587ae292d3e2406e212876a413bf9eece4eb23/linkify_it_py-2.1.0.tar.gz"
    sha256 "43360231720999c10e9328dc3691160e27a718e280673d444c38d7d3aaa3b98b"
  end

  resource "logfire" do
    url "https://files.pythonhosted.org/packages/18/b7/2b9670e893b5c662c23252bc52cafa2664b7c582b8c36b280693b2beaaa0/logfire-4.38.0.tar.gz"
    sha256 "da62f7616f3411098cf5fb087f9ff24f54886a9087a238fe0e5fae8bbd609717"
  end

  resource "logfire-api" do
    url "https://files.pythonhosted.org/packages/10/1a/17af258260cf8378fabd10bacef0c585e19697eab1deea25f8e4f4fb6462/logfire_api-4.38.0.tar.gz"
    sha256 "e773cd4a26edb48ef4ec6f88661d1c670bb68c303a71c7043a236d64a9699cd2"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/6e/77/9450b8f251a13affb6281997d0523c4615f8a8b35d0b21ff30db3a5aac9d/mcp-1.28.1.tar.gz"
    sha256 "d51e36a5f5644faea4f85ea649bfffa6bc6c26770d42798ad6a3de3d2ba69683"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mistralai" do
    url "https://files.pythonhosted.org/packages/79/1e/d0d55cad621d46ae4937066fb4562ed8d1cf5612af74e8045b9a22ad5e39/mistralai-2.7.0.tar.gz"
    sha256 "defc51a40e94b365189e8acdf8f0e41463db814f39b2b4274a6ce84ade156708"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "ollama" do
    url "https://files.pythonhosted.org/packages/fc/72/5f12423b6b39ca8430fbe56f77fcf4ef60f63067c7c4a2e30e200ed9ec16/ollama-0.6.2.tar.gz"
    sha256 "936d55daa684f474364c098611c933626f8d6c7d67065c5b7ae0c477b508b07f"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/af/ac/f725c4efbda8657d02be684607e5a2e5ce362e4790fdbcbdfb7c15018647/openai-2.46.0.tar.gz"
    sha256 "0421e0735ac41451cad894af4cddf0435bfbf8cbc538ac0e15b3c062f2ddc06a"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/97/b9/3161be15bb8e3ad01be8be5a968a9237c3027c5be504362ff800fca3e442/opentelemetry_api-1.39.1.tar.gz"
    sha256 "fbde8c80e1b937a2c61f20347e91c0c18a1940cecf012d62e65a7caf08967c9c"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/e9/9d/22d241b66f7bbde88a3bfa6847a351d2c46b84de23e71222c6aae25c7050/opentelemetry_exporter_otlp_proto_common-1.39.1.tar.gz"
    sha256 "763370d4737a59741c89a67b50f9e39271639ee4afc999dadfe768541c027464"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/80/04/2a08fa9c0214ae38880df01e8bfae12b067ec0793446578575e5080d6545/opentelemetry_exporter_otlp_proto_http-1.39.1.tar.gz"
    sha256 "31bdab9745c709ce90a49a0624c2bd445d31a28ba34275951a6a362d16a0b9cb"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/41/0f/7e6b713ac117c1f5e4e3300748af699b9902a2e5e34c9cf443dde25a01fa/opentelemetry_instrumentation-0.60b1.tar.gz"
    sha256 "57ddc7974c6eb35865af0426d1a17132b88b2ed8586897fee187fd5b8944bd6a"
  end

  resource "opentelemetry-instrumentation-httpx" do
    url "https://files.pythonhosted.org/packages/86/08/11208bcfcab4fc2023252c3f322aa397fd9ad948355fea60f5fc98648603/opentelemetry_instrumentation_httpx-0.60b1.tar.gz"
    sha256 "a506ebaf28c60112cbe70ad4f0338f8603f148938cb7b6794ce1051cd2b270ae"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/49/1d/f25d76d8260c156c40c97c9ed4511ec0f9ce353f8108ca6e7561f82a06b2/opentelemetry_proto-1.39.1.tar.gz"
    sha256 "6c8e05144fc0d3ed4d22c2289c6b126e03bcd0e6a7da0f16cedd2e1c2772e2c8"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/eb/fb/c76080c9ba07e1e8235d24cdcc4d125ef7aa3edf23eb4e497c2e50889adc/opentelemetry_sdk-1.39.1.tar.gz"
    sha256 "cf4d4563caf7bff906c9f7967e2be22d0d6b349b908be0d90fb21c8e9c995cc6"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/91/df/553f93ed38bf22f4b999d9be9c185adb558982214f33eae539d3b5cd0858/opentelemetry_semantic_conventions-0.60b1.tar.gz"
    sha256 "87c228b5a0669b748c76d76df6c364c369c28f1c465e50f661e39737e84bc953"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/50/fc/c47bb04a1d8a941a4061307e1eddfa331ed4d0ab13d8a9781e6db256940a/opentelemetry_util_http-0.60b1.tar.gz"
    sha256 "0d97152ca8c8a41ced7172d29d3622a219317f74ae6bb3027cfbdcf22c3cc0d6"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/52/cd/4f25b2f95b23f5d2c9c1fe43e49841bff5800562149b2666afc09309aa8f/platformdirs-4.10.1.tar.gz"
    sha256 "ceab4084426fe6319ce18e86deada8ab1b7487c7aee7040c55e277c9ae793695"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/fb/e2/d689d922894a7ecde73b6daeaf9b13dab5aae06fe6aaaf7514722644d382/py_key_value_aio-0.4.5.tar.gz"
    sha256 "c6563a2c6abe5da5e20f4f9e875c2a9b425a2244a54fadbf46cf140a9eea45d7"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic-ai-slim" do
    url "https://files.pythonhosted.org/packages/ca/d1/78fd15c9c68b95ac0bec2d2afe22feb3b2f46e4b8e3a6dd1cead61cde434/pydantic_ai_slim-2.1.0.tar.gz"
    sha256 "f79dca2429dbb9d2e32a0e2c613cfb9b9d6f0dc81d42cff8a5c81ede8ca0a6c7"
  end

  resource "pydantic-graph" do
    url "https://files.pythonhosted.org/packages/39/20/018532c826aba3c29ffc37bda46c20f3db4584bb555a8c7dc2769866267d/pydantic_graph-2.1.0.tar.gz"
    sha256 "36ed6af24543421fb628fee593ccf5553a286c1dd1677018f5064a4e44c4daba"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/5c/b5/8f48e906c3e0205276e8bd8cb7512217a87b2685304d64be27cad5b3019f/pydantic_settings-2.14.2.tar.gz"
    sha256 "c19dd64b19097f1de80184f0cc7b0272a13ae6e170cbf240a3e27e381ed14a5f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/3b/81/58d0ac84e1ef3a3843791d6954d94c0b33d526c75eeb1efbce9d0a4c4077/pyjwt-2.13.0.tar.gz"
    sha256 "41571c89ca91598c79e8ef18a2d07367d4810fbbd6f637794879baf1b7703423"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
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

  resource "regex" do
    url "https://files.pythonhosted.org/packages/20/98/04b13f1ddfb63158025291c02e03eb42fbb7acb51d091d541050eb4e35e8/regex-2026.7.19.tar.gz"
    sha256 "7e77b324909c1617cbb4c668677e2c6ae13f44d7c1de0d4f15f2e3c10f3315b5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/65/da/4bef7ce7bb989b222aa4785a413896dbec53306dfc59c6ce7d16a7ffbd6a/s3transfer-0.19.1.tar.gz"
    sha256 "d3d6371dc3f1e5c5427b2b457bcf13bcf87bec334c95aed18642eae61f6926f3"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/6c/10/a34c656829ffc1c4b22ef36d70d9ebb6b99c020e2aeb17cee5485099f028/sse_starlette-3.4.6.tar.gz"
    sha256 "725f8a1bd6d26ae1b2c9610c0ef5065dfdd496f3988d28adcf8c4b49dc25c627"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/eb/e3/7c1dc7381d9f8ab7d854328ebfa884e62cb3f3d8549ddfd37c7814f42afa/starlette-1.3.1.tar.gz"
    sha256 "05d0213193f2fbaae60e2ecb593b4add4262ad4e46536b54abe36f11a71724e0"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "terminaltexteffects" do
    url "https://files.pythonhosted.org/packages/3c/df/4fa04990d75cc27215159bf9edec7d56546fd72e1927c5753d0de0414e7b/terminaltexteffects-0.15.0.tar.gz"
    sha256 "f4b31c86bfa943d5bf3b2c5ecbfaea0de65ed4a951028c40f8e4cb54efd06439"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-image" do
    url "https://files.pythonhosted.org/packages/c2/e7/c82ea0604874b6d51d5717a0911061ae5810e36dad2e4d2b11fa7d54cdaa/textual_image-0.12.0.tar.gz"
    sha256 "fdd0b5ff9c8a99740bc360a99ce014d563fa97d07a5b49b472470809f57c0a74"
  end

  resource "textual-speedups" do
    url "https://files.pythonhosted.org/packages/d4/73/bba3e9feae9ca730c32122306ddac61278a8bc47633346eddad9d52a435d/textual_speedups-0.2.1.tar.gz"
    sha256 "72cf0f7bdeede015367b59b70bcf724ba2c3080a8641ebc5eb94b36ad1536824"
  end

  resource "textualeffects" do
    url "https://files.pythonhosted.org/packages/cc/40/5d28a460c8b3fb071df67dd0fbf1125b0373d0ef5a9105e6a146bacc530d/textualeffects-0.2.0.tar.gz"
    sha256 "e42f3865dbdc815831ae8159c9c39d1dd0789b2dea2bc6f8c15c43e2477e5df1"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/e4/e5/5f3cb2159769d0f4324c0e9e87f9de3c4b1cd45848a96b2eb3566ad5ca77/tiktoken-0.13.0.tar.gz"
    sha256 "c9435714c3a84c2319499de9a300c0e604449dd0799ff246458b3bb6a7f433c1"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/c1/60/21f715d9faba5f5407ff759472ade058ec4a507ad62bcea47cb847239a73/tokenizers-0.23.1.tar.gz"
    sha256 "1feeeadf865a7915adc25445dea30e9933e593c31bb96c277cee36de227c8bfa"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/8c/69/40407dfc835517f058b603dbf37a6df094d8582b015a51eddc988febbcb7/tqdm-4.69.0.tar.gz"
    sha256 "700c5e85dcd5f009dd6222588a29180a193a748247a5d855b4d67db93d79a53b"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/7c/f7/68adc395201b20b872d68e975386832e8005ffeacedd43a1d837a32815be/typer-0.26.8.tar.gz"
    sha256 "c244a6bd558886fe3f8780efb6bdd28bb9aff005a94eedebaa5cb32926fe2f7e"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/db/51/703318f7b7be8bee126ec13bf615050f932d0179b8784420f3a0199cc769/types_requests-2.33.0.20260712.tar.gz"
    sha256 "2141b67ab534a5c5cd2dac5034f2a35f42e699c5bf185eee608c5246a069d7fb"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/a2/65/b7c6c443ccc58678c91e1e973bbe2a878591538655d6e1d47f24ba1c51f3/uvicorn-0.51.0.tar.gz"
    sha256 "f6f4b69b657c312f516dd2d268ab9ae6f254b11e4bac504f37b2ab58b24dd0b0"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/95/8f/aeb76c5b46e273670962298c23e7ddde79916cb74db802131d49a85e4b7d/wrapt-1.17.3.tar.gz"
    sha256 "f66eb08feaa410fe4eebd17f2a2c8e2e46d3476e9f8c783daa8e09e0faa666d0"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/b9/d8/eab98a517c14134c0b2eb4e2387bc5f457334293ec5d2dd3857ec2966802/zipp-4.1.0.tar.gz"
    sha256 "4cb57381f544315db7688e976e922a2b18cdb513d21cc194eb42232ba2a3e602"
  end

  def install
    # `tokenizers` and `hf-xet` build PyO3 extensions through maturin.
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup"

    without = ["hf-xet"]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    resource("hf-xet").stage do
      # Use native-tls instead since building bundled aws-lc is tricky to do indirectly within superenv.
      # Can consider switching if system copy is supported https://github.com/aws/aws-lc-rs/issues/936
      inreplace "xet_client/Cargo.toml", 'default = ["rustls-tls"]', 'default = ["native-tls"]'

      # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
      if ENV.effective_arch == :armv8
        inreplace "xet_data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"oterm", shell_parameter_format: :typer)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oterm --version")
    assert_match "EnvConfig", shell_output("#{bin}/oterm --config")
  end
end
