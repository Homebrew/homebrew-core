class Oterm < Formula
  include Language::Python::Virtualenv

  desc "Terminal client for Ollama"
  homepage "https://github.com/ggozad/oterm"
  url "https://files.pythonhosted.org/packages/0f/67/ddde964be663cb5f9c0bc7c6bc34d19749d220cb099be4dd460184b052a4/oterm-0.26.1.tar.gz"
  sha256 "b60a9ad8856aaf60fa7f9cba3be7707f7cc1886a7530a143b86df7095ba74257"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "14fb41114d2a8b244c52918281a49330a5fd561b643f64da131dd8067b02fe98"
    sha256 cellar: :any, arm64_tahoe:       "b66fc78cf47b77ddef9f54bdfc32d99215ba2b3fba177841873edced2a6a6317"
    sha256 cellar: :any, arm64_sequoia:     "2a1ae3d8b8460ca7a08df3fb5aa8b570ce5eb7fdea5e4d7266829cfa6fdd6c52"
    sha256 cellar: :any, arm64_linux:       "6b8bf992c8593cf47bdddc90a28a02d0d5e0ad85722532c5a2329840abd6a0ed"
    sha256 cellar: :any, x86_64_linux:      "4020c5450c0f413d8d79fedcbcdc20fa16a76b3e537a817901d448e0838d2a74"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for textual_speedups
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic rpds-py],
                extra_packages:   %w[jeepney secretstorage]

  resource "aiofile" do
    url "https://files.pythonhosted.org/packages/14/31/edb06aabd8f8f0b56d659f30800795f40b93cba96be946ce179f6931e3a5/aiofile-3.12.3.tar.gz"
    sha256 "caa6aa746b5e47e2165f7abd741b6415e49cf4d44fddc0f61844612cc3924d41"
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
    url "https://files.pythonhosted.org/packages/0f/6e/a61e86e43bb6039b31a33a8f5fba76fe1cdacf3661e7b9756d4ff1b28cdc/annotated_doc-0.0.6.tar.gz"
    sha256 "7969bb69912085b2285849c0dcac0b4b374fd180c13cf10a87f284ffcf347bbf"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/75/e6/aabc3c266a0aaf38fa542648585741fce9616ba4cd034ddde74548f790a0/anthropic-2.8.0.tar.gz"
    sha256 "d34e389ba0544cd64e033eb7475f46cc1ac6f2a388cdcd472b33ad4ac29ef40c"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a1/98/7e457a3b014976887a050561955c0b76e1e7e2d6e27b78ecef2ef80518f2/anyio-4.16.0.tar.gz"
    sha256 "59bb03251907983d1603d27c3087ddb1e93299ea2163adcdba37899a4fb12ffb"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/04/96/6e7ed72bb49762a9b65d51c4cb235d793f0485cd8d6f7e9404ce955a4808/authlib-1.9.5.tar.gz"
    sha256 "3f031d5e9b6486089e91e8f7f1b68f36275f3151c66460d650fc90d420545fd7"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/79/34/c0cfdaee9c796c8381439fed0fcab62810753b8b0adb1ec88fa7f41eaa5d/beartype-0.23.1.tar.gz"
    sha256 "8b805f246b32931c74f2b321ea0939fe5bb2ff43c12a3eff19cc4c854b832e1d"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/91/02/d46523af0a933c35604e2bbb33e4ca8f69a00f9990af6d6b29ed84db64aa/boto3-1.44.1.tar.gz"
    sha256 "c81dfdaab894cbcba78aa3773fe3fb27a13b576f49ff5552b91190072fc7dac0"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b1/61/07918ec258ab7131dd601cb1aaffcd7fa008fa8bb0143fd195ecc4b4435d/botocore-1.44.1.tar.gz"
    sha256 "e71f6249be2a7324899ba81c5958ac1809a78498ea2c8f60e00fc0e62262ab83"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/e6/60/ac2d44dbfcca28a35151af27ad9c6236d913a67768b5bb88af90a8c02943/cachetools-8.0.0.tar.gz"
    sha256 "5ed01bd676800d51f0025605e4fd8ad0891550513e7b0a4c3da478463764e5c3"
  end

  resource "caio" do
    url "https://files.pythonhosted.org/packages/66/66/a36d1367bd5ef70b6b97b2fb502f682106555e9e49e229f35c0a49d154d5/caio-0.12.10.tar.gz"
    sha256 "5cecc44c04d5c6291d98b61bdba999f49a7e58dff2d782b4bb0642dc6f7ecf58"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/45/37/edbf1b0707709013c0cf2e8317e03d97ed29bf4cac709fe328904ae92a38/click-8.5.1.tar.gz"
    sha256 "9bbfada76703fd1d784b83eea012e3e8c6a001a876543ef104fa56aaaeb072b4"
  end

  resource "cohere" do
    url "https://files.pythonhosted.org/packages/dd/96/8dc291c7fd243dcb0d83f9dc043e8bac8828e414cf34adf3ecea6dfa14ba/cohere-7.3.1.tar.gz"
    sha256 "549a4beb10ff09d183a0d55bf91e47761e3fe680781f8717c630838895ba5f08"
  end

  resource "ddgs" do
    url "https://files.pythonhosted.org/packages/ec/c4/165b9b1581813063847349421c014a8ccc346222a58b3233ba168bf257c1/ddgs-9.16.1.tar.gz"
    sha256 "0cde5682e5801b838915bcb1d12ade8f2e1ec11763b88d0035a1faa0662b517a"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/76/49/900383b471c645a3c397f47b3211d1fcecb3a540c98f683494cdf86b33de/dnspython-2.9.2.tar.gz"
    sha256 "8d4d39a513e649d634004ce4d39ade2352efcea472a0247535a5c2d18a9d7ba9"
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
    url "https://files.pythonhosted.org/packages/52/92/8a611141e42930c0f194f7504063ab87dfe970cf1a5af28e7703df448734/executing-2.3.0.tar.gz"
    sha256 "15919cb5d667e5cb4e099511971d00d659573fff2dd5c4e6cd8b71636c7858d2"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/d6/ee/05cae1eeb332f876a1226b382a1f1be4ac8ce66634c313f2746beadab16f/fastavro-1.13.1.tar.gz"
    sha256 "6f05aa2539bf7a19e9eb3bdaf6580c4d0f082a8230f641eaf9c84e4bcf0e6bc4"
  end

  resource "fastmcp-slim" do
    url "https://files.pythonhosted.org/packages/90/fa/9cb1e558884b18ea367f3065e56cda9259efa0c4e54954f4e53a7fee9f20/fastmcp_slim-4.1.8.tar.gz"
    sha256 "e0f194baca7f5781a554d07879cb709beed1a2d0796949e3693e0a96e291506a"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a1/cf/05bcdacabdc0aec7dc8e19d76281bd82325df62dae3b6430e9ba57397689/filelock-4.2.10.tar.gz"
    sha256 "fcc3c0cb8bfe7f4b3bb0e231c04b15dbad068cb3c2515f343d8fde4dce93bd5d"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "genai-prices" do
    url "https://files.pythonhosted.org/packages/ad/de/119c7ba00b9ddbf629de34cf390ab472da6d7bc5df0c51cdbec900280a74/genai_prices-0.1.13.tar.gz"
    sha256 "76c9e2dd3917fdacdf3bc562297c4591384142ea2283c477e1512fafa4e3a384"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/4a/d4/87353e950d653d87360176363d51f316e8e368e1ddbb7ba7aa5503c30c3e/google_auth-2.62.2.tar.gz"
    sha256 "046c61a72d3a847d6df6417a7f0d5cf054e3b82bbcb54fb1e69d47880964049c"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/6b/fa/041ef12c71d6e150d8fb99049847388aa0d349d98a7c67614746a7b6ef65/google_genai-3.2.0.tar.gz"
    sha256 "b848937937b7b72594e75c57f01618ca201275afaedbfd717c004434ebf592f5"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/62/b6/bc095b23a3e0d978e75c8c18cabe4c11f791837410670e4486f0d539bfba/googleapis_common_protos-1.76.0.tar.gz"
    sha256 "71db0e44a1d4c2dd024ebad44ca67129cc1e2892e4861df466764749d5ef8642"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/36/e2/0f5d8ed08766bc6dcd3eebf5a6623d83cbca33a6e4c90aef57156ce745ad/griffelib-2.4.1.tar.gz"
    sha256 "40c028dd2e623f464423f0e11e3c553158f1cf4f1368239a370534d73e1407ff"
  end

  resource "groq" do
    url "https://files.pythonhosted.org/packages/0c/c1/20cb719bc21aa22df185c4aa60abc17680d7067d41fe0ca3fda98b75822b/groq-1.7.0.tar.gz"
    sha256 "d582dbb3f071b92ca339baba83af9f57ba6f46a51c34b04565d7cb9badb2785b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/48/0f/ed994dbade67a54407c28cab96ef845e0e6d25500be56aca6394f8bfc9dd/huggingface_hub-1.16.1.tar.gz"
    sha256 "7f1dc4c5ec21aed69be630ad0c3378616be16f3de1a47b141c0e812965d9c832"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/67/de/8dfd06a2153d8ab6a83a8ca8f8ae3ff860ce2fe324ee6a5d05294b621c2a/jiter-0.19.0.tar.gz"
    sha256 "ba3064f8be276d7cfb83c2fb85c858be533da2c2f80f9b048c3781b45a57a195"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/74/31/5c3f27e82c92a7bbe1f028033ff19e0251540395c9be244c01a50de42bdb/joserfc-1.8.0.tar.gz"
    sha256 "cbf03cb2c6db8cc5289f1ef8718842e53dba244b4c0de5fefa0c0eaee4bde8db"
  end

  resource "json-repair" do
    url "https://files.pythonhosted.org/packages/78/2b/537bf1dab1c058bfb2287662bf6c10de0c3907570781ccc0fc56878e39a7/json_repair-0.64.9.tar.gz"
    sha256 "0e7e02e1c04d14b3677f97d13a8ff6b473cacb07b7111857c4202721b14efdc2"
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

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "logfire" do
    url "https://files.pythonhosted.org/packages/75/74/9924a954e45fc69f1dfeef05307ce8afa22a3a2233cc80fdb0d1c341b61d/logfire-5.6.0.tar.gz"
    sha256 "a28f9063eb0110b6c26240aa54e4313ce5953f0512a10d999660401db0ec37d0"
  end

  resource "logfire-api" do
    url "https://files.pythonhosted.org/packages/75/86/00b6bd2e60ac09b26c6e147da48d83dc8706defc2ebde8b003ce6de2b059/logfire_api-5.6.0.tar.gz"
    sha256 "e2341041ebe7bb0283d41e5defa03655f04706b2eeede9b89b6fc23b955ee565"
  end

  resource "logfire-sdk" do
    url "https://files.pythonhosted.org/packages/99/80/903b3107a2ff2a0fc0f018207971098193dc2be7fa45dbcf2499f0fcb5b1/logfire_sdk-5.6.0.tar.gz"
    sha256 "ecbf85377d355443087197e8301686eae5c44cdbf8eb39a9ab1c0571f9da2a56"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/92/ab/d1297139c0e2ceb151ae564c8c4f57ac0155d8f1f8b4cbd5d6523c82ea36/markdownify-1.2.3.tar.gz"
    sha256 "1a176f05522c8a2cb1dd3ab9d307dcdadbed5c26ae717855bfc42b3b6d38d937"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/9d/8d/e0d339616f4810e9051d4aba6887afab289ab1f81875fe908b606cdfd0e3/mcp-2.3.0.tar.gz"
    sha256 "8b147a50441cf059dc88c684e0aeed3687f0aa0f39c6cde7b90330effd2b34d8"
  end

  resource "mcp-types" do
    url "https://files.pythonhosted.org/packages/9e/2d/7c251e34207f6c51000312fc8839111ac45cfe02023f90b44e7f1051dd8e/mcp_types-2.3.0.tar.gz"
    sha256 "d1e46549edb35ee19a94940fcee6d1addd7e589ab7ea92dda83f5d84781fc362"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/ad/a4/77a4e1be19fd9b08993c76d5e54979ac836b327754f1f5fecfed1b56cc67/mdit_py_plugins-0.7.0.tar.gz"
    sha256 "26d2179227aaf4d1dc7acffe7a738cbd15cade6b5a61cff0a2cbf9fed93efede"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mistralai" do
    url "https://files.pythonhosted.org/packages/3f/ca/10a0515ded34170e1ea451a6d1c7124361e4fab8ba5d5024db34db1fb9d3/mistralai-3.7.0.tar.gz"
    sha256 "97cc525b8ddc96fb8b5bb08f466dd3d22f904f21ddfe45103da76c25fe601bf2"
  end

  resource "ollama" do
    url "https://files.pythonhosted.org/packages/fc/72/5f12423b6b39ca8430fbe56f77fcf4ef60f63067c7c4a2e30e200ed9ec16/ollama-0.6.2.tar.gz"
    sha256 "936d55daa684f474364c098611c933626f8d6c7d67065c5b7ae0c477b508b07f"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/83/8f/adc3e9f7077c16a2417eebb219df2f5933f4fa532fab143c6bbb1c287c67/openai-3.49.0.tar.gz"
    sha256 "44badf2bea9bcd643dafa0bc4d5a109a14395889219fd68b8560322288196e96"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/19/14/cf3a6b6448849656e1e5f4e2101f3988dc6789724050096aba1bc5ccf592/opentelemetry_api-1.45.2.tar.gz"
    sha256 "d7b0008e21e5fd61cbe7a7f34ca3b6905a78ab677d9bc395e299359c75cda6b4"
  end

  resource "opentelemetry-exporter-http-transport" do
    url "https://files.pythonhosted.org/packages/a6/e6/dbeb3e217418071656232a4028c791060d219f218cef1249b664049d12c0/opentelemetry_exporter_http_transport-0.66b2.tar.gz"
    sha256 "66d6ed810a515432c8891da9a834464332fd70badeca45bdeeae81b4280c903b"
  end

  resource "opentelemetry-exporter-otlp-common" do
    url "https://files.pythonhosted.org/packages/5a/3c/3f2cc8c42bde2620e65024d71e2eb025f7bd0821bb363b52bcc5a3260dbd/opentelemetry_exporter_otlp_common-0.66b2.tar.gz"
    sha256 "06f5a9b88638e310efa1f1d206cdf6b75393e112aba4e174a963416192bd1028"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/69/58/239c98b36d9ea317098769957043c251703636a26189c884fba46c1dad84/opentelemetry_exporter_otlp_proto_common-1.45.2.tar.gz"
    sha256 "f1f2806f3f28ce7938033823e50934fcd91595a39de38e69a28a51e19f40fc6d"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/db/07/b7b01ecb69d02f540e679a9e36f7413d081f225bbbed4469d212ada10bb7/opentelemetry_exporter_otlp_proto_http-1.45.2.tar.gz"
    sha256 "5984a3fb46bc4628e4e2b85d4a6e72637e03962aae6cf372791137768a4ad939"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/76/b9/46a136199fa6928eecefec8418867a460d94f01c608a85d22bd2ed4e8d48/opentelemetry_instrumentation-0.66b2.tar.gz"
    sha256 "02b094150e53b76f5906d75e628dbb3833bbc6e62fa109b5c7ba0c081865e923"
  end

  resource "opentelemetry-instrumentation-httpx" do
    url "https://files.pythonhosted.org/packages/41/43/3204ca7e7d91bd9e1b569a98a5f9252c98ae70ba3bb562d2770c34e21d49/opentelemetry_instrumentation_httpx-0.66b2.tar.gz"
    sha256 "b4c81e4a6dc7b8d7cb2d3088eb8848f6db6bd4abdc443ac9586ec176f1460187"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/24/9c/1aa4ce60e9bc72af20dc49c92cc0566825092d92b3d6a277439fb5fb7c01/opentelemetry_proto-1.45.2.tar.gz"
    sha256 "bd8d23cf770605b0af9b7be2071d26a464fea289d35429abfd2a66226114ad64"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/7b/1a/74a21d4d6969fb8b432ac397e66112a8167a6deb267ea4559dbaf2fe91ef/opentelemetry_sdk-1.45.2.tar.gz"
    sha256 "7eec4de13dd21ff3a1670dcb0e02079e692736f94d733dfdce5af461d884248d"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/37/3f/50f95972b50e8e353f5b9342034c9cd17730f1956f009ce6a3fbbd89f9ce/opentelemetry_semantic_conventions-0.66b2.tar.gz"
    sha256 "7da5f1a5dc4383eb66711d4d3d3e71824d9403ac1559fea021cc103c1a4c4976"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/d6/57/33566966a7bced4d02fbc672f92029184e4a743f5b531e44b4c0dc4c999b/opentelemetry_util_http-0.66b2.tar.gz"
    sha256 "7ba066ea609202e474679ddf1d0f753a1e6619bd206b36afaecba4bbb86e25d0"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/d7/9a/8475be631fb33ca1466915e70fd594c42a4e84b512db650eaa14f90fe75d/platformdirs-4.14.5.tar.gz"
    sha256 "32e9921db7385aa8169bee4fe9501923e5715ba9fb7ea3b9c69b0d8e0639f7a1"
  end

  resource "primp" do
    url "https://files.pythonhosted.org/packages/c7/01/c2a43378aaaf29539971766a007f3185fbe3f208f431b0969fa85c5a2111/primp-2.0.1.tar.gz"
    sha256 "82ba17b077bef19a189d9ec8d77ca632496cb444e0f4fa37e27e90041cf0da8f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/ca/99/c346e3474853801ec5ecf4c3ee60cfc6060327ebc31424df4e346620dde4/py_key_value_aio-0.4.6.tar.gz"
    sha256 "267c03c3e24cb99d3097612f8a5cfd8e11785c6a2975e272db0e303ea1850bfd"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/88/7e/3c0da41061a2021cac7cd524fd57092adbe5b515e8bf9005702e366802e2/pyasn1-0.6.5.tar.gz"
    sha256 "6b11616a6bcf3a40e635f082bb232fa57b5e0dd7f517bd7ddd69ec3794508a47"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic-ai-harness" do
    url "https://files.pythonhosted.org/packages/09/e3/3bba6cac3863e3a7e3d56b14b939138cb559a267b6ec629f491adc3b3704/pydantic_ai_harness-0.59.0.tar.gz"
    sha256 "1036b93109b8e617909612e7877016332124a57fb609c1787b2d7bb5b96bff84"
  end

  resource "pydantic-ai-slim" do
    url "https://files.pythonhosted.org/packages/c3/1e/cd44ec11b296ec93fb9412f9aaef2b265f60e49a75b49cc0b2c6b1aa60fd/pydantic_ai_slim-2.59.0.tar.gz"
    sha256 "ce441e646dd79a8dd80ef19c9f6821d803857f08870b260b61db5e8e7af95010"
  end

  resource "pydantic-graph" do
    url "https://files.pythonhosted.org/packages/e0/36/f00e344d48ab0065b5d93692dcd6245f4400dc946140b1fdc56657deb5d8/pydantic_graph-2.59.0.tar.gz"
    sha256 "f8cf18e18cdea6c6ee412017373c156e4fadc0b4b205c174d564d878d1765989"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/d0/31/21d21e0e38a8f5f7a7f0cde22820117b6d17d6bc36f348129527f915d7f4/pydantic_settings-2.16.2.tar.gz"
    sha256 "3dc08ffabed2bbd5dc2dd55ead7b78b4e4c5cd776aecd04310db5f1224caaf46"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/9f/b7/15b905f6142a9a8a68f66900788da1a32e4d4254452783b37ad1eccb0506/python_multipart-0.0.33.tar.gz"
    sha256 "b8112424a6abd162ec08d390565dd113ad699f2fe6fef3c987b8bbcbfe9e390d"
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
    url "https://files.pythonhosted.org/packages/61/27/a5afeb952577b84ee5fe48b8b9ce47ae662dbb69cc5b76c28eff98f83b1e/regex-2026.11.9.tar.gz"
    sha256 "316a70fbd70e999c9664681cb0eb5b4982b2cc0f623c7c86a8a112e1bd4c6277"
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
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
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

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/95/48/21a393ff731b8f928fa4f8176f9a7ceba2252ee60a5149f25b45c292aa5c/soupsieve-4.1.tar.gz"
    sha256 "ca9abf7126667010d8f6e9b39bfc1bc3b23c8aed9bcb0f54a754dde969bb8aab"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/41/43/a232e3cd804293bd4f6d01e8895bc0f6f83ea148d712baf9d783c7d93d23/sse_starlette-3.7.0.tar.gz"
    sha256 "326416da2ab52e9a41b3f409d3ff897eda45aa68c9f3b7b17d0913aab8d219c3"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
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

    patch do
      url "https://github.com/willmcgugan/textual-speedups/commit/acb510d0dafa82ca1bd4291a880c6785b96be5f3.patch?full_index=1"
      sha256 "7eeb90dbfc3ecb903827c61314941b590f105279b297c8eb57bb664be916f26e"
      type :unofficial
      resolves "https://github.com/willmcgugan/textual-speedups/pull/11"
    end
  end

  resource "textualeffects" do
    url "https://files.pythonhosted.org/packages/cc/40/5d28a460c8b3fb071df67dd0fbf1125b0373d0ef5a9105e6a146bacc530d/textualeffects-0.2.0.tar.gz"
    sha256 "e42f3865dbdc815831ae8159c9c39d1dd0789b2dea2bc6f8c15c43e2477e5df1"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/66/62/167a842aa0429d45f5e797354fd4343a96f6043d67d0513c675c7b8d36e6/tiktoken-0.14.0.tar.gz"
    sha256 "231dec90efcdccf1b565a1416107736f1e09b1a08fe736ef9d6363e626d03874"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/e0/7c/2cabb2174e772636683008f2c5621949b645da7d303c596589e84516a184/tokenizers-0.23.3.tar.gz"
    sha256 "cded33237c77caeef62944d32aa9a7ef42bdce2b3497e18d137e072a8c4be438"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/a6/15/63ec82f647272ae3df5124def156344ab8856d29d8c4931947f1f15c003b/types_requests-2.33.0.20261030.tar.gz"
    sha256 "42d75eb02ed0f8220904c8fc08d3129742e7fce42fd5cf706395c8bb4c0ad990"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/75/79/590c5f0cc7d1661195aeefccb0e342b79f4c77d368d526d028821a390332/websockets-17.4.tar.gz"
    sha256 "09d3939b70df0c8ad2da145ebd50978bccaee1d565e838b0e7921a34d38571eb"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/9c/b0/f752d19e1e83ab8bd64aeccfde32ff086aee3ef08520f7340b69a8d0a4d2/wrapt-2.5.2.tar.gz"
    sha256 "551cb49e88b3722faad780303833bc4fa70685fb1773270fb98b40d39d9fddbf"
  end

  # FIXME: remove `livecheck` when `pydantic-ai-slim` drops its `hf-xet<1.5.0` cap
  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"

    livecheck do
      skip "Skip until `pydantic-ai-slim` drops its `hf-xet<1.5.0` constraint"
    end
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG for primp
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"
    # `tokenizers` and `hf-xet` build PyO3 extensions through maturin.
    ENV.append_to_rustflags "--codegen link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    without = ["hf-xet"]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    resource("hf-xet").stage do
      # Use native-tls rather than needing to build another rustls + aws-lc
      inreplace %w[xet_client/Cargo.toml xet_data/Cargo.toml xet_pkg/Cargo.toml],
                'default = ["rustls-tls"]', 'default = ["native-tls"]'
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"oterm", shell_parameter_format: :typer)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oterm --version")
    assert_match "EnvConfig", shell_output("#{bin}/oterm --config")
  end
end
