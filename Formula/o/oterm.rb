class Oterm < Formula
  include Language::Python::Virtualenv

  desc "Terminal client for Ollama"
  homepage "https://github.com/ggozad/oterm"
  url "https://files.pythonhosted.org/packages/1b/ef/b035a91bd646adaaa8ba06125e7ad9a96ae4ec6122c18767a1c36e2ba3b9/oterm-0.17.0.tar.gz"
  sha256 "c5c387a6f47b84705c07a1e79c552c6a0a5eb48ac3d9a0234c18006a27ceed86"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "596a229b043fdd0e12c20894b895a2fed09ed27a43e1223a4a10c172d04cba37"
    sha256 cellar: :any,                 arm64_sequoia: "9ff7d83ebb08d4415ea849b33c250695e231b61260e78b435a96bf8b1c1dacde"
    sha256 cellar: :any,                 arm64_sonoma:  "16e2909e3483a397966bb3ee10b83693d9a3106bec019bc0957391885b4bca29"
    sha256 cellar: :any,                 sonoma:        "c598d27b5b4a220102ee43744a4a1a1de8ef930783ab947d02c7504fda59e4c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bc37d240a675b3994c94ab40c1dea19dbc85f982a8d333b47ab02e8aac72f202"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5004c1d2ad8fdc0fe3e97b45c994289fa00ae3fbbc7202d4fbf5732d659cb16"
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
    url "https://files.pythonhosted.org/packages/67/e2/d7cb819de8df6b5c1968a2756c3cb4122d4fa2b8fc768b53b7c9e5edb646/aiofile-3.9.0.tar.gz"
    sha256 "e5ad718bb148b265b6df1b3752c4d1d83024b93da9bd599df74b9d9ffcf7919b"
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
    url "https://files.pythonhosted.org/packages/14/93/f66ea8bfe39f2e6bb9da8e27fa5457ad2520e8f7612dfc547b17fad55c4d/anthropic-0.97.0.tar.gz"
    sha256 "021e79fd8e21e90ad94dc5ba2bbbd8b1599f424f5b1fab6c06204009cab764be"
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
    url "https://files.pythonhosted.org/packages/d9/82/4d0603f30c1b4629b1f091bb266b0d7986434891d6940a8c87f8098db24e/authlib-1.7.0.tar.gz"
    sha256 "b3e326c9aa9cc3ea95fe7d89fd880722d3608da4d00e8a27e061e64b48d801d5"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/c7/94/1009e248bbfbab11397abca7193bea6626806be9a327d399810d523a07cb/beartype-0.22.9.tar.gz"
    sha256 "8f82b54aa723a2848a56008d18875f91c1db02c32ef6a62319a002e3e25a975f"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/95/cd/bba36079f5d4bd63db7385e6b9dc1845db32407c3f18f56aaddafb75097f/boto3-1.43.2.tar.gz"
    sha256 "be951cc22769fbcda73fac523b031ee38db45c3ae2b0d828c76b8f6e8e683073"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/2c/b0/65d4c85f16367fb6147d391652d0c386f24b029536f7026e7b98740166cd/botocore-1.43.2.tar.gz"
    sha256 "7b2ec87b6d0720bff920451ce930e71c2a99cdea48d0eaa66ccf0b21ea747e03"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/d0/1d/7cbe8f84352789be3dcbb1239f425984f353efa253deeeff38af600870b3/cachetools-7.1.0.tar.gz"
    sha256 "ea5406e92956f9006b121f8032177c6b02cc5f9a488d1e53b2e4d9cb5aae15c6"
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
    url "https://files.pythonhosted.org/packages/bb/63/f9e1ea081ce35720d8b92acde70daaedace594dc93b693c869e0d5910718/click-8.3.3.tar.gz"
    sha256 "398329ad4837b2ff7cbe1dd166a4c0f8900c3ca3a218de04466f38f6497f18a2"
  end

  resource "cohere" do
    url "https://files.pythonhosted.org/packages/d2/75/4c346f6e2322e545f8452692304bd4eca15a2a0209ab9af6a0d1a7810b67/cohere-5.21.1.tar.gz"
    sha256 "e5ade4423b928b01ff2038980e1b62b2a5bb412c8ab83e30882753b810a5509f"
  end

  resource "cyclopts" do
    url "https://files.pythonhosted.org/packages/d4/57/1a6d246b391ef2904b3c1b17a1930a8512e4d02f3a11d1a21c9ed9b5f2ca/cyclopts-4.11.1.tar.gz"
    sha256 "6c1d4b55a1d05bd9e1fdc4d7800e9ce69cf16f6141db34e5a5c9857bdb81887f"
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

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/ae/b6/03bb70946330e88ffec97aefd3ea75ba575cb2e762061e0e62a213befee8/docutils-0.22.4.tar.gz"
    sha256 "4db53b1fde9abecbb74d91230d32ab626d94f6badfc575d6db9194a49df29968"
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

  resource "fastmcp" do
    url "https://files.pythonhosted.org/packages/9c/13/29544fbc6dfe45ea38046af0067311e0bad7acc7d1f2ad38bb08f2409fe2/fastmcp-3.2.4.tar.gz"
    sha256 "083ecb75b44a4169e7fc0f632f94b781bdb0ff877c6b35b9877cbb566fd4d4d1"
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
    url "https://files.pythonhosted.org/packages/be/30/11f3d683cf3b1d9612475ad8bfffe3423ce9f50fc617733109033e73a038/genai_prices-0.0.57.tar.gz"
    sha256 "6e101e9c53975557ceffa237b0995787d81fe75aac12410f2898504188bcad89"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/5f/18/238d7021d151bdab868f23433817b027dd759135202f4dfce0670d1230ca/google_auth-2.50.0.tar.gz"
    sha256 "f35eafb191195328e8ce10a7883970877e7aeb49c2bfaa54aa0e394316d353d0"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/33/c8/4a8f1de0a3268d526a345b8c74456b3e1e6ffd200982626326cf7ca83e5b/google_genai-1.74.0.tar.gz"
    sha256 "c4c473cebdeb6e5adbb0639326de66a3a85a2209e0d32de7d66bf05c698abae8"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/20/18/a746c8344152d368a5aac738d4c857012f2c5d1fd2eac7e17b647a7861bd/googleapis_common_protos-1.74.0.tar.gz"
    sha256 "57971e4eeeba6aad1163c1f0fc88543f965bb49129b8bb55b2b7b26ecab084f1"
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
    url "https://files.pythonhosted.org/packages/53/92/ec9ad04d0b5728dca387a45af7bc98fbb0d73b2118759f5f6038b61a57e8/hf_xet-1.4.3.tar.gz"
    sha256 "8ddedb73c8c08928c793df2f3401ec26f95be7f7e516a7bee2fbb546f6676113"
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
    url "https://files.pythonhosted.org/packages/89/ff/ec7ed2eb43bd7ce8bb2233d109cc235c3e807ffe5e469dc09db261fac05e/huggingface_hub-1.13.0.tar.gz"
    sha256 "f6df2dac5abe82ce2fe05873d10d5ff47bc677d616a2f521f4ee26db9415d9d0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
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
    url "https://files.pythonhosted.org/packages/0f/27/056e0638a86749374d6f57d0b0db39f29509cce9313cf91bdc0ac4d91084/jaraco_functools-4.4.0.tar.gz"
    sha256 "da21933b0417b89515562656547a77b4931f98176eb173644c0d35032a33d6bb"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/6e/c1/0cddc6eb17d4c53a99840953f95dd3accdc5cfc7a337b0e9b26476276be9/jiter-0.14.0.tar.gz"
    sha256 "e8a39e66dac7153cf3f964a12aad515afa8d74938ec5cc0018adcdae5367c79e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/de/c6/de8fdbdfa75c8ca04fead38a82d573df8a82906e984c349d58665f459558/joserfc-1.6.4.tar.gz"
    sha256 "34ce5f499bfcc5e9ad4cc75077f9278ab3227b71da9aaf28f9ab705f8a560d3c"
  end

  resource "jsonpath-python" do
    url "https://files.pythonhosted.org/packages/2d/db/2f4ecc24da35c6142b39c353d5b7c16eef955cc94b35a48d3fa47996d7c3/jsonpath_python-1.1.5.tar.gz"
    sha256 "ceea2efd9e56add09330a2c9631ea3d55297b9619348c1055e5bfb9cb0b8c538"
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
    url "https://files.pythonhosted.org/packages/01/86/cfee6dd25843bec0760f456599a4f7e7e40221a934b9229fda0662c859bc/jsonschema_path-0.4.6.tar.gz"
    sha256 "c89eb635f4d497c9ac328eeff359c489755838806a7d033510a692e9576f5c4b"
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
    url "https://files.pythonhosted.org/packages/b5/d7/70c6def7f3f459b2d57aa7fb37863d31b8d877e391547f200ee8c31d2e30/logfire-4.32.1.tar.gz"
    sha256 "8e7ff418b5f2629c8a8e9426283ff82c760a30f24516c4c389d6cbb1d9768c58"
  end

  resource "logfire-api" do
    url "https://files.pythonhosted.org/packages/58/1b/0c74ad85f977743ba4c589e46e0cb138d6a6e69487830f4e86ebbdb145a3/logfire_api-4.32.1.tar.gz"
    sha256 "5e8714b2bb5fb5d1f4a4a833941e4ca711b75d2c1f98e76c5ad680fe6991af6a"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/8b/eb/c0cfc62075dc6e1ec1c64d352ae09ac051d9334311ed226f1f425312848a/mcp-1.27.0.tar.gz"
    sha256 "d3dc35a7eec0d458c1da4976a48f982097ddaab87e278c5511d5a4a56e852b83"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/b2/fd/a756d36c0bfba5f6e39a1cdbdbfdd448dc02692467d83816dff4592a1ebc/mdit_py_plugins-0.5.0.tar.gz"
    sha256 "f4918cb50119f50446560513a8e311d574ff6aaed72606ddae6d35716fe809c6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mistralai" do
    url "https://files.pythonhosted.org/packages/f0/f0/80dfabf224be4419c6c112f3950676f5af3dcde582d225c03ca0196a4b32/mistralai-2.4.4.tar.gz"
    sha256 "cd8a27a230e5458b62237a6c4f7b52f5be86909fbc18694360ceb21dac932eda"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/a2/f7/139d22fef48ac78127d18e01d80cf1be40236ae489769d17f35c3d425293/more_itertools-11.0.2.tar.gz"
    sha256 "392a9e1e362cbc106a2457d37cabf9b36e5e12efd4ebff1654630e76597df804"
  end

  resource "ollama" do
    url "https://files.pythonhosted.org/packages/9d/5a/652dac4b7affc2b37b95386f8ae78f22808af09d720689e3d7a86b6ed98e/ollama-0.6.1.tar.gz"
    sha256 "478c67546836430034b415ed64fa890fd3d1ff91781a9d548b3325274e69d7c6"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/f0/ee/d056c82f63c05f06baac0cffb4a90952d8274f90c49dfe244f20497b9bbd/openai-2.33.0.tar.gz"
    sha256 "f850c435e2a4685bba3295bd54912dd26315d9c1b7733068186134d6e0599f9a"
  end

  resource "openapi-pydantic" do
    url "https://files.pythonhosted.org/packages/02/2e/58d83848dd1a79cb92ed8e63f6ba901ca282c5f09d04af9423ec26c56fd7/openapi_pydantic-0.5.1.tar.gz"
    sha256 "ff6835af6bde7a459fb93eb93bb92b8749b754fc6e51b2f1590a19dc3005ee0d"
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

  resource "pathable" do
    url "https://files.pythonhosted.org/packages/72/55/b748445cb4ea6b125626f15379be7c96d1035d4fa3e8fee362fa92298abf/pathable-0.5.0.tar.gz"
    sha256 "d81938348a1cacb525e7c75166270644782c0fb9c8cecc16be033e71427e0ef1"
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
    url "https://files.pythonhosted.org/packages/bb/f9/76c7943f208b09b320dc65a000689929df6a5d3b143d56b48deade6db486/pydantic_ai_slim-1.87.0.tar.gz"
    sha256 "25822985ca21d6f2995310da915080fc3f75763aec82e815a3388257b06d6b84"
  end

  resource "pydantic-graph" do
    url "https://files.pythonhosted.org/packages/98/fa/b2306c6dbb06e4dfe6ce6b7c5a28b82bee536d965e1dd1800b49c386b389/pydantic_graph-1.87.0.tar.gz"
    sha256 "0f44848f8e83908ce372491c32ef349dfaf05e29f39fade0bae9309ab4f015cd"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/42/98/c8345dccdc31de4228c039a98f6467a941e39558da41c1744fbe29fa5666/pydantic_settings-2.14.0.tar.gz"
    sha256 "24285fd4b0e0c06507dd9fdfd331ee23794305352aaec8fc4eb92d4047aeb67d"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/c2/27/a3b6e5bf6ff856d2509292e95c8f57f0df7017cf5394921fc4e4ef40308a/pyjwt-2.12.1.tar.gz"
    sha256 "c74a7a2adf861c04d002db713dd85f84beb242228e671280bf709d765b03672b"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
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
    url "https://files.pythonhosted.org/packages/69/9b/f23807317a113dc36e74e75eb265a02dd1a4d9082abc3c1064acd22997c4/python_multipart-0.0.27.tar.gz"
    sha256 "9870a6a8c5a20a5bf4f07c017bd1489006ff8836cff097b6933355ee2b49b602"
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
    url "https://files.pythonhosted.org/packages/cb/0e/3a246dbf05666918bd3664d9d787f84a9108f6f43cc953a077e4a7dfdb7e/regex-2026.4.4.tar.gz"
    sha256 "e08270659717f6973523ce3afbafa53515c4dc5dcad637dc215b6fd50f689423"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-rst" do
    url "https://files.pythonhosted.org/packages/bc/6d/a506aaa4a9eaa945ed8ab2b7347859f53593864289853c5d6d62b77246e0/rich_rst-1.3.2.tar.gz"
    sha256 "a1196fdddf1e364b02ec68a05e8ff8f6914fee10fbca2e6b6735f166bb0da8d4"
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
    url "https://files.pythonhosted.org/packages/e1/9a/f35932a8c0eb6b2287b66fa65a0321df8c84e4e355a659c1841a37c39fdb/sse_starlette-3.4.1.tar.gz"
    sha256 "f780bebcf6c8997fe514e3bd8e8c648d8284976b391c8bed0bcb1f611632b555"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/81/69/17425771797c36cded50b7fe44e850315d039f28b15901ab44839e70b593/starlette-1.0.0.tar.gz"
    sha256 "6a4beaf1f81bb472fd19ea9b918b50dc3a77a6f2e190a12954b25e6ed5eea149"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "terminaltexteffects" do
    url "https://files.pythonhosted.org/packages/16/d2/9293a967c80172bc56b342e51cf5354bfdf0bf2b4b9df0b25f91c9c7c439/terminaltexteffects-0.14.2.tar.gz"
    sha256 "213c899ce4b8f7643d2d0568af144e1274e11e4493db9f5b04387bd17c217714"
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
    url "https://files.pythonhosted.org/packages/7d/ab/4d017d0f76ec3171d469d80fc03dfbb4e48a4bcaddaa831b31d526f05edc/tiktoken-0.12.0.tar.gz"
    sha256 "b18ba7ee2b093863978fcb14f74b3707cdc8d4d4d3836853ce7ec60772139931"
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
    url "https://files.pythonhosted.org/packages/a1/b8/57e94268c0d82ac3eaa2fc35aa8ca7bbc2542f726b67dcf90b0b00a3b14d/types_requests-2.33.0.20260503.tar.gz"
    sha256 "9721b2d9dbee7131f2fb39f20f0ebb1999c18cef4b512c9a7932f3722de7c5f4"
  end

  resource "uc-micro-py" do
    url "https://files.pythonhosted.org/packages/78/67/9a363818028526e2d4579334460df777115bdec1bb77c08f9db88f6389f2/uc_micro_py-2.0.0.tar.gz"
    sha256 "c53691e495c8db60e16ffc4861a35469b0ba0821fe409a8a7a0a71864d33a811"
  end

  resource "uncalled-for" do
    url "https://files.pythonhosted.org/packages/e1/68/35c1d87e608940badbcfeb630347aa0509897284684f61fab6423d02b253/uncalled_for-0.3.1.tar.gz"
    sha256 "5e412ac6708f04b56bef5867b5dcf6690ebce4eb7316058d9c50787492bb4bca"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/1f/93/041fca8274050e40e6791f267d82e0e2e27dd165627bd640d3e0e378d877/uvicorn-0.46.0.tar.gz"
    sha256 "fb9da0926999cc6cb22dc7cd71a94a632f078e6ae47ff683c5c420750fb7413d"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/c2/c9/8869df9b2a2d6c59d79220a4db37679e74f807c559ffe5265e08b227a210/watchfiles-1.1.1.tar.gz"
    sha256 "a173cb5c16c4f40ab19cecf48a534c409f7ea983ab8fed0741304a1c0a31b3f2"
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
    url "https://files.pythonhosted.org/packages/30/21/093488dfc7cc8964ded15ab726fad40f25fd3d788fd741cc1c5a17d78ee8/zipp-3.23.1.tar.gz"
    sha256 "32120e378d32cd9714ad503c1d024619063ec28aad2248dc6672ad13edfa5110"
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
