class Flexget < Formula
  include Language::Python::Virtualenv

  desc "Multipurpose automation tool for content"
  homepage "https://www.flexget.com"
  url "https://files.pythonhosted.org/packages/ce/f8/c6eafbc06469bb43ca559f01fa981a5bd585e23ae8d01c0d5c2127fea4fa/flexget-3.18.9.tar.gz"
  sha256 "52369022a19f0cddb39a93fb5d560af76931e425b822f751591217cec2a77b63"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76f0c7f347a1ab2bde8334aab05e3669f7048f6f349af7e110c890bc45a1f6f0"
    sha256 cellar: :any,                 arm64_sequoia: "df7f6025d6265a7ab00ce4f4e14e92eedcc6a9c416d5aad7e9612e37d1288b77"
    sha256 cellar: :any,                 arm64_sonoma:  "77fa037e8296e7423a38aeda095082d703f8af60301c430931a9c8da9f6447cc"
    sha256 cellar: :any,                 sonoma:        "bf4d40ee8d98cdfb7d5f398849292140791b5f4dd83601e60aa480143abf29c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42a609779d1d909e9f23d2a0bd8be5e1527947c0277053c5085b007b7a24d62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f139bc7acd6d0007b62cd910a5a27683d2dd9e99205d4126c463701816888593"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"
  depends_on "zstd"

  resource "aniso8601" do
    url "https://files.pythonhosted.org/packages/8b/8d/52179c4e3f1978d3d9a285f98c706642522750ef343e9738286130423730/aniso8601-10.0.1.tar.gz"
    sha256 "25488f8663dd1528ae1f54f94ac1ea51ae25b4d531539b8bc707fed184d16845"
  end

  resource "apscheduler" do
    url "https://files.pythonhosted.org/packages/4e/00/6d6814ddc19be2df62c8c898c4df6b5b1914f3bd024b780028caa392d186/apscheduler-3.11.0.tar.gz"
    sha256 "4c622d250b0955a65d5d0eb91c33e6d43fd879834bf541e0a18661ae60460133"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/5a/b0/1367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24/attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "autocommand" do
    url "https://files.pythonhosted.org/packages/5b/18/774bddb96bc0dc0a2b8ac2d2a0e686639744378883da0fc3b96a54192d7a/autocommand-2.2.2.tar.gz"
    sha256 "878de9423c5596491167225c2a455043c3130fb5b7286ac83443d45e74955f34"
  end

  resource "babelfish" do
    url "https://files.pythonhosted.org/packages/c5/8f/17ff889327f8a1c36a28418e686727dabc06c080ed49c95e3e2424a77aa6/babelfish-0.6.1.tar.gz"
    sha256 "decb67a4660888d48480ab6998309837174158d0f1aa63bebb1c2e11aab97aab"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/85/2e/3e5079847e653b1f6dc647aa24549d68c6addb4c595cc0d902d1b19308ad/beautifulsoup4-4.13.5.tar.gz"
    sha256 "5e70131382930e7c3de33450a2f54a63d5e4b19386eab43a5b34d594268f3695"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/63/e2/f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1/cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "cherrypy" do
    url "https://files.pythonhosted.org/packages/93/e8/2f7ef142d1962d08a8885c4c9942212abecad6a80ccdd1620fd1f5c993fd/cherrypy-18.10.0.tar.gz"
    sha256 "6c70e78ee11300e8b21c0767c542ae6b102a49cac5cfd4e3e313d7bb907c5891"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/60/6c/8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbc/click-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "feedparser" do
    url "https://files.pythonhosted.org/packages/dc/79/db7edb5e77d6dfbc54d7d9df72828be4318275b2e580549ff45a962f6461/feedparser-6.0.12.tar.gz"
    sha256 "64f76ce90ae3e8ef5d1ede0f8d3b50ce26bcce71dd8ae5e82b1cd2d4a5f94228"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/dc/6d/cfe3c0fcc5e477df242b98bfe186a4c34357b4847e87ecaef04507332dab/flask-3.1.2.tar.gz"
    sha256 "bf656c15c80190ed628ad08cdfd3aaa35beb087855e2f494910aa3774cc4fd87"
  end

  resource "flask-compress" do
    url "https://files.pythonhosted.org/packages/33/77/7d3c1b071e29c09bd796a84f95442f3c75f24a1f2a9f2c86c857579ab4ec/flask_compress-1.18.tar.gz"
    sha256 "fdbae1bd8e334dfdc8b19549829163987c796fafea7fa1c63f9a4add23c8413a"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/76/37/bcfa6c7d5eec777c4c7cf45ce6b27631cebe5230caf88d85eadd63edd37a/flask_cors-6.0.1.tar.gz"
    sha256 "d81bcb31f07b0985be7f48406247e9243aced229b7747219160a0559edd678db"
  end

  resource "flask-login" do
    url "https://files.pythonhosted.org/packages/c3/6e/2f4e13e373bb49e68c02c51ceadd22d172715a06716f9299d9df01b6ddb2/Flask-Login-0.6.3.tar.gz"
    sha256 "5e23d14a607ef12806c699590b89d0f0e0d67baeec599d75947bf9c147330333"
  end

  resource "flask-restx" do
    url "https://files.pythonhosted.org/packages/45/4c/2e7d84e2b406b47cf3bf730f521efe474977b404ee170d8ea68dc37e6733/flask-restx-1.3.0.tar.gz"
    sha256 "4f3d3fa7b6191fcc715b18c201a12cd875176f92ba4acc61626ccfd571ee1728"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/03/b8/704d753a5a45507a7aab61f18db9509302ed3d0a27ac7e0359ec2905b1a6/greenlet-3.2.4.tar.gz"
    sha256 "0dca0d95ff849f9a364385f36ab49f50065d76964944638be9691e1832e9f86d"
  end

  resource "guessit" do
    url "https://files.pythonhosted.org/packages/d0/07/5a88020bfe2591af2ffc75841200b2c17ff52510779510346af5477e64cd/guessit-3.8.0.tar.gz"
    sha256 "6619fcbbf9a0510ec8c2c33744c4251cad0507b1d573d05c875de17edc5edbed"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
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
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jaraco-text" do
    url "https://files.pythonhosted.org/packages/4f/00/1b4dbbc5c6dcb87a4278cc229b2b560484bf231bba7922686c5139e5f934/jaraco_text-4.0.0.tar.gz"
    sha256 "5b71fecea69ab6f939d4c906c04fee1eda76500d1641117df6ec45b865f10db0"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
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
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pendulum" do
    url "https://files.pythonhosted.org/packages/23/7c/009c12b86c7cc6c403aec80f8a4308598dfc5995e5c523a5491faaa3952e/pendulum-3.1.0.tar.gz"
    sha256 "66f96303560f41d097bee7d2dc98ffca716fbb3a832c4b3062034c2d45865015"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/f0/5d/49ba324ad4ae5b1a4caefafbce7a1648540129344481f2ed4ef6bb68d451/plumbum-1.9.0.tar.gz"
    sha256 "e640062b72642c3873bd5bdc3effed75ba4d3c70ef6b6a7b907357a84d909219"
  end

  resource "portend" do
    url "https://files.pythonhosted.org/packages/b7/57/be90f42996fc4f57d5742ef2c95f7f7bb8e9183af2cc11bff8e7df338888/portend-3.2.1.tar.gz"
    sha256 "aa9d40ab1f9e14bdb7d401f42210df35d017c9b97991baeb18568cedfb8c6489"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pynzb" do
    url "https://files.pythonhosted.org/packages/b1/90/b71ca66e2fee3f46281b3ecc853abe407a5ecd0cb4898af5bab48af63590/pynzb-0.1.0.tar.gz"
    sha256 "0735b3889a1174bbb65418ee503629d3f5e4a63f04b16f46ffba18253ec3ef17"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/98/c9/b4594e6a81371dfa9eb7a2c110ad682acf985d96115ae8b25a1d63b4bf3b/pyparsing-3.2.4.tar.gz"
    sha256 "fff89494f45559d0f2ce46613b419f632bbb6afbdaed49696d322bcf98a58e99"
  end

  resource "pyrss2gen" do
    url "https://files.pythonhosted.org/packages/6d/01/fd610d5fc86f7dbdbefc4baa8f7fe15a2e5484244c41dcf363ca7e89f60c/PyRSS2Gen-1.1.tar.gz"
    sha256 "7960aed7e998d2482bf58716c316509786f596426f879b05f8d84e98b82c6ee7"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/f8/bf/abbd3cdfb8fbc7fb3d4d38d320f2441b1e7cbe29be4f23797b4a2b5d8aac/pytz-2025.2.tar.gz"
    sha256 "360b9e3dbb49a209c21ad61809c7fb453643e048b38924c765813546746e81c3"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "pyzstd" do
    url "https://files.pythonhosted.org/packages/8f/a2/54d860ccbd07e3c67e4d0321d1c29fc7963ac82cf801a078debfc4ef7c15/pyzstd-0.17.0.tar.gz"
    sha256 "d84271f8baa66c419204c1dd115a4dec8b266f8a2921da21b81764fa208c1db6"
  end

  resource "rebulk" do
    url "https://files.pythonhosted.org/packages/f2/06/24c69f8d707c9eefc1108a64e079da56b5f351e3f59ed76e8f04b9f3e296/rebulk-3.2.0.tar.gz"
    sha256 "0d30bf80fca00fa9c697185ac475daac9bde5f646ce3338c9ff5d5dc1ebdfebc"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/fe/75/af448d8e52bf1d8fa6a9d089ca6c07ff4453d86c65c145d0a300bb073b9b/rich-14.1.0.tar.gz"
    sha256 "e497a48b844b0320d45007cdebfeaeed8db2a4f4bcf49f15e455cfc4af11eaa8"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "rpyc" do
    url "https://files.pythonhosted.org/packages/8b/e7/1c17410673b634f4658bb5d2232d0c4507432a97508b2c6708e59481644a/rpyc-6.0.2.tar.gz"
    sha256 "8e780a6a71b842128a80a337c64adfb6f919014e069951832161c9efc630c93b"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "sgmllib3k" do
    url "https://files.pythonhosted.org/packages/9e/bd/3704a8c3e0942d711c1299ebf7b9091930adae6675d7c8f476a7ce48653c/sgmllib3k-1.0.0.tar.gz"
    sha256 "7868fb1c8bfa764c1ac563d3cf369c381d1325d36124933a726f29fcdaa812e9"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/d7/bc/d59b5d97d27229b0e009bd9098cd81af71c2fa5549c580a0a67b9bed0496/sqlalchemy-2.0.43.tar.gz"
    sha256 "788bfcef6787a7764169cfe9859fe425bf44559619e1d9f56f5bddf2ebf6f417"
  end

  resource "tempora" do
    url "https://files.pythonhosted.org/packages/24/64/a255efe5edd367d12b770b3514194efdc1c97e5ed6ce6e8105d834750dfc/tempora-5.8.1.tar.gz"
    sha256 "abb5d9ec790cc5e4f9431778029ba3e3d9ba9bd50cb306dad824824b2b362dcd"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/95/32/1a225d6164441be760d75c2c42e2780dc0873fe382da3e98a2e1e48361e5/tzdata-2025.2.tar.gz"
    sha256 "b60a638fcc0daffadf82fe0f57e53d06bdec2f36c4df66280ae79bce6bd6f2b9"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
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
    venv = virtualenv_install_with_resources without: "pyzstd"
    # We need to build separately to link to our `zstd`.
    resource("pyzstd").stage do
      system_zstd = "--config-settings=--build-option=--dynamic-link-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", system_zstd,
                                           *std_pip_args(prefix: false, build_isolation: true), "."
    end
  end

  test do
    (testpath/"config.yml").write <<~END
      tasks:
        task-1:
          rss: https://example.com/rss
    END
    system bin/"flexget", "-c", "#{testpath}/config.yml", "check"
  end
end
