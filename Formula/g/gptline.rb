class Gptline < Formula
  include Language::Python::Virtualenv

  desc "ChatGPT client with native iTerm2 support"
  homepage "https://github.com/gnachman/gptline"
  url "https://files.pythonhosted.org/packages/5b/28/d15a9a5b349c77a051a633e13141151314f352067ec7d516220bd6b20fcf/gptline-1.0.8.tar.gz"
  sha256 "4a0a0b5fa4f23e5f2ad7ac5bf44a9143e5de3757b0b8eefe5d78a7757d1d34bb"
  license "GPL-3.0-only"
  revision 24
  head "https://github.com/gnachman/gptline.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "cef96e1b87bae916eab5874c0f5a7fa3eb2255a2d55dd3f1fce5b7c7a44306f0"
    sha256 cellar: :any, arm64_tahoe:       "2146aa1aee4c36cadfc76c88ff56455ad17bae20f01de61fa35e5a19abec153a"
    sha256 cellar: :any, arm64_sequoia:     "27af88c49f29371900577f3b6b89b67baa8a0a37343473c1b993f3fab20af7d9"
    sha256 cellar: :any, arm64_linux:       "49da33793241f5c021995fddd395cee65ec746e9c773167778d8c3b08a94c2c1"
    sha256 cellar: :any, x86_64_linux:      "57f3736fda8b681ac59975c0280fb4b0d70187264a110c81dffabf98c9402bdb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for jiter, tiktoken
  depends_on "certifi" => :no_linkage
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libraqm"
  depends_on "libtiff"
  depends_on "libyaml"
  depends_on "little-cms2"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "webp"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: %w[certifi pillow pydantic],
                extra_packages:   "lxml-html-clean"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "blessings" do
    url "https://files.pythonhosted.org/packages/5c/f8/9f5e69a63a9243448350b44c87fae74588aa634979e6c0c501f26a4f6df7/blessings-1.7.tar.gz"
    sha256 "98e5854d805f50a5b58ac2333411b0482516a8210f23f43308baeb58d77c157d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "cloudpickle" do
    url "https://files.pythonhosted.org/packages/27/fb/576f067976d320f5f0114a8d9fa1215425441bb35627b1993e5afd8111e5/cloudpickle-3.1.2.tar.gz"
    sha256 "7fda9eb655c9c230dab534f1983763de5835249750e85fbcef43aaa30a9a2414"

    # TODO: Remove when cloudpickle releases the Flit 4 metadata fix, upstream PR ref, https://github.com/cloudpipe/cloudpickle/pull/598
    patch do
      url "https://github.com/cloudpipe/cloudpickle/commit/465ac44aa0c85c81fa21324a8c698ad86be38d18.patch?full_index=1"
      sha256 "35f578d5709b32811fe7cdceec6e9df2ddc90578f39e29de8df54bfe323f25f6"
      type :backport
      resolves "https://github.com/cloudpipe/cloudpickle/pull/598"
    end
  end

  resource "cssselect" do
    url "https://files.pythonhosted.org/packages/c8/8b/dc32df939ab541fca6ee8964d26aa231dbe231cdc2b2713228161441ba9c/cssselect-1.6.0.tar.gz"
    sha256 "8c83a7139e97b93aa5ebdc0f46e785f7056a08a8bf201e597a6a2629d7eb11db"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "feedfinder2" do
    url "https://files.pythonhosted.org/packages/35/82/1251fefec3bb4b03fd966c7e7f7a41c9fc2bb00d823a34c13f847fd61406/feedfinder2-0.0.4.tar.gz"
    sha256 "3701ee01a6c85f8b865a049c30ba0b4608858c803fe8e30d1d289fdbe89d0efe"
  end

  resource "feedparser" do
    url "https://files.pythonhosted.org/packages/37/8a/a53da4a77352045d277978a2df322d5379369f9deb1707178899ff7e1121/feedparser-6.0.14.tar.gz"
    sha256 "088679b0c4b543ee211a820dd544698c76a402122eae7473c04a43425f283d06"
  end

  resource "feedparser-sgmllib" do
    url "https://files.pythonhosted.org/packages/da/df/38596299216e5c22d60ed7f97902bb2bc72cfb95f732400f4fa976fd2e62/feedparser_sgmllib-2.1.0.tar.gz"
    sha256 "61facf2918c4389b5b00714f76c5e03431ffcd94cd1f51d657edd6cd7c396579"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/4c/58/6fd434bec86eff7c38a3168454cb132b762b2bea9b3ac094101a2f7bc32a/filelock-4.1.0.tar.gz"
    sha256 "ad7f724afef953e731b1cc39bcd3a09166d72ed7fcdf29e6e88b1c3235c6715d"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/cb/f3/1db7aa2bc2524062192bb0e0323969492d1883152a232fe36eea65f4e35c/httpcore2-2.13.1.tar.gz"
    sha256 "e0aa977abe17e69a3b820a24542a6fa88702676d83880b8d194dcd18408e5103"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/d5/44/474bef2a0e9d90f1715d32cb98b0738695ca17ba324095fb2497ed7fbd59/httpx2-2.13.1.tar.gz"
    sha256 "e48744a19e3af5ee48313d0ce5fe941d5422fae5705ea922a4aabf94d7800dfa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jieba3k" do
    url "https://files.pythonhosted.org/packages/a9/cb/2c8332bcdc14d33b0bedd18ae0a4981a069c3513e445120da3c3f23a8aaa/jieba3k-0.35.1.zip"
    sha256 "980a4f2636b778d312518066be90c7697d410dd5a472385f5afced71a2db1c10"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9c/1f/8176d92e001f86505424b41664032ae26a882bc9ca41a32c803f373f9195/jiter-0.17.0.tar.gz"
    sha256 "03e432f226a453851079fb84cd17c6da9991eab723e28d716f14ae3d906e0c12"
  end

  resource "joblib" do
    url "https://files.pythonhosted.org/packages/d5/1d/537ab090f302b838943a1b56497dd53059b9a9b46a074936470173a2e207/joblib-1.6.0.tar.gz"
    sha256 "2ccc96785b12046c08fd6d55839c12857831b54a3c1673ffadd2f04bfc4eda03"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "lxml-html-clean" do
    url "https://files.pythonhosted.org/packages/0a/63/195dfdde380a84df309e3bccf4384b034b745dba43426886f7ae623b4fba/lxml_html_clean-0.4.5.tar.gz"
    sha256 "e2a4c7d5beedd17cd7b484d848a0571e54baa239a4f9df5546e3acba7f990560"
  end

  resource "newspaper3k" do
    url "https://files.pythonhosted.org/packages/ce/fb/8f8525be0cafa48926e85b0c06a7cb3e2a892d340b8036f8c8b1b572df1c/newspaper3k-0.2.8.tar.gz"
    sha256 "9f1bd3e1fb48f400c715abf875cc7b0a67b7ddcd87f50c9aeeb8fcbbbd9004fb"
  end

  resource "nltk" do
    url "https://files.pythonhosted.org/packages/e0/e6/fe51d2bb1a3b446f59c5c8165999a9fee208bc346af90a7cbf7657bc0d75/nltk-3.10.3.tar.gz"
    sha256 "bb9327a461c3811c2fa4900e03840401f2126adfb30c0072827c433bd2444ea4"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/b7/a3/3b5576af9c4b8cb7eef1383d33c48a9431b292983fe4b78cbffb31d0aeeb/openai-3.28.0.tar.gz"
    sha256 "cf0509d32d7bd8eb6a3db02417957cb455212b6629d071826b9ea1f61659e2a4"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "simplejson" do
    url "https://files.pythonhosted.org/packages/2f/f0/ea064bba6c9afda0168ddb834f1c75a93351031e25aee35c046108e7f292/simplejson-4.2.0.tar.gz"
    sha256 "55b121b70a560f4610bd3a355ab2015aca4f39978f6a82353f24d2013fe85861"
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
    url "https://files.pythonhosted.org/packages/71/c3/1b817965ac12dc002d7c9cd7dfffdd7d4fbf9b45763ef2ffe7b86ee94670/soupsieve-2.10.tar.gz"
    sha256 "49e9380d7d2905463583bafe285e818c7366a9ed7b3aee221c1ac79c905d8bc0"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/66/62/167a842aa0429d45f5e797354fd4343a96f6043d67d0513c675c7b8d36e6/tiktoken-0.14.0.tar.gz"
    sha256 "231dec90efcdccf1b565a1416107736f1e09b1a08fe736ef9d6363e626d03874"
  end

  resource "tinysegmenter" do
    url "https://files.pythonhosted.org/packages/17/82/86982e4b6d16e4febc79c2a1d68ee3b707e8a020c5d2bc4af8052d0f136a/tinysegmenter-0.3.tar.gz"
    sha256 "ed1f6d2e806a4758a73be589754384cbadadc7e1a414c81a166fc9adf2d40c6d"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/fd/5d/45ece871390ccc985f821353543165bcf3784fa97d8484fd0ca5f2726612/tldextract-5.4.0.tar.gz"
    sha256 "6c9223212c15c25c0da2bf7313893c14f175cb36b64a0c42da67a468e0c61ee3"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/f0/b4/7830542634bb2d3e62aa3b586a72d5b3b6c91c3168929e7000ef3fed041d/wcwidth-0.9.2.tar.gz"
    sha256 "ae0ef90b90f6af38b54f1fe6d58662ec33b3cb4b8391958a62416d654231727b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output(bin/"gptline", 1)
    assert_match "Set the environment variable OPENAI_KEY or OPENAI_API_KEY to your api secret key", output
  end
end
