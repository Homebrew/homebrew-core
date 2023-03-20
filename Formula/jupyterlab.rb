class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/97/a0/c3561fdedca7d71dad0a09f34a7d1f3e196c91009690323cd4a844f904ab/jupyterlab-3.6.1.tar.gz"
  sha256 "aee98c174180e98a30470297d10b959e8e64f2288970c0de65f0a6d2b4807034"
  license "BSD-3-Clause"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e31fc2a460721ec0828d47ae920aa2d64499c37fefe8a6e9a67b33f61c78398"
    sha256 cellar: :any,                 arm64_monterey: "91bb06d74610ba5a792946bcc6db8c28ad3c7a74be3f866360cbfedb6de4abc4"
    sha256 cellar: :any,                 arm64_big_sur:  "69ee9ef49320c19a023744c4331782e5675ab4cf7dfca89b862ce7a45e00f69c"
    sha256 cellar: :any,                 ventura:        "51a88ac38f07f0ad6c5a462fb57d0998f0fa1f7e6244d1f3ee61caaa0c0df0bc"
    sha256 cellar: :any,                 monterey:       "40fa15f3553cdd06e583c25d304f3636378b72c4ef902fe7d72db49391b7f949"
    sha256 cellar: :any,                 big_sur:        "253604eed3776949f4133863fa3fe2b208751825de380231faba628d838f9027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "525fe94b0b2c708286ee2d40c6dd8e4bdfca70b7ebefca6fde43cc310ed27890"
  end

  depends_on "hatch" => :build
  depends_on "python-build" => :build
  depends_on "rust" => :build
  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "expect" => :test
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/86/26/6e5060a159a6131c430e8a01ec8327405a19a449a506224b394e36f2ebc9/aiofiles-22.1.0.tar.gz"
    sha256 "9107f1ca0b2a5553987a94a3c9959fe5b491fdf731389aa5b7b1bd0733e32de6"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/bd/b1/9c9c5847461c8eed8fa36e72541c53054987993227e1782d4f92e902cbe6/aiosqlite-0.18.0.tar.gz"
    sha256 "faa843ef5fb08bafe9a9b3859012d3d9d6f77ce3637899de20606b7fc39aa213"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/8b/94/6928d4345f2bc1beecbff03325cad43d320717f51ab74ab5a571324f4f5a/anyio-3.6.2.tar.gz"
    sha256 "25ea0d673ae30af41a0c442f81cf3b38c7e79fdc7b60335a4c14e05eb0947421"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/3f/18/20bb5b6bf55e55d14558b57afc3d4476349ab90e0c43e60f27a7c2187289/argon2-cffi-21.3.0.tar.gz"
    sha256 "d384164d944190a7dd7ef22c6aa3ff197da12962bd04b17f64d4e93d934dba5b"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/b9/e9/184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66e/argon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "Babel" do
    url "https://files.pythonhosted.org/packages/ff/80/45b42203ecc32c8de281f52e3ec81cb5e4ef16127e9e8543089d8b1649fb/Babel-2.11.0.tar.gz"
    sha256 "5ef4b3226b0180dedded4229651c8b0e1a3a6a2837d45a073272f313e4cf97f6"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/75/f8/de84282681c5a8307f3fff67b64641627b2652752d49d9222b77400d02b8/beautifulsoup4-4.11.2.tar.gz"
    sha256 "bc4bdda6717de5a2987436fb8d72f45dc90dd856bdfd512a1314ce90349a0106"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/7e/e6/d5f220ca638f6a25557a611860482cb6e54b2d97f0332966b1b005742e1f/bleach-6.0.0.tar.gz"
    sha256 "1a1a85c1595e07d8db14c5f09f09e6433502c51c595970edc090551f0db99414"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/60/5b/0e55c73beb88043811601050c87e871bd1f6cab78c869dc077fa5d0a5b5b/comm-0.1.2.tar.gz"
    sha256 "3e2f5826578e683999b93716285b3b1f344f157bf75fa9ce0a797564e742f062"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/d5/b4/dee6aae40c3ff7a4c3b27f1611f64ab8570a07add5f82321414d9ced4fec/debugpy-1.6.6.zip"
    sha256 "b9c2130e1c632540fbf9c2c88341493797ddf58016e7cba02e311de9b0a96b67"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/7a/62/6df03bacda3544b5872d0b30f79c599ab84fc598858c77a77e1587d61ba3/fastjsonschema-2.16.2.tar.gz"
    sha256 "01e366f25d9047816fe3d288cbfc3e10541daf0af2044763f3d0ade42476da18"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/4f/68/d18cf6d4130ed5719a478aa976ac4affcf8c7f687844b55b67b4be9ade76/ipykernel-6.21.1.tar.gz"
    sha256 "a0f8eece39cab1ee352c9b59ec67bbe44d8299f8238e4c16ff7f4cf0052d3378"
  end

  resource "ipython_genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/da/8b/26535688697b6129c0ccec7806162db0d01c9bc8b8994ab1e87c32ef9648/json5-0.9.11.tar.gz"
    sha256 "4f1e196acc55b83985a51318489f345963c7ba84aa37607e49073066c562e99b"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/a0/6c/c52556b957a0f904e7c45585444feef206fe5cb1ff656303a1d6d922a53b/jsonpointer-2.3.tar.gz"
    sha256 "97cba51526c829282218feb99dab1b1e6bdf8efd1c43dc9d57be093c0d69c99a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/d8/41/fddcf62081f88e06be196091beb41c07fe85562199d7439dfd3bf8c57601/jupyter_client-8.0.2.tar.gz"
    sha256 "47ac9f586dbcff4d79387ec264faf0fdeb5f14845fa7345fd7d1e378f8096011"
  end

  resource "jupyter-console" do
    url "https://files.pythonhosted.org/packages/1b/2f/acb5851aa3ed730f8cde5ec9eb0c0d9681681123f32c3b82d1536df1e937/jupyter_console-6.4.4.tar.gz"
    sha256 "172f5335e31d600df61613a97b7f0352f2c8250bbd1092ef2d658f77249f89fb"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/aa/81/f1700beb330c715e3ecf72c6713849f18ed653d49fb2f621705cae2d3b56/jupyter_core-5.2.0.tar.gz"
    sha256 "1407cdb4c79ee467696c04b76633fc1884015fa109323365a6372c8e890cc83f"
  end

  resource "jupyter-events" do
    url "https://files.pythonhosted.org/packages/30/28/aa50f16c06d2c4c945766e0453ba67fc0f0c89560a0809edda1a33c4aae0/jupyter_events-0.5.0.tar.gz"
    sha256 "e27ffdd6138699d47d42cb65ae6d79334ff7c0d923694381c991ce56a140f2cd"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/c5/e1/2583e892d8f65e54ab20f8658fdefa1267c3d0f657fa81843744e423123d/jupyter_server-2.2.1.tar.gz"
    sha256 "5afb8a0cdfee37d02d69bdf470ae9cbb1dee5d4788f9bc6cc8e54bd8c83fb096"
  end

  resource "jupyter-server-fileid" do
    url "https://files.pythonhosted.org/packages/89/12/608d9101504d5e49bef34a4921f5e1e6f087cd8ca200c7399ee25b14565e/jupyter_server_fileid-0.6.0.tar.gz"
    sha256 "a12209bdef4f2f9d57051b7556a089299fb9f26b501f643946854220c955be14"
  end

  resource "jupyter-server-terminals" do
    url "https://files.pythonhosted.org/packages/54/e1/6bc19392e6957356f085b8d7ec33d6d0d721e646b7576c1c6758dd264c64/jupyter_server_terminals-0.4.4.tar.gz"
    sha256 "57ab779797c25a7ba68e97bcfb5d7740f2b5e8a83b5e8102b10438041a7eac5d"
  end

  resource "jupyter-server-ydoc" do
    url "https://files.pythonhosted.org/packages/6a/c6/9e84ecdfaa538b6f69ba73157e5755657be80d56dceffb7fb3118601b1cd/jupyter_server_ydoc-0.6.1.tar.gz"
    sha256 "ab10864708c81fa41ab9f2ed3626b54ff6926eaf14545d1d439714978dad6e9f"
  end

  resource "jupyter-ydoc" do
    url "https://files.pythonhosted.org/packages/d9/6d/33b93c10cc77c73f3a118479ae37662387bbff3e37af09bf02684effa138/jupyter_ydoc-0.2.2.tar.gz"
    sha256 "3163bd4745eedd46d4bba6df52ab26be3c5c44c3a8aaf247635062486ea8f84f"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/69/8e/8ae01f052013ee578b297499d16fcfafb892927d8e41c1a0054d2f99a569/jupyterlab_pygments-0.2.2.tar.gz"
    sha256 "7405d7fde60819d905a9fa8ce89e4cd830e318cdad22a0030f7a901da705585d"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/bb/d3/a2e98458e1e1d2af2dd6e9204b8be3b93225ab2a644770869f16dfcb3e6d/jupyterlab_server-2.19.0.tar.gz"
    sha256 "9aec21a2183bbedd9f91a86628355449575f1862d88b28ad5f905019d31e6c21"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/cd/9b/0f98334812f548a5ee4399b76e33752a74fc7bb976f5efb34d962f03d585/mistune-2.0.4.tar.gz"
    sha256 "9ee0a66053e2267aba772c71e06891fa8f1af6d4b01d5e84e267b4570d4d9808"
  end

  resource "nbclassic" do
    url "https://files.pythonhosted.org/packages/ba/a1/d6e92354cb3f198bd113f8d9945d3b55b22b9405fa9a145582b0d37f8fba/nbclassic-0.5.1.tar.gz"
    sha256 "8e8ffce7582bb7a4baf11fa86a3d88b184e8e7df78eed4ead69f15aa4fc0e323"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/19/ab/3508807c537cca591f85bb28bb914b9b64fd9f4dfa70e0847cf514c5fbd0/nbclient-0.7.2.tar.gz"
    sha256 "884a3f4a8c4fc24bb9302f263e0af47d97f0d01fe11ba714171b320c8ac09547"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/be/6d/3f909f6a31dadb19829523f9a676d5d623d613bf21a45143bc00be0fad67/nbconvert-7.2.9.tar.gz"
    sha256 "a42c3ac137c64f70cbe4d763111bf358641ea53b37a01a5c202ed86374af5234"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/ce/42/fae44dfe70960c488e5b9b53c617dedd1c7932aff1962c59b2a923e82bb8/nbformat-5.7.3.tar.gz"
    sha256 "4b021fca24d3a747bf4e626694033d792d594705829e5e35b14ee3369f9f6477"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/35/76/64c51c1cbe704ad79ef6ec82f232d1893b9365f2ff194111787dc91b004f/nest_asyncio-1.5.6.tar.gz"
    sha256 "d267cc1ff794403f7df692964d1d2a3fa9418ffea2a3f6859a439ff482fef290"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/41/15/a4285abb25c87dec3002cd7eab88320ef21448effdd3714840695aafab12/notebook-6.5.2.tar.gz"
    sha256 "c1897e5317e225fc78b45549a6ab4b668e4c996fd03a04e938fe5e7af2bfffd0"
    # This is to avoid a circular dependency, where `notebook` depends on `nbclassic`,
    # which transitively depends on `notebook`.
    patch :DATA
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/98/29/3b1be2556ebb55053ffc2d2cac7bf2d611827a2cf23e1f34acc1c811d23f/notebook_shim-0.2.2.tar.gz"
    sha256 "090e0baf9a5582ff59b607af523ca2db68ff216da0c69956b62cab2ef4fc9c3f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/62/42/c32476b110a2d25277be875b82b5669f2cdda7897c165bd22b78f366b3cb/pandocfilters-1.5.0.tar.gz"
    sha256 "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/4d/198b7e6c6c2b152f4f9f4cdf975d3590e33e63f1920f2d89af7f0390e6db/platformdirs-2.6.2.tar.gz"
    sha256 "e1fea1fe471b9ff8332e229df3cb7de4f53eeea4998d3b6bfff542115e998bd2"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/d0/55/9e34c73e1e490b105b4cd13d08497b1f7cb086a260e4161b7b7c2928b196/prometheus_client-0.16.0.tar.gz"
    sha256 "a03e35b359f14dd1630898543e2120addfdeacd1a6069c1367ae90fd93ad3f48"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/0a/c9/3d58b02da0966cd3067ebf99f454bfa01b18d83cfa69b5fb09ddccf94066/python-json-logger-2.0.4.tar.gz"
    sha256 "764d762175f99fcc4630bd4853b09632acb60a6224acb27ce08cd70f0b1b81bd"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/03/3e/dc5c793b62c60d0ca0b7e58f1fdd84d5aaa9f8df23e7589b39cc9ce20a03/pytz-2022.7.1.tar.gz"
    sha256 "01a0681c4b9684a28304615eba55d1ab31ae00bf68ec157ec3708a8182dbbcd0"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/cf/89/9dbc5bc589a06e94d493b551177a0ebbe70f08b5ebdd49dddf212df869ff/pyzmq-25.0.0.tar.gz"
    sha256 "f330a1a2c7f89fd4b0aa4dcb7bf50243bf1c8da9a2f1efc31daf57a2046b31f2"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3986-validator" do
    url "https://files.pythonhosted.org/packages/da/88/f270de456dd7d11dcc808abfa291ecdd3f45ff44e3b549ffa01b126464d0/rfc3986_validator-0.1.1.tar.gz"
    sha256 "3d44bde7921b3b9ec3ae4e3adca370438eccebc676456449b145d533b240d055"
  end

  resource "Send2Trash" do
    url "https://files.pythonhosted.org/packages/49/2c/d990b8d5a7378dde856f5a82e36ed9d6061b5f2d00f39dc4317acd9538b4/Send2Trash-1.8.0.tar.gz"
    sha256 "d2c24762fd3759860a0aff155e45871447ea58d2be6bdd39b5c8f966a0c99c2d"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/55/be/748034192602b9fd69ba94544c1675ff18b039ed8f346ad783478e31144f/terminado-0.17.1.tar.gz"
    sha256 "6ccbbcd3a4f8a25a5ec04991f39a0b8db52dfcd487ea0e578d977e6752380333"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/f3/9e/225a41452f2d9418d89be5e32cf824c84fe1e639d350d6e8d49db5b7f73a/tornado-6.2.tar.gz"
    sha256 "9b630419bde84ec666bfd7ea0a4cb2a8a651c2d5cccdbdd1972a0c859dfc3c13"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/40/55/9318f307d3b0a70ce5812fd2b9da286b0f58a2ffbdba5fa269d0c052ae89/uri_template-1.2.0.tar.gz"
    sha256 "934e4d09d108b70eb8a24410af8615294d09d279ce0e7cbcdaef1bd21f932b06"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/5f/f5/004dabd8f86abe0e770df4bcde8baf658709d3ebdd4d8fa835f6680012bb/webcolors-1.12.tar.gz"
    sha256 "16d043d3a08fd6a1b1b7e3e9e62640d09790dce80d2bdd4792a175b35fe794a9"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/02/cd/1adc1276f1e8f6a929783f4c2992ec7a4934a81f8ced3d4a87191cc168c2/websocket-client-1.5.0.tar.gz"
    sha256 "561ca949e5bbb5d33409a37235db55c279235c78ee407802f1d2314fff8a8536"
  end

  resource "y-py" do
    url "https://files.pythonhosted.org/packages/69/ec/e5195a58ff869be7baeef07c7143196945ed33aba5ece3f8c21e99d59950/y_py-0.5.5.tar.gz"
    sha256 "f222bab71d8d3df9a40b2e5ab3a767d734c6ce11998e9a30a02fb83ab3e090b3"
  end

  resource "ypy-websocket" do
    url "https://files.pythonhosted.org/packages/5b/12/8937dcca49af5ec50346f28ebc90112c458595f75e46f31e3fdcca29bda8/ypy_websocket-0.8.2.tar.gz"
    sha256 "491b2cc4271df4dde9be83017c15f4532b597dc43148472eb20c5aeb838a5b46"
  end

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    site_packages = Language::Python.site_packages(python3)
    %w[ipython].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end

    preinstall = %w[jupyterlab-pygments nbclassic]
    linked_hatch = %w[
      jupyter-core jupyter-client jupyter-events jupyter-server jupyter-server-terminals
      nbformat ipykernel nbconvert
    ]
    linked_setuptools = %w[jupyter-console]
    unlinked_hatch = %w[jupyterlab-server]
    unlinked_setuptools = (
      resources.map(&:name).to_set - preinstall - linked_hatch - linked_setuptools - unlinked_hatch
    )

    pybuild = Formula["python-build"].opt_bin/"pyproject-build"
    hatch = Formula["hatch"].opt_bin/"hatch"

    # The "preinstall" dependencies require `jupyterlab` to build. Since Homebrew doesn't
    # allow circular dependencies, we locally build wheels for these dependencies
    # using the pre-built PyPI wheels for `jupyterlab` and its dependencies.
    preinstall.each do |r|
      resource(r).stage do
        system pybuild, "--wheel"
        venv.pip_install Dir["dist/*.whl"].first
      end
    end

    # install remaining packages into virtualenv and link specified packages
    unlinked_setuptools.each do |r|
      venv.pip_install resource(r)
    end
    unlinked_hatch.each do |r|
      resource(r).stage do
        system hatch, "build", "-t", "wheel"
        venv.pip_install Dir["dist/*.whl"].first
      end
    end
    linked_setuptools.each do |r|
      venv.pip_install_and_link resource(r)
    end
    linked_hatch.each do |r|
      resource(r).stage do
        system hatch, "build", "-t", "wheel"
        venv.pip_install_and_link Dir["dist/*.whl"].first
      end
    end

    venv.pip_install_and_link buildpath

    # remove bundled kernel
    (libexec/"share/jupyter/kernels").rmtree

    # install completion
    resource("jupyter-core").stage do
      bash_completion.install "examples/jupyter-completion.bash" => "jupyter"
      zsh_completion.install "examples/completions-zsh" => "_jupyter"
    end
  end

  def caveats
    <<~EOS
      Additional kernels can be installed into the shared jupyter directory
        #{etc}/jupyter
    EOS
  end

  test do
    system bin/"jupyter-console --help"
    assert_match python3, shell_output("#{bin}/jupyter kernelspec list")

    (testpath/"console.exp").write <<~EOS
      spawn #{bin}/jupyter-console
      expect "In "
      send "exit\r"
    EOS
    assert_match "Jupyter console", shell_output("expect -f console.exp")

    (testpath/"notebook.exp").write <<~EOS
      spawn #{bin}/jupyter notebook --no-browser
      expect "NotebookApp"
    EOS
    assert_match "NotebookApp", shell_output("expect -f notebook.exp")

    (testpath/"nbconvert.ipynb").write <<~EOS
      {
        "cells": []
      }
    EOS
    system bin/"jupyter-nbconvert", "nbconvert.ipynb", "--to", "html"
    assert_predicate testpath/"nbconvert.html", :exist?, "Failed to export HTML"

    assert_match "-F _jupyter",
      shell_output("bash -c \"source #{bash_completion}/jupyter && complete -p jupyter\"")

    # Ensure that jupyter can load the jupyter lab package.
    assert_match(/^jupyterlab *: #{version}$/,
      shell_output(bin/"jupyter --version"))

    # Ensure that jupyter-lab binary was installed by pip.
    assert_equal version.to_s,
      shell_output(bin/"jupyter-lab --version").strip

    port = free_port
    fork { exec "#{bin}/jupyter-lab", "-y", "--port=#{port}", "--no-browser", "--ip=127.0.0.1", "--LabApp.token=''" }
    sleep 10
    assert_match "<title>JupyterLab</title>",
      shell_output("curl --silent --fail http://localhost:#{port}/lab")
  end
end

__END__
--- a/pyproject.toml	2023-01-27 12:04:48
+++ b/pyproject.toml	2023-01-27 12:05:01
@@ -1,5 +1,5 @@
 [build-system]
-requires=["jupyter_packaging~=0.9", "nbclassic>=0.4.0"]
+requires=["jupyter_packaging~=0.9"]
 build-backend = "setuptools.build_meta"

 [tool.check-manifest]
