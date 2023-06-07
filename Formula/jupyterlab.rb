class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/e0/f6/de750c178fca4d41086470cd09ec2d7fa258cd1f032e064b6cb6e6fbb781/jupyterlab-4.0.1.tar.gz"
  sha256 "4dc3901f7bbfd4704c994b7a893a49955256abf57dba9831f4825e3f3165b8bb"
  license "BSD-3-Clause"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3eb1420ba8ef5efb670b42dde7d797917626ccdf6db42cd556321ae6e468ac3b"
    sha256 cellar: :any,                 arm64_monterey: "3da56bc34ff3e42a3d4b47fdca8639a2cca82161c30d285004782dd2b7e92d47"
    sha256 cellar: :any,                 arm64_big_sur:  "2351f187bbba011c7322473047bdbcb5765b2979b1726f0c437dd6b89ff8b935"
    sha256 cellar: :any,                 ventura:        "6f23d8139697fd16becafba5e4775bbd106c3feca6900a6164d13d5e4bbc11e9"
    sha256 cellar: :any,                 monterey:       "e74992ce63c1c63de2f349a8b3a932ee377001f508f6cfe339713818a7688455"
    sha256 cellar: :any,                 big_sur:        "ea14e61f30ec89c7c8b766eeaf0d5ef2a7457015f6367de786f22c233e31be0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5b4b18e3830cfa6e21bfdbbeeb1ec0dda78aa3d361d81239be1229581b047ed"
  end

  depends_on "hatch" => :build
  depends_on "python-build" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "expect" => :test
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/b3/fefbf7e78ab3b805dec67d698dc18dd505af7a18a8dd08868c9b4fa736b5/anyio-3.7.0.tar.gz"
    sha256 "275d9973793619a5374e1c89a4f4ad3f4b0a5510a2b5b939444bee8f4c4d37ce"
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

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/92/16/be197573adca3d584dbd64d508488e95e36324ea036d751564d2f88d74bf/async-lru-2.0.2.tar.gz"
    sha256 "3b87ec4f2460c52cc7916a0138cc606b584c75d1ef7d661853c95d1d3acb869a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/ba/42/54426ba5d7aeebde9f4aaba9884596eb2fe02b413ad77d62ef0b0422e205/Babel-2.12.1.tar.gz"
    sha256 "cc2d99999cd01d44420ae725a21c9e3711b3aadc7976d6147f622d8581963455"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/7e/e6/d5f220ca638f6a25557a611860482cb6e54b2d97f0332966b1b005742e1f/bleach-6.0.0.tar.gz"
    sha256 "1a1a85c1595e07d8db14c5f09f09e6433502c51c595970edc090551f0db99414"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/d6/1a/9937a10f8fd6d9f0f72fa0ab520cec7e50c534b215f8fd2d28e0f0a7f9a7/comm-0.1.3.tar.gz"
    sha256 "a61efa9daffcfbe66fd643ba966f846a624e4e6d6767eda9cf6e993aadaab93e"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/92/d4/437fa53a5a0e5a04d77e12b7eeac1df003e33834f85ddd4513fe2df31e13/debugpy-1.6.7.zip"
    sha256 "c4c2f0810fa25323abfdfa36cbbbb24e5c3b1a42cb762782de64439c575d67f2"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/a4/e1/cda97fa4447e138f1f0ccfdaf678fa247415f7e9f4942d856fd63c7d863c/fastjsonschema-2.17.1.tar.gz"
    sha256 "f4eeb8a77cef54861dbf7424ac8ce71306f12cbb086c45131bcba2c6a4f726e3"
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
    url "https://files.pythonhosted.org/packages/15/43/d2ebd2657b77cb1e2526a4b444a494298dae1c870a27e85805039e1e3e8a/ipykernel-6.23.1.tar.gz"
    sha256 "1aba0ae8453e15e9bc6b24e497ef6840114afcdb832ae597f32137fa19d42a6f"
  end

  resource "ipython-genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
    sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
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
    url "https://files.pythonhosted.org/packages/95/81/e9d897aa0f8ae679da86fab982900f5e40c37ebd81b04a3e88f26a201517/jupyter_client-8.2.0.tar.gz"
    sha256 "9fe233834edd0e6c0aa5f05ca2ab4bdea1842bfd2d8a932878212fc5301ddaf0"
  end

  resource "jupyter-console" do
    url "https://files.pythonhosted.org/packages/bd/2d/e2fd31e2fc41c14e2bcb6c976ab732597e907523f6b2420305f9fc7fdbdb/jupyter_console-6.6.3.tar.gz"
    sha256 "566a4bf31c87adbfadf22cdf846e3069b59a71ed5da71d6ba4d8aaad14a53539"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/9a/d3/b80e7179e9615f5a7f055edc55eb665fa2534f11a4599349db3bab6fdeb5/jupyter_core-5.3.0.tar.gz"
    sha256 "6db75be0c83edbf1b7c9f91ec266a9a24ef945da630f3120e1a0046dc13713fc"
  end

  resource "jupyter-events" do
    url "https://files.pythonhosted.org/packages/d0/b0/7afcd1d66834f43d08ec47c861a5540d7ad57eab47605ccd83429c147755/jupyter_events-0.6.3.tar.gz"
    sha256 "9a6e9995f75d1b7146b436ea24d696ce3a35bfa8bfe45e0c33c334c79464d0b3"
  end

  resource "jupyter-lsp" do
    url "https://files.pythonhosted.org/packages/01/f9/85c8361175208e279f63c3896db14b547d821c9cb8a52675e51a7bdb336f/jupyter-lsp-2.2.0.tar.gz"
    sha256 "8ebbcb533adb41e5d635eb8fe82956b0aafbf0fd443b6c4bfa906edeeb8635a1"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/ef/59/ba1556d910d6b608d203ca033ed4eef4489415f6afeb4e27fc7d7d56d257/jupyter_server-2.6.0.tar.gz"
    sha256 "ae4af349f030ed08dd78cb7ac1a03a92d886000380c9ea6283f3c542a81f4b06"
  end

  resource "jupyter-server-terminals" do
    url "https://files.pythonhosted.org/packages/54/e1/6bc19392e6957356f085b8d7ec33d6d0d721e646b7576c1c6758dd264c64/jupyter_server_terminals-0.4.4.tar.gz"
    sha256 "57ab779797c25a7ba68e97bcfb5d7740f2b5e8a83b5e8102b10438041a7eac5d"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/69/8e/8ae01f052013ee578b297499d16fcfafb892927d8e41c1a0054d2f99a569/jupyterlab_pygments-0.2.2.tar.gz"
    sha256 "7405d7fde60819d905a9fa8ce89e4cd830e318cdad22a0030f7a901da705585d"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/61/21/030537ac23f669ef80b0cec92a1330a25d17f55b086e18003ab06e3602da/jupyterlab_server-2.22.1.tar.gz"
    sha256 "dfaaf898af84b9d01ae9583b813f378b96ee90c3a66f24c5186ea5d1bbdb2089"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/fb/6b/d8013058fcdb0088b4130164fc961e15c50d30302f60a349c16bdfda9770/mistune-2.0.5.tar.gz"
    sha256 "0246113cb2492db875c6be56974a7c893333bf26cd92891c85f63151cee09d34"
  end

  resource "nbclassic" do
    url "https://files.pythonhosted.org/packages/8b/11/6e6084bad2b2f8faa787bd5f72fd1171c741801a03872b518965d7653ba5/nbclassic-1.0.0.tar.gz"
    sha256 "0ae11eb2319455d805596bf320336cda9554b41d99ab9a3c31bf8180bffa30e3"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/4c/09/ca367efae271cef775345147c792f6c870d3a6ed5c410795c9754e710248/nbclient-0.8.0.tar.gz"
    sha256 "f9b179cd4b2d7bca965f900a2ebf0db4a12ebff2f36a711cb66861e4ae158e55"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/0f/24/a7f5d67535ebd13276a1113d1a20572053c5a9182c29651420b957d1226c/nbconvert-7.4.0.tar.gz"
    sha256 "51b6c77b507b177b73f6729dba15676e42c4e92bcb00edc8cc982ee72e7d89d7"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/08/b7/8b964e977438037b57de31d312d67046e215295899107576e3708b0ea223/nbformat-5.8.0.tar.gz"
    sha256 "46dac64c781f1c34dfd8acba16547024110348f9fc7eab0f31981c2a3dc48d1f"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/35/76/64c51c1cbe704ad79ef6ec82f232d1893b9365f2ff194111787dc91b004f/nest_asyncio-1.5.6.tar.gz"
    sha256 "d267cc1ff794403f7df692964d1d2a3fa9418ffea2a3f6859a439ff482fef290"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/52/1e/b555b6e33c962a605e2e85b6014f609d3e1c6a5ff48f7c2480376b430d96/notebook-6.5.4.tar.gz"
    sha256 "517209568bd47261e2def27a140e97d49070602eea0d226a696f42a7f16c9a4e"
    # This is to avoid a circular dependency, where `notebook` depends on `nbclassic`,
    # which transitively depends on `notebook`.
    patch :DATA
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/ea/10/6c6c7adc0d61e72cfc4055d0671bbd12bdc6ffea86892e903bd2398b9019/notebook_shim-0.2.3.tar.gz"
    sha256 "f69388ac283ae008cd506dda10d0288b09a017d822d5e8c7129a152cbd3ce7e9"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/f6/39/e2e3c2c7eba7793a01b5f592c3c7fd6b27da53d75de81430407ef18befb7/overrides-7.3.1.tar.gz"
    sha256 "8b97c6c1e1681b78cbc9424b138d880f0803c2254c5ebaabdde57bb6c62093f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/62/42/c32476b110a2d25277be875b82b5669f2cdda7897c165bd22b78f366b3cb/pandocfilters-1.5.0.tar.gz"
    sha256 "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/9c/0e/ae9ef1049d4b5697e79250c4b2e72796e4152228e67733389868229c92bb/platformdirs-3.5.1.tar.gz"
    sha256 "412dae91f52a6f84830f39a8078cecd0e866cb72294a5c66808e74d5e88d251f"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/0e/01/bda72c3b5d4a0df411bceb88c4993d413dd9b7d3b3b68ab19171a09e7db1/prometheus_client-0.17.0.tar.gz"
    sha256 "9c3b26f1535945e85b8934fb374678d263137b78ef85f305b1156c7c881cd11b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
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
    url "https://files.pythonhosted.org/packages/4f/da/95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13/python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/64/9c/2b2614b0b86ff703b3a33ea5e044923bd7d100adc8c829d579a9b71ea9e7/pyzmq-25.1.0.tar.gz"
    sha256 "80c41023465d36280e801564a69cbfce8ae85ff79b080e1913f6e90481fb8957"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3986-validator" do
    url "https://files.pythonhosted.org/packages/da/88/f270de456dd7d11dcc808abfa291ecdd3f45ff44e3b549ffa01b126464d0/rfc3986_validator-0.1.1.tar.gz"
    sha256 "3d44bde7921b3b9ec3ae4e3adca370438eccebc676456449b145d533b240d055"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/4a/d2/d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551/Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
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
    url "https://files.pythonhosted.org/packages/30/f0/6e5d85d422a26fd696a1f2613ab8119495c1ebb8f49e29f428d15daf79cc/tornado-6.3.2.tar.gz"
    sha256 "4b927c4f19b71e627b13f3db2324e4ae660527143f9e1f2e2fb404f3a187e2ba"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/40/55/9318f307d3b0a70ce5812fd2b9da286b0f58a2ffbdba5fa269d0c052ae89/uri_template-1.2.0.tar.gz"
    sha256 "934e4d09d108b70eb8a24410af8615294d09d279ce0e7cbcdaef1bd21f932b06"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/a1/fb/f95560c6a5d4469d9c49e24cf1b5d4d21ffab5608251c6020a965fb7791c/webcolors-1.13.tar.gz"
    sha256 "c225b674c83fa923be93d235330ce0300373d02885cef23238813b0d5668304a"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/3f/f2/2624e12ef854ee667d92ac5dc7815932095e0852e5ff2b2bf57feda8a11b/websocket-client-1.5.2.tar.gz"
    sha256 "c7d67c13b928645f259d9b847ab5b57fd2d127213ca41ebd880de1f553b7c23b"
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
      resources.to_set(&:name) - preinstall - linked_hatch - linked_setuptools - unlinked_hatch
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
