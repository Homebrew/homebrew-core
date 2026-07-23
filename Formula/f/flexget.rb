class Flexget < Formula
  include Language::Python::Virtualenv

  desc "Multipurpose automation tool for content"
  homepage "https://www.flexget.com"
  url "https://files.pythonhosted.org/packages/d0/7d/207764635235b9818628f03ecb5fa0aa34451cf12efd34cca169f2ab225e/flexget-3.19.30.tar.gz"
  sha256 "de2c4d43d0818abb6d4eee287844c6b35fb25a21cf6a6ee3684d3e8110b3b074"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc8026c736dd37f297caa78a7d1119dc25ce5c6007670351fdb95054b7811533"
    sha256 cellar: :any, arm64_sequoia: "dfb0d4c425dd5b973cf64e7187428b4d8399cd53abac8f60ec8098baa3996317"
    sha256 cellar: :any, arm64_sonoma:  "6b5f975d5ee729efd21963e339a1ca6ebd7295e1188404f868c6a121099dd3f6"
    sha256 cellar: :any, sonoma:        "928421b8fe8757aa57f5d77b8fd41223b01d19d3fcd391523be395ec667981d7"
    sha256 cellar: :any, arm64_linux:   "59ec04a32154fc7697d296acc4240b57fb875932eb94891ea6e3671298c6b85f"
    sha256 cellar: :any, x86_64_linux:  "78ef16793de7a5da2e2ae3a378f1ab48b2c9e1d7e786898fe791644440f49382"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages package_name:     "flexget[transmission]",
                exclude_packages: %w[certifi rpds-py]

  resource "aniso8601" do
    url "https://files.pythonhosted.org/packages/8b/8d/52179c4e3f1978d3d9a285f98c706642522750ef343e9738286130423730/aniso8601-10.0.1.tar.gz"
    sha256 "25488f8663dd1528ae1f54f94ac1ea51ae25b4d531539b8bc707fed184d16845"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/57/ba/046ceea27344560984e26a590f90bc7f4a75b06701f653222458922b558c/annotated_doc-0.0.4.tar.gz"
    sha256 "fbcda96e87e9c92ad167c2e53839e57503ecfda18804ea28102353485033faa4"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/8c/6b/eeff360196bb20b312c9e762a820fd1b2c6d809466c755ef57863478e454/apscheduler-3.11.3.tar.gz"
    sha256 "cd2fcc9330039a81a5893472ad49facf23a6d5604cbe1d918c835c6de7834d5a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/f7/16/c92ca344d646e71a43b8bb353f0a6490d7f6e06210f8554c8f874e454285/brotli-1.2.0.tar.gz"
    sha256 "e310f77e41941c13340a95976fe66a8a95b01e783d430eeaf7a2f87e0a57dd0a"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/bd/2a/23f34ec9d04624958e137efdc394888716353190e75f25dd22c7a2c7a8aa/charset_normalizer-3.4.9.tar.gz"
    sha256 "673611bbd43f0810bec0b0f028ddeaaa501190339cac411f347ac76917c3ae7b"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/68/e4/5c2020b60a55aca8d79ed55b62ad1cd7fc47ea44ad6b584e83f5f1bf58b0/cheroot-11.1.2.tar.gz"
    sha256 "bfb70c49663f63b0440f2b54dbc6b0d1650e56dfe4e2641f59b2c6f727b44aca"
  end

  resource "cherrypy" do
    url "https://files.pythonhosted.org/packages/93/e8/2f7ef142d1962d08a8885c4c9942212abecad6a80ccdd1620fd1f5c993fd/cherrypy-18.10.0.tar.gz"
    sha256 "6c70e78ee11300e8b21c0767c542ae6b102a49cac5cfd4e3e313d7bb907c5891"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "feedparser" do
    url "https://files.pythonhosted.org/packages/dc/79/db7edb5e77d6dfbc54d7d9df72828be4318275b2e580549ff45a962f6461/feedparser-6.0.12.tar.gz"
    sha256 "64f76ce90ae3e8ef5d1ede0f8d3b50ce26bcce71dd8ae5e82b1cd2d4a5f94228"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/26/00/35d85dcce6c57fdc871f3867d465d780f302a175ea360f62533f12b27e2b/flask-3.1.3.tar.gz"
    sha256 "0ef0e52b8a9cd932855379197dd8f94047b359ca0a78695144304cb45f87c9eb"
  end

  resource "flask-compress" do
    url "https://files.pythonhosted.org/packages/c2/de/2ae0118051b38ab53437328074a696f3ee7d61e15bf7454b78a3088e5bc3/flask_compress-1.24.tar.gz"
    sha256 "14097cefe59ecb3e466d52a6aeb62f34f125a9f7dadf1f33a53e430ce4a50f31"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/47/03/4e464a50860f9adf08b5c1d3479cb8ea1f12af2aa69535c7042c6e628135/flask_cors-6.0.5.tar.gz"
    sha256 "30c5031552cd59f620ac0c8211dac45b345d3b2df310e7721879e4f46ef9c601"
  end

  resource "flask-login" do
    url "https://files.pythonhosted.org/packages/c3/6e/2f4e13e373bb49e68c02c51ceadd22d172715a06716f9299d9df01b6ddb2/Flask-Login-0.6.3.tar.gz"
    sha256 "5e23d14a607ef12806c699590b89d0f0e0d67baeec599d75947bf9c147330333"
  end

  resource "flask-restx" do
    url "https://files.pythonhosted.org/packages/43/89/9b9ca58cbb8e9ec46f4a510ba93878e0c88d518bf03c350e3b1b7ad85cbe/flask-restx-1.3.2.tar.gz"
    sha256 "0ae13d77e7d7e4dce513970cfa9db45364aef210e99022de26d2b73eb4dbced5"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/e2/f1/fbbfef6af0bad0548f09bc28948ea3c275b4edb19e17fc5ca9900a6a634d/greenlet-3.5.3.tar.gz"
    sha256 "a61efc018fd3eb317eeca31aba90ee9e7f26f22884a79b6c6ec715bf71bb62f1"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d0/07/5a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cd/guessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/html5lib/html5lib-python/pull/589
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
    end

    # Python 3.14 with setuptools 81+ compatibility (`pkg_resources` removal)
    # upstream pr ref, https://github.com/html5lib/html5lib-python/pull/592
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/1dbc19cd6db72cb919885827bc4883423e0cb647.patch?full_index=1"
      sha256 "5951b823f353dd70806ad6e163ab8f46899496c1e8bb53970c99abe8d1df1a78"
    end
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/e4/06/b56dfa750b44e86157093bc8fca0ab81dccbf5260510de4eaf1cb69b5b99/importlib_resources-7.1.0.tar.gz"
    sha256 "0722d4c6212489c530f2a145a34c0a7a3b4721bc96a15fada5930e2a0b760708"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jaraco-collections" do
    url "https://files.pythonhosted.org/packages/fa/d2/751000cf702676dbb78f97728f4d52b029e817e2b3c94088dfe5c70ff46d/jaraco_collections-5.2.1.tar.gz"
    sha256 "dab81970bad6f0ab53b20745f1b01da37926e4c0fcd425046aa45e0d8efa18ed"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jaraco-text" do
    url "https://files.pythonhosted.org/packages/be/8c/c74f1107719400477289d99cd2c0b5b7809a45f60acecfb5ef961c3533c8/jaraco_text-4.3.0.tar.gz"
    sha256 "ddd5eb6259d0701e08cb642c8d6b63bcc73947d03df9239ea67bbef911b3e4e1"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/3a/05/a1dae3dffd1116099471c643b8924f5aa6524411dc6c63fdae648c4f1aca/loguru-0.7.3.tar.gz"
    sha256 "19480589e77d47b8d85b2c827ad95d49bf31b0dcde16593892eb51dd18706eb6"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/de/1d/f4da6f02cdffe04d6362210b807146a26044c88d839208aec273bb0d9184/more_itertools-11.1.0.tar.gz"
    sha256 "48e8f4d9e7e5878571ecf6f2b4e57634f93cd474cc8cfbd2376f2d11b396e30d"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/cb/72/9a51afa0a822b09e286c4cb827ed7b00bc818dac7bd11a5f161e493a217d/pendulum-3.2.0.tar.gz"
    sha256 "e80feda2d10fa3ff8b1526715f7d33dcb7e08494b3088f2c8a3ac92d4a4331ce"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/0c/6a/1d1b143420fcdfc8902f2db6b7d1d2325211461c5f2a43c849de7afad688/plumbum-2.0.1.tar.gz"
    sha256 "61623f856dcb09eb20dcd5aa708dfb3cd04b6f4ab10224d39303b163bb1c4c61"
  end

  resource "portend" do
    url "https://files.pythonhosted.org/packages/b7/57/be90f42996fc4f57d5742ef2c95f7f7bb8e9183af2cc11bff8e7df338888/portend-3.2.1.tar.gz"
    sha256 "aa9d40ab1f9e14bdb7d401f42210df35d017c9b97991baeb18568cedfb8c6489"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pynzb" do
    url "https://files.pythonhosted.org/packages/b1/90/b71ca66e2fee3f46281b3ecc853abe407a5ecd0cb4898af5bab48af63590/pynzb-0.1.0.tar.gz"
    sha256 "0735b3889a1174bbb65418ee503629d3f5e4a63f04b16f46ffba18253ec3ef17"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyrss2gen" do
    url "https://files.pythonhosted.org/packages/6d/01/fd610d5fc86f7dbdbefc4baa8f7fe15a2e5484244c41dcf363ca7e89f60c/PyRSS2Gen-1.1.tar.gz"
    sha256 "7960aed7e998d2482bf58716c316509786f596426f879b05f8d84e98b82c6ee7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/f2/06/24c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296/rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rpyc" do
    url "https://files.pythonhosted.org/packages/8b/e7/1c17410673b634f4658bb5d2232d0c4507432a97508b2c6708e59481644a/rpyc-6.0.2.tar.gz"
    sha256 "8e780a6a71b842128a80a337c64adfb6f919014e069951832161c9efc630c93b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/34/26/f5d29e25ffdb535afef2d35cdb55b325298f96debd670da4c325e08d70f4/setuptools-83.0.0.tar.gz"
    sha256 "025bccbbf0fa05b6192bc64ae1e7b16e001fd6d6d4d5de03c97b1c1ade523bef"
  end

  resource "sgmllib3k" do
    url "https://files.pythonhosted.org/packages/9e/bd/3704a8c3e0942d711c1299ebf7b9091930adae6675d7c8f476a7ce48653c/sgmllib3k-1.0.0.tar.gz"
    sha256 "7868fb1c8bfa764c1ac563d3cf369c381d1325d36124933a726f29fcdaa812e9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/80/f1/93422647dd7e461f23d254e6b2bfa687a85b53aeb4903fcdbb74474d4584/soupsieve-2.9.tar.gz"
    sha256 "acee8417325c5653e1377dc31eccad59eb82cbc65942afe6174c53b3aaad63fc"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/02/f1/a7a892f18d4d224e6b26f706531eafccc41e37594d37d304786969ee13cb/sqlalchemy-2.0.51.tar.gz"
    sha256 "804dccd8a4a6242c4e30ad961e540e18a588f6527202f2d6791b01845d59fdc9"
  end

  resource "tempora" do
    url "https://files.pythonhosted.org/packages/fb/91/452a0eeae4a8745ded74cfba94e96a66f85fe0edf1d0697f031b0204ac07/tempora-5.12.0.tar.gz"
    sha256 "b49b78cc7ec0b252bfbd74cef0187121b18e4f5a0c57e3b9c3d8fc15090af3b4"
  end

  resource "transmission-rpc" do
    url "https://files.pythonhosted.org/packages/68/b8/dc4debf525c3bb8a676f4fd0ab8534845e3b067c78a81ad05ac39014d849/transmission_rpc-7.0.11.tar.gz"
    sha256 "5872322e60b42e368bc9c4724773aea4593113cb19bd2da589f0ffcdabe57963"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/37/78/fda3361b56efc27944f24225f6ecd13d96d6fcfe37bd0eb34e2f4c63f9fc/typer-0.27.0.tar.gz"
    sha256 "629bd12ea5d13a17148125d9a264f949eb171fb3f120f9b04d85873cab054fa5"
  end

  resource "typer-slim" do
    url "https://files.pythonhosted.org/packages/a7/a7/e6aecc4b4eb59598829a3b5076a93aff291b4fdaa2ded25efc4e1f4d219c/typer_slim-0.24.0.tar.gz"
    sha256 "f0ed36127183f52ae6ced2ecb2521789995992c521a46083bfcdbb652d22ad34"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/f6/cc/6253133b5bb138fc3306cebfbda2c520f545d36b5be2c7255cc528bb45d6/typing_extensions-4.16.0.tar.gz"
    sha256 "dc983d19a509c94dba722ee6abd33940f7c05a89e243c47e907eb4db6f1a43e5"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/92/ff/5a28bdfd8c3ebec42564ac7d0e54ca3db65044a9314a97f9564fa7a1e926/tzdata-2026.3.tar.gz"
    sha256 "4a1518b8993086a7982523e071643f3c0e5f213e75b21318e78bcabfff9d1415"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/81/5b/879b2f932adfa7a053c360d50bc896c977fa6426109185f7c12ebdd0cb9d/tzlocal-5.4.4.tar.gz"
    sha256 "8dbb8660838688a7b6ba4fed31d18dedf842afb4d47ca050d6d891c2c15f3be4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/dd/b2/381be8cfdee792dd117872481b6e378f85c957dd7c5bca38897b08f765fd/werkzeug-3.1.8.tar.gz"
    sha256 "9bad61a4268dac112f1c5cd4630a56ede601b6ed420300677a869083d70a4c44"
  end

  resource "zc-lockfile" do
    url "https://files.pythonhosted.org/packages/10/9a/2fef89272d98b799e4daa50201c5582ec76bdd4e92a1a7e3deb74c52b7fa/zc_lockfile-4.0.tar.gz"
    sha256 "d3ab0f53974296a806db3219b9191ba0e6d5cbbd1daa2e0d17208cb9b29d2102"
  end

  resource "zxcvbn" do
    url "https://files.pythonhosted.org/packages/ae/40/9366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57aca/zxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
  end

  def install
    ENV["BUNDLE_WEBUI"] = "true"
    # `pendulum` builds a PyO3 extension through maturin.
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?
    virtualenv_install_with_resources
  end

  service do
    run [opt_bin/"flexget", "--cron", "daemon", "start"]
    keep_alive true
  end

  test do
    (testpath/"config.yml").write <<~YAML
      variables:
        media_folder: ~/Downloads
      web_server: yes
      schedules:
        - tasks: [task-1]
          interval:
            minutes: 30
      tasks:
        task-1:
          rss: https://example.com/rss
          transmission: yes
    YAML
    system bin/"flexget", "-c", testpath/"config.yml", "check"
  end
end
