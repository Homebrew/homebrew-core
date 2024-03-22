class Gptline < Formula
  include Language::Python::Virtualenv

  desc "ChatGPT client with native iTerm2 support"
  homepage "https://github.com/gnachman/gptline"
  url "https://files.pythonhosted.org/packages/5b/28/d15a9a5b349c77a051a633e13141151314f352067ec7d516220bd6b20fcf/gptline-1.0.8.tar.gz"
  sha256 "4a0a0b5fa4f23e5f2ad7ac5bf44a9143e5de3757b0b8eefe5d78a7757d1d34bb"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/gnachman/gptline.git", branch: "main"

  bottle do
    rebuild 3
    sha256 cellar: :any,                 arm64_sonoma:   "6ed402b04da7a65e0cf835eb9bd42ab246ca583fb89c6da1e8da116da7f11712"
    sha256 cellar: :any,                 arm64_ventura:  "1817b53986e0b39d3ec089cb23868c514b5891ca15675f03c94d57052051d631"
    sha256 cellar: :any,                 arm64_monterey: "8d23f0ad44c7723358db2024dc50e5f6cbaca19ed88220e927ef631d6a364573"
    sha256 cellar: :any,                 sonoma:         "f9faf74783868d1d634151c893a1cf0492d33fb35e780a5984a239bf38a9d0d7"
    sha256 cellar: :any,                 ventura:        "592f45bc6a5c077b52a9801d60065f86827d3039c11b8e900ba28c37b4ad87e9"
    sha256 cellar: :any,                 monterey:       "b68d3465da622599ceba58df90164b41e897e83f880d03aeba29c699ef96db83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bad42d1c9b37b4eefe0453259f649669bd72bb4a4a95a455cae7dfb363272139"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "jpeg-turbo"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.12"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/67/fe/8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4/annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/db/4d/3970183622f0330d3c23d9b8a5f52e365e50381fd484d08e3285104333d3/anyio-4.3.0.tar.gz"
    sha256 "f75253795a87df48568485fd18cdd2a3fa5c4f7c5be8e5e36637733fce06fed6"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/b3/ca/824b1195773ce6166d388573fc106ce56d4a805bd7427b624e063596ec58/beautifulsoup4-4.12.3.tar.gz"
    sha256 "74e3d1928edc070d21748185c46e3fb33490f22f52a3addee9aee0f4f7781051"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/d1/91/d51202cc41fbfca7fa332f43a5adac4b253962588c7cc5a54824b019081c/cssselect-1.2.0.tar.gz"
    sha256 "666b19839cfaddb9ce9d36bfe4c969132c647b92fc9088c4e23f786b30f1b3dc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "feedfinder2" do
    url "https://files.pythonhosted.org/packages/35/82/1251fefec3bb4b03fd966c7e7f7a41c9fc2bb00d823a34c13f847fd61406/feedfinder2-0.0.4.tar.gz"
    sha256 "3701ee01a6c85f8b865a049c30ba0b4608858c803fe8e30d1d289fdbe89d0efe"
  end

  resource "feedparser" do
    url "https://files.pythonhosted.org/packages/ff/aa/7af346ebeb42a76bf108027fe7f3328bb4e57a3a96e53e21fd9ef9dd6dd0/feedparser-6.0.11.tar.gz"
    sha256 "c9d0407b64c6f2a065d0ebb292c2b35c01050cc0dc33757461aaabdc4c4184d5"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/70/70/41905c80dcfe71b22fb06827b8eae65781783d4a14194bce79d16a013263/filelock-3.13.1.tar.gz"
    sha256 "521f5f56c50f8426f5e03ad3b281b490a87ef15bc6c526f168290f0c7148d44e"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/6c/f9/033a17d8ea8181aee41f20c74c3b20f1ccbefbbc3f7cd24e3692de99fb25/html2text-2020.1.16.tar.gz"
    sha256 "e296318e16b059ddb97f7a8a1d6a5c1d7af4544049a01e261731d2d5cc277bbb"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/94/f1/47528a2f465b09c71caad95f5de1d7225e438cf3d1068d278362a4a6bc6a/httpcore-1.0.3.tar.gz"
    sha256 "5c0f9546ad17dac4d0772b0808856eb616eb8b48ce94f49ed819fd6982a8a544"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/bd/26/2dc654950920f499bd062a211071925533f821ccdca04fa0c2fd914d5d06/httpx-0.26.0.tar.gz"
    sha256 "451b55c30d5185ea6b23c2c793abf9bb237d2a7dfb901ced6ff69ad37ec1dfaf"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jieba3k" do
    url "https://files.pythonhosted.org/packages/a9/cb/2c8332bcdc14d33b0bedd18ae0a4981a069c3513e445120da3c3f23a8aaa/jieba3k-0.35.1.zip"
    sha256 "980a4f2636b778d312518066be90c7697d410dd5a472385f5afced71a2db1c10"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/15/0f/d3b33b9f106dddef461f6df1872b7881321b247f3d255b87f61a7636f7fe/joblib-1.3.2.tar.gz"
    sha256 "92f865e621e17784e7955080b6d042489e3b8e294949cc44c6eac304f59772b1"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/2b/b4/bbccb250adbee490553b6a52712c46c20ea1ba533a643f1424b27ffc6845/lxml-5.1.0.tar.gz"
    sha256 "3eea6ed6e6c918e468e693c41ef07f3c3acc310b70ddd9cc72d9ef84bc9564ca"
  end

  resource "newspaper3k" do
    url "https://files.pythonhosted.org/packages/ce/fb/8f8525be0cafa48926e85b0c06a7cb3e2a892d340b8036f8c8b1b572df1c/newspaper3k-0.2.8.tar.gz"
    sha256 "9f1bd3e1fb48f400c715abf875cc7b0a67b7ddcd87f50c9aeeb8fcbbbd9004fb"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/57/49/51af17a2b0d850578d0022408802aa452644d40281a6c6e82f7cb0235ddb/nltk-3.8.1.zip"
    sha256 "1834da3d0682cba4f2cede2f9aad6b0fafb6461ba451db0efb6f9c39798d64d3"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/5b/25/907dbe5ee7972a8b7bed51516e23196607ce7048fde0c554d98f2e2ae7bd/openai-1.12.0.tar.gz"
    sha256 "99c5d257d09ea6533d689d1cc77caa0ac679fa21efef8893d8b0832a86877f1b"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/cc/c6/25b6a3d5cd295304de1e32c9edbcf319a52e965b339629d37d42bb7126ca/prompt_toolkit-3.0.43.tar.gz"
    sha256 "3527b7af26106cbc65a040bcc84839a3566ec1b051bb0bfe953631e704b0ff7d"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/73/27/a17cc261bb974e929aa3b3365577e43c1c71c3dcd8669250613a7135cb8f/pydantic-2.6.1.tar.gz"
    sha256 "4fd5c182a2488dc63e6d32737ff19937888001e2a6d86e94b3f233104a5d1fa9"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/0d/72/64550ef171432f97d046118a9869ad774925c2f442589d5f6164b8288e85/pydantic_core-2.16.2.tar.gz"
    sha256 "0ba503850d8b8dcc18391f10de896ae51d37fe5fe43dbfb6a35c5c5cad271a06"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/55/59/8bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565/pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/cd/e5/af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0/PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/b5/39/31626e7e75b187fae7f121af3c538a991e725c744ac893cc2cfd70ce2853/regex-2023.12.25.tar.gz"
    sha256 "29171aa128da69afdf4bde412d5bedc335f2ca8fcfe4489038577d05f16181e5"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/2b/69/ba1b5f52f96cde4f2d8eca74a0aa2c11a66b2fe58d0fb63b2e46edce6ed3/requests-file-2.0.0.tar.gz"
    sha256 "20c5931629c558fda566cacc10cfe2cd502433e628f568c34c80d96a0cc95972"
  end

  resource "sgmllib3k" do
    url "https://files.pythonhosted.org/packages/9e/bd/3704a8c3e0942d711c1299ebf7b9091930adae6675d7c8f476a7ce48653c/sgmllib3k-1.0.0.tar.gz"
    sha256 "7868fb1c8bfa764c1ac563d3cf369c381d1325d36124933a726f29fcdaa812e9"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/79/79/3ccb95bb4154952532f280f7a41979fbfb0fbbaee4d609810ecb01650afa/simplejson-3.19.2.tar.gz"
    sha256 "9eb442a2442ce417801c912df68e1f6ccfcd41577ae7274953ab3ad24ef7d82c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/3a/7b/a8f49a8fb3f7dd70c77ab1d90b0514ab534db43cbcf8ac0a7ece57c64d87/tiktoken-0.6.0.tar.gz"
    sha256 "ace62a4ede83c75b0374a2ddfa4b76903cf483e9cb06247f566be3bf14e6beed"
  end

  resource "tinysegmenter" do
    url "https://files.pythonhosted.org/packages/17/82/86982e4b6d16e4febc79c2a1d68ee3b707e8a020c5d2bc4af8052d0f136a/tinysegmenter-0.3.tar.gz"
    sha256 "ed1f6d2e806a4758a73be589754384cbadadc7e1a414c81a166fc9adf2d40c6d"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/02/21/4f2d7d6023650770112dd8144dbc47afabbfaf568a0d39abc0a4f37e8e9e/tldextract-5.1.1.tar.gz"
    sha256 "9b6dbf803cb5636397f0203d48541c0da8ba53babaf0e8a6feda2d88746813d4"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/ea/85/3ce0f9f7d3f596e7ea57f4e5ce8c18cb44e4a9daa58ddb46ee0d13d6bff8/tqdm-4.66.2.tar.gz"
    sha256 "6cd52cdf0fef0e0f543299cfc96fec90d7b8a7e88745f411ec33eb44d5ed3531"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/0c/1d/eb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96/typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/gptline", 1)
    assert_match "Set the environment variable OPENAI_KEY or OPENAI_API_KEY to your api secret key", output
  end
end
