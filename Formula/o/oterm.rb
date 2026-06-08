class Oterm < Formula
  include Language::Python::Virtualenv

  desc "Terminal client for Ollama"
  homepage "https://github.com/ggozad/oterm"
  url "https://files.pythonhosted.org/packages/c3/1b/f62cbe2f45c64b9bca7156032a146900c44461defbe90c7adf587d45fca0/oterm-0.18.0.tar.gz"
  sha256 "3cf7a2517be4190131262d4ba43313b9664c87dc685b1834c8c001cd3bacdd61"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "31c98592f92f050c00b41fdba4d9d47c9a2dba6adeca69745bd3df73e9be9ac7"
    sha256 cellar: :any,                 arm64_sequoia: "d42f41fb18e5f140431057b61681b6e16306cfa8a67420da263bd34dd3c8581e"
    sha256 cellar: :any,                 arm64_sonoma:  "294e31e442cabae5975862bbb79b9b5fcde9075f3226e6f7f5d6226e36ef5ed8"
    sha256 cellar: :any,                 sonoma:        "3649a7dd5b1c206bd77c0b019ddcb4a34f256c2b01ae224b29355caff3398b0c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0367620f8b05bacb5a72779810b379fb2ae84d4f1e671c5fe65f6c68fdb4d97f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b68df69e83f2d861cbf313f698877b9ff12b83d9ac247c838dfefaac12d9af97"
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
    url "https://files.pythonhosted.org/packages/0f/01/8bfa68b886aa436775325a108700f7da39e290870199ce9251934de3e4aa/anthropic-0.104.0.tar.gz"
    sha256 "1ae8ef4709e90cc2068c8e8a63c1ecb63cc5360d325a4bef8b296aad76148be3"
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

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/21/f3/40abb5e3df93f31b3e7c6ca334e82dff584f9afeeed73d7ad9b2640b926a/boto3-1.43.13.tar.gz"
    sha256 "bd909b509c459e784dcfcafb3e130cf2891ab26d2d323003bcddaf15a948c9e8"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/c3/34/58790c6d2e8e074e7a6286ec9d41c26237edd453c573aaf613eb621d8ae9/botocore-1.43.13.tar.gz"
    sha256 "10df003c71847b4f1501b98b1c03e1cb6399583b6cc5136ca7ff849e00c4797f"
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
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "cohere" do
    url "https://files.pythonhosted.org/packages/d2/75/4c346f6e2322e545f8452692304bd4eca15a2a0209ab9af6a0d1a7810b67/cohere-5.21.1.tar.gz"
    sha256 "e5ade4423b928b01ff2038980e1b62b2a5bb412c8ab83e30882753b810a5509f"
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
    url "https://files.pythonhosted.org/packages/fb/a3/cafafb4558fd638aadfe4121dc6cefb8d743368c085acb2f521df0f3d9d7/eval_type_backport-0.3.1.tar.gz"
    sha256 "57e993f7b5b69d271e37482e62f74e76a0276c82490cf8e4f0dffeb6b332d5ed"
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
    url "https://files.pythonhosted.org/packages/d1/a0/627103e517e1d0d6f1eec633d5662d13e776f01b45ad188e4f5f7478b438/fastmcp_slim-3.3.1.tar.gz"
    sha256 "0957835fc59452e143ab2f4b7836d2d2df9b2d9958408edc79ba8b56232b2a88"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/b5/fe/997687a931ab51049acce6fa1f23e8f01216374ea81374ddee763c493db5/filelock-3.29.0.tar.gz"
    sha256 "69974355e960702e789734cb4871f884ea6fe50bd8404051a3530bc07809cf90"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/d5/8d/1c51c094345df128ca4a990d633fe1a0ff28726c9e6b3c41ba65087bba1d/fsspec-2026.4.0.tar.gz"
    sha256 "301d8ac70ae90ef3ad05dcf94d6c3754a097f9b5fe4667d2787aa359ec7df7e4"
  end

  resource "genai-prices" do
    url "https://files.pythonhosted.org/packages/65/71/0c76010eec75f4b3623d521044785c0977c14adabe1cac72b004349567fb/genai_prices-0.0.61.tar.gz"
    sha256 "4b3bcfd49f174c05831b09f9ee36557d3648569e2f594af6c24b72031b3f0e52"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/c6/ad/ff781329bbbdc0974a098d996e89c9e1f7024262f9e3eec442fbb9ad1ac6/google_auth-2.53.0.tar.gz"
    sha256 "e7e6aa16f6bee7b2b264830fd04f08087a1d5a836df516251a5d15327b246c9c"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/dd/ec/6e49f50f5c70588d97c6ed25e0b8c18828bf4d58895f397b53a7522168a1/google_genai-2.6.0.tar.gz"
    sha256 "7d4f777234002f2e94be499dbdfb43b506a6aca9dbbec13e61d3dc6ce640ffa7"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/b5/c8/f439cffde755cffa462bfbb156278fa6f9d09119719af9814b858fd4f81f/googleapis_common_protos-1.75.0.tar.gz"
    sha256 "53a062ff3c32552fbd62c11fe23768b78e4ddf0494d5e5fd97d3f4689c75fbbd"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/9d/82/74f4a3310cdabfbb10da554c3a672847f1ed33c6f61dd472681ce7f1fe67/griffelib-2.0.2.tar.gz"
    sha256 "3cf20b3bc470e83763ffbf236e0076b1211bac1bc67de13daf494640f2de707e"
  end

  resource "groq" do
    url "https://files.pythonhosted.org/packages/27/51/4728c13611849ff6cf8536740ae78ba3ee5e665d67b572a47c9ead0f9788/groq-1.2.0.tar.gz"
    sha256 "85459e27c9c17f22404349c785cd08680362cfe85e07cc060be46c4832f108c3"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/74/d8/5c06fc76461418326a7decf8367480c35be11a41fd938633929c60a9ec6b/hf_xet-1.5.0.tar.gz"
    sha256 "e0fb0a34d9f406eed88233e829a67ec016bec5af19e480eac65a233ea289a948"
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

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/48/0f/ed994dbade67a54407c28cab96ef845e0e6d25500be56aca6394f8bfc9dd/huggingface_hub-1.16.1.tar.gz"
    sha256 "7f1dc4c5ec21aed69be630ad0c3378616be16f3de1a47b141c0e812965d9c832"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/1a/88/bcf9709822fe69d02c2a6a77956c98ce6ea8ca8767a9aadcedc7eb6a2390/idna-3.16.tar.gz"
    sha256 "d7a6da03db833450fca25d2358ac9ff06cd624577a4aea3a596d5c0f77b8e03d"
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
    url "https://files.pythonhosted.org/packages/36/cf/ea4ef2920830dea3f5ab2ea4da6fb67724e6dca80ee2553788c3607243d0/jaraco_functools-4.5.0.tar.gz"
    sha256 "3bb5665ea4a020cf78a7040e89154c77edadb3ca74f366479669c5999aa70b03"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/66/b5/55f06bb281d92fb3cc86d14e1def2bd908bb77693183e7cb1f5a3c388b0c/jiter-0.15.0.tar.gz"
    sha256 "4251acc80e2b7c9b7b8823456ea0fceeb0734dac2df7636d3c711b38476b5a76"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/3b/dc/5f768c2e391e9afabe5d18e3221346deb5fb6338565f1ccc9e7c6d7befdd/joserfc-1.6.5.tar.gz"
    sha256 "1482a7db78fb4602e44ed89e51b599d052e091288c7c532c5b694e20149dec48"
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
    url "https://files.pythonhosted.org/packages/10/66/716dfae86d49f5861998151d9d10a023c225c9cf553d37bf4a7eb8444475/logfire-4.33.0.tar.gz"
    sha256 "1f0ac129b4f76fd4a61763bff5e9fcd75aff99348b89071faa2f54e1213f856a"
  end

  resource "logfire-api" do
    url "https://files.pythonhosted.org/packages/47/1a/c44eb3a02407aa739669822d19734e76e8751284b86cd99c73baca36998a/logfire_api-4.33.0.tar.gz"
    sha256 "0a604f710e803db08a2ddc41e6152bf8d8a56b549f8856cbf82baa36bc7de2c9"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/38/83/d1efe7c2980d8a3afa476f4e3d42d53dd54c0ab94c27bee5d755b45c8b73/mcp-1.27.1.tar.gz"
    sha256 "0f47e1820f8f8f941466b39749eb1d1839a04caddca2bc60e9d46e8a99914924"
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
    url "https://files.pythonhosted.org/packages/8e/3f/5624d57c5897c83c55d3e4c7dd4127de42ad14fd3183e26566cdc7dca1bf/mistralai-2.4.5.tar.gz"
    sha256 "ef165bb004ec4423cbf19a440bf0983ca0c3fc92ab12a35ebca097bdf418e33a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "ollama" do
    url "https://files.pythonhosted.org/packages/fc/72/5f12423b6b39ca8430fbe56f77fcf4ef60f63067c7c4a2e30e200ed9ec16/ollama-0.6.2.tar.gz"
    sha256 "936d55daa684f474364c098611c933626f8d6c7d67065c5b7ae0c477b508b07f"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/8f/12/cfa322c5f5dd8fa21aab9a7a8e979e7a11123800f86ca8d82eb68a83d213/openai-2.38.0.tar.gz"
    sha256 "798694c6cf74145541fda94325b6f8f72d8e1fd0262cc137c8d728177a6a4ce3"
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
    url "https://files.pythonhosted.org/packages/9f/4a/0883b8e3802965322523f0b200ecf33d31f10991d0401162f4b23c698b42/platformdirs-4.9.6.tar.gz"
    sha256 "3bfa75b0ad0db84096ae777218481852c0ebc6c727b3168c1b9e0118e458cf0a"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/66/70/e908e9c5e52ef7c3a6c7902c9dfbb34c7e29c25d2f81ade3856445fd5c94/protobuf-6.33.6.tar.gz"
    sha256 "a6768d25248312c297558af96a9f9c929e8c4cee0659cb07e780731095f38135"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/04/3c/0397c072a38d4bc580994b42e0c90c5f44f679303489e4376289534735e5/py_key_value_aio-0.4.4.tar.gz"
    sha256 "e3012e6243ed7cc09bb05457bd4d03b1ba5c2b1ca8700096b3927db79ffbbe55"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/5c/5f/6583902b6f79b399c9c40674ac384fd9cd77805f9e6205075f828ef11fb2/pyasn1-0.6.3.tar.gz"
    sha256 "697a8ecd6d98891189184ca1fa05d1bb00e2f84b5977c481452050549c8a72cf"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic-ai-slim" do
    url "https://files.pythonhosted.org/packages/68/db/3eb296369e3001f82d7552060c3811307809954b7c7ec30499f383d3c87a/pydantic_ai_slim-1.100.0.tar.gz"
    sha256 "cc755c7970b2e041764b9d2f74d50cbad3cf7989b14cdbf62d356f25eb2a1222"
  end

  resource "pydantic-graph" do
    url "https://files.pythonhosted.org/packages/90/8b/eee672fa01eec3ea34e7d8962d54aa16d658ad0723466122a7ba2828caa1/pydantic_graph-1.100.0.tar.gz"
    sha256 "7651fa6ccce9d88a35b1d2cfe79d5d1dbb2415457503009195014bf31f6075bd"
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

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/82/ed/0301aeeac3e5353ef3d94b6ec08bbcabd04a72018415dcb29e588514bba8/python_dotenv-1.2.2.tar.gz"
    sha256 "2c371a91fbd7ba082c2c1dc1f8bf89ca22564a087c2c287cd9b662adde799cf3"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/4e/fe/70bd71a6738b09a0bdf6480ca6436b167469ca4578b2a0efbe390b4b0e70/python_multipart-0.0.29.tar.gz"
    sha256 "643e93849196645e2dbdd81a0f8829a23123ad7f797a84a364c6fb3563f18904"
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
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
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
    url "https://files.pythonhosted.org/packages/9b/ec/7c692cde9125b77e84b307354d4fb705f98b8ccad59a036d5957ca75bfc3/s3transfer-0.17.0.tar.gz"
    sha256 "9edeb6d1c3c2f89d6050348548834ad8289610d886e5bf7b7207728bd43ce33a"
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
    url "https://files.pythonhosted.org/packages/f7/2b/58abc2d1fd397e7dde08e947e05c884d8ef2f78d5e2588c17a12d42d6994/sse_starlette-3.4.4.tar.gz"
    sha256 "07e0fa0460138baf25cdd5fb28683472c3995dc1642225191b3832d62526bcb0"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/08/a3/84e821cc54b4ab50ae6dbc6ac3800a651b65ec35f045cc73785380654057/starlette-1.0.1.tar.gz"
    sha256 "512399c5f1de7fac99c88572212ded9ddeddef2fb32afa82d724000e88b38f4f"
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
    url "https://files.pythonhosted.org/packages/19/89/bec5709fb759f9c784bbcb30b2e3497df3f901691d13c2b864dbf6694a17/textual-8.2.4.tar.gz"
    sha256 "d4e2b2ddd7157191d00b228592b7c739ea080b7d792fd410f23ca75f05ea76c4"
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
    url "https://files.pythonhosted.org/packages/09/a9/6ba95a270c6f1fbcd8dac228323f2777d886cb206987444e4bce66338dd4/tqdm-4.67.3.tar.gz"
    sha256 "7d825f03f89244ef73f1d4ce193cb1774a8179fd96f31d7e1dcde62092b960bb"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/83/b8/9ebb531b6c2d377af08ac6746a5df3425b21853a5d2260876919b58a2a4a/typer-0.24.2.tar.gz"
    sha256 "ec070dcfca1408e85ee203c6365001e818c3b7fffe686fd07ff2d68095ca0480"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/e0/01/c5a19253fe1ac159159ddf9a3a07cec8bb5e486ec4d9002ad2821da0e5d2/types_requests-2.33.0.20260518.tar.gz"
    sha256 "df7bd3bfe0ca8402dfb841e7d9be714bb5578203283d66d7dc4ef69343449a5e"
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
    url "https://files.pythonhosted.org/packages/f6/b1/8e7077a8641086aea449e1b5752a570f1b5906c64e0a33cd6d93b63a066b/uvicorn-0.47.0.tar.gz"
    sha256 "7c9a0ea1a9414106bbab7324609c162d8fa0cdcdcb703060987269d77c7bb533"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/04/24/4b2031d72e840ce4c1ccb255f693b15c334757fc50023e4db9537080b8c4/websockets-16.0.tar.gz"
    sha256 "5f6261a5e56e8d5c42a4497b364ea24d94d9563e8fbd44e78ac40879c60179b5"
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
