class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/97/53/984b9704a8ae0bf20e52a2495c5e95301e82b7b33a5903e47792257855e4/jupyterlab-3.5.2.tar.gz"
  sha256 "10ac094215ffb872ddffbe2982bf1c039a79fecc326e191e7cc5efd84f331dad"
  license "BSD-3-Clause"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ef65d66d25c30bf53e3f985ca3a7b7255c4108617b7434db12d745efe51a25fd"
    sha256 cellar: :any,                 arm64_monterey: "a2b5567a0b9e52dbf9d831eacef29239aee3413d7ffd9283f612298e2870434e"
    sha256 cellar: :any,                 arm64_big_sur:  "90ee222a6dd1fa54a315cf00bd5eb606ff82d86db9a7dc8fbbfbaa916dce300a"
    sha256 cellar: :any,                 ventura:        "c188c10ad42309481202268c3fc20f5f75dd32db78007c221fc4351b9fd1a07f"
    sha256 cellar: :any,                 monterey:       "c0db45836ee1c296c1fc414793647f2b7c5330f0f79f6e52ea211171ddbdc75e"
    sha256 cellar: :any,                 big_sur:        "fbaeee46942d4c0d22733926874a0b91bbf7de3c7631b1340ea4406fe428c13a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00737c799921ba3b0f07e4d8429e572a1640e5b209b66e5a71f177c222d4a280"
  end

  depends_on "hatch" => :build
  depends_on "python-build" => :build
  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "expect" => :test
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

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
    url "https://files.pythonhosted.org/packages/e8/b0/cd2b968000577ec5ce6c741a54d846dfa402372369b8b6861720aa9ecea7/beautifulsoup4-4.11.1.tar.gz"
    sha256 "ad9aa55b65ef2808eb405f46cf74df7fcb7044d5cbc26487f96eb2ef2e436693"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/c2/5d/d5d45a38163ede3342d6ac1ca01b5d387329daadf534a25718f9a9ba818c/bleach-5.0.1.tar.gz"
    sha256 "0d03255c47eb9bd2f26aa9bb7f2107732e7e8fe195ca2f64709fcf3b0a4a085c"
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
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/60/5b/0e55c73beb88043811601050c87e871bd1f6cab78c869dc077fa5d0a5b5b/comm-0.1.2.tar.gz"
    sha256 "3e2f5826578e683999b93716285b3b1f344f157bf75fa9ce0a797564e742f062"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/9b/d5/1d8718de85ff87a88db3c1a7eb1f0870de50dee858fd1e13659fa0af7e9f/debugpy-1.6.4.zip"
    sha256 "d5ab9bd3f4e7faf3765fd52c7c43c074104ab1e109621dc73219099ed1a5399d"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/ea/8d/a7121ffe5f402dc015277d2d31eb82d2187334503a011c18f2e78ecbb9b2/entrypoints-0.4.tar.gz"
    sha256 "b706eddaa9218a19ebcd67b56818f05bb27589b1ca9e8d797b74affad4ccacd4"
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
    url "https://files.pythonhosted.org/packages/bf/e6/d29f4b827cf98a28cffc4b44af784531450f67dc81962fb6c3d84b3d7848/ipykernel-6.20.0.tar.gz"
    sha256 "7dfafaec645300710c41479c0b0bdc13a9ea6639bee6e3ad042757674e9a9a29"
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
    url "https://files.pythonhosted.org/packages/47/12/611bf15000c1fc54af909565aed1ad045e5ae1890d8c56cbfe5ceaf52446/json5-0.9.10.tar.gz"
    sha256 "ad9f048c5b5a4c3802524474ce40a622fae789860a86f10cc4f7e5f9cf9b46ab"
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
    url "https://files.pythonhosted.org/packages/76/e5/5213bf5edc3250c5c19135e3f04e3bc6573d2f694fab07ac9f6d75a582cf/jupyter_client-7.4.8.tar.gz"
    sha256 "109a3c33b62a9cf65aa8325850a0999a795fac155d9de4f7555aef5f310ee35a"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/20/00/2f3c7b30ca75b36588a3d4e203b909bd15e5c70fd449bf1e2b88fabd55ef/jupyter_core-5.1.1.tar.gz"
    sha256 "f342d29eb6edb06f8dffa69adea987b3a9ee2b6702338a8cb6911516ea0b432d"
  end

  resource "jupyter-events" do
    url "https://files.pythonhosted.org/packages/30/28/aa50f16c06d2c4c945766e0453ba67fc0f0c89560a0809edda1a33c4aae0/jupyter_events-0.5.0.tar.gz"
    sha256 "e27ffdd6138699d47d42cb65ae6d79334ff7c0d923694381c991ce56a140f2cd"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/e6/4b/98e26a96b240f944b4ebecae60aae7a3ecd9aae47451559f1a00837bf83e/jupyter_server-2.0.6.tar.gz"
    sha256 "8dd75992e90b7ca556794a1ed5cca51263c697abc6d0df561af574aa1c0a033f"
  end

  resource "jupyter-server-terminals" do
    url "https://files.pythonhosted.org/packages/7b/91/5d21682a41496a4150d120eea74b2b4c6b3dc2401d3aebe1e5cbd87e1889/jupyter_server_terminals-0.4.3.tar.gz"
    sha256 "8421438d95a1f1f6994c48dd5dc10ad167ea7c196972bb5d1d7a9da1e30fde02"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/69/8e/8ae01f052013ee578b297499d16fcfafb892927d8e41c1a0054d2f99a569/jupyterlab_pygments-0.2.2.tar.gz"
    sha256 "7405d7fde60819d905a9fa8ce89e4cd830e318cdad22a0030f7a901da705585d"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/ee/bf/fed69cb7c0a111c7574bea728281ea6853147b0d03af3f67f329b97b6809/jupyterlab_server-2.17.0.tar.gz"
    sha256 "a5b6923e2a9ea299f98de5b50cde90722d74ef8f0713a75cbcbfbfd3f41ad058"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/cd/9b/0f98334812f548a5ee4399b76e33752a74fc7bb976f5efb34d962f03d585/mistune-2.0.4.tar.gz"
    sha256 "9ee0a66053e2267aba772c71e06891fa8f1af6d4b01d5e84e267b4570d4d9808"
  end

  resource "nbclassic" do
    url "https://files.pythonhosted.org/packages/0d/52/2fd9c7a81763d7e20cc28757d42ae25d8f0fcab2913092b2e239b906892a/nbclassic-0.4.8.tar.gz"
    sha256 "c74d8a500f8e058d46b576a41e5bc640711e1032cf7541dde5f73ea49497e283"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/19/ab/3508807c537cca591f85bb28bb914b9b64fd9f4dfa70e0847cf514c5fbd0/nbclient-0.7.2.tar.gz"
    sha256 "884a3f4a8c4fc24bb9302f263e0af47d97f0d01fe11ba714171b320c8ac09547"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/7b/8a/16238549782af065488c9e7e16c0ac6f0553ed7f84337054587202b03138/nbconvert-7.2.7.tar.gz"
    sha256 "8b727b0503bf4e0ff3907c8bea030d3fc4015fbee8669ac6ac2a5a6668b49d5e"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/a0/82/0f26f741d33997407c42bed9bc4675ca678d4138333aa85a8b2282ef553f/nbformat-5.7.1.tar.gz"
    sha256 "3810a0130453ed031970521d20989b8a592f3c2e73283a8280ae34ae1f75b3f8"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/35/76/64c51c1cbe704ad79ef6ec82f232d1893b9365f2ff194111787dc91b004f/nest_asyncio-1.5.6.tar.gz"
    sha256 "d267cc1ff794403f7df692964d1d2a3fa9418ffea2a3f6859a439ff482fef290"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/41/15/a4285abb25c87dec3002cd7eab88320ef21448effdd3714840695aafab12/notebook-6.5.2.tar.gz"
    sha256 "c1897e5317e225fc78b45549a6ab4b668e4c996fd03a04e938fe5e7af2bfffd0"
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/98/29/3b1be2556ebb55053ffc2d2cac7bf2d611827a2cf23e1f34acc1c811d23f/notebook_shim-0.2.2.tar.gz"
    sha256 "090e0baf9a5582ff59b607af523ca2db68ff216da0c69956b62cab2ef4fc9c3f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
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
    url "https://files.pythonhosted.org/packages/ae/ae/04b27ea04f67f91f10b1379d8fd6729c41ac0bcefbb0af603850b3fa32e0/prometheus_client-0.15.0.tar.gz"
    sha256 "be26aa452490cfcf6da953f9436e95a9f2b4d578ca80094b4458930e5f584ab1"
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
    url "https://files.pythonhosted.org/packages/6d/37/54f2d7c147e42dc85ffbc6910862bb4f141fb3fc14d9a88efaa1a76c7df2/pytz-2022.7.tar.gz"
    sha256 "7ccfae7b4b2c067464a6733c6261673fdb8fd1be905460396b97a073e9fa683a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/46/0d/b06cf99a64d4187632f4ac9ddf6be99cd35de06fe72d75140496a8e0eef5/pyzmq-24.0.1.tar.gz"
    sha256 "216f5d7dbb67166759e59b0479bca82b8acf9bed6015b526b8eb10143fb08e77"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
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

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
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
    url "https://files.pythonhosted.org/packages/c2/51/32da03cf19d17d46cce5c731967bf58de9bd71db3a379932f53b094deda4/urllib3-1.26.13.tar.gz"
    sha256 "c083dd0dce68dbfbe1129d5271cb90f9447dea7d52097c6e0126120c521ddea8"
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
    url "https://files.pythonhosted.org/packages/75/af/1d13b93e7a21aca7f8ab8645fcfcfad21fc39716dc9dce5dc2a97f73ff78/websocket-client-1.4.2.tar.gz"
    sha256 "d6e8f90ca8e2dd4e8027c4561adeb9456b54044312dba655e7cae652ceb9ae59"
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

    # gather packages to link based on options
    linked_hatch = %w[jupyter-core jupyter-client nbformat ipykernel nbconvert]
    linked_setuptools = %w[jupyter-console notebook]
    unlinked_hatch = %w[jupyterlab-server]
    unlinked_setuptools = resources.map(&:name).to_set - linked_hatch - linked_setuptools - unlinked_hatch

    # `jupyterlab-pygments` requires `jupyterlab` to build. Since Homebrew doesn't
    # allow circular dependencies, we locally build a `jupyterlab-pygments` wheel
    # using the pre-built PyPI wheels for `jupyterlab` and its dependencies.
    unlinked_setuptools -= ["jupyterlab-pygments"]
    resource("jupyterlab-pygments").stage do
      pybuild = Formula["python-build"].opt_bin/"pyproject-build"
      system pybuild, "--wheel"
      venv.pip_install Dir["dist/jupyterlab_pygments-*.whl"].first
    end

    hatch = Formula["hatch"].opt_bin/"hatch"

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

    # remove non-native binaries
    if OS.mac? && Hardware::CPU.arm?
      site_packages = libexec/Language::Python.site_packages(python3)
      (site_packages/"debugpy/_vendored/pydevd/pydevd_attach_to_process/attach_x86_64.dylib").unlink
    end

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
      spawn #{bin}/jupyter-notebook --no-browser
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
