class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/62/83/bfb3f5a4dca3546bd6e7f424c1537a359945c65aa2bb33170d0c31b7c17b/jupyterlab-4.0.10.tar.gz"
  sha256 "46177eb8ede70dc73be922ac99f8ef943bdc2dfbc6a31b353c4bde848a35dee1"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2c298ebaf9c2ceac2ba18bd3699ddf572f9ae3536bd7fb2f6e57dd8093a4adaf"
    sha256 cellar: :any,                 arm64_ventura:  "7e98a85f6614eaf826df8c65c671cb9a27ac34de608fb66dc5830d82cb1616ad"
    sha256 cellar: :any,                 arm64_monterey: "0e6976b91fcfd8da3dad744241a3eb3de27f9d8a8fe0e88fe20719a003b51fd6"
    sha256 cellar: :any,                 sonoma:         "c77d4dde475e9fc9f817ce396b4050260d8d086f8f900e306a93265d449b02b7"
    sha256 cellar: :any,                 ventura:        "933efc94cf94834ff75b083aa9858dd04c8408ddf648451096f375ca414cb919"
    sha256 cellar: :any,                 monterey:       "769c1fd333d1292456763fed99edddec8234d381b65112d104b9b9a4a7bdd7a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dcd8929e9159665ebd6644321a8fd10a24b46218c96e24feeb8b5c62313d0a57"
  end

  depends_on "python-hatchling" => :build
  depends_on "rust" => :build # for rpds-py
  depends_on "cffi"
  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-dateutil"
  depends_on "python-jinja"
  depends_on "python-lsp-server"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-psutil"
  depends_on "python-requests"
  depends_on "python@3.12"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "expect" => :test
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/2d/b8/7333d87d5f03247215d86a86362fd3e324111788c6cdd8d2e6196a6ba833/anyio-4.2.0.tar.gz"
    sha256 "e1875bb4b4e2de1669f4bc7869b6d3f54231cdced71605e6e64c9be77e3be50f"
  end

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/6a/cd/355842c0db33192ac0fc822e2dcae835669ef317fe56c795fb55fcddb26f/appnope-0.1.3.tar.gz"
    sha256 "02bd91c4de869fbb1e1c50aafc4098827a7a54ab2f39d9dcba6c9547ed920e24"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/31/fa/57ec2c6d16ecd2ba0cf15f3c7d1c3c2e7b5fcb83555ff56d7ab10888ec8f/argon2_cffi-23.1.0.tar.gz"
    sha256 "879c3e79a2729ce768ebb7d36d4609e3a78a4ca2ec3a9f12286ca057e3d0db08"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/b9/e9/184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66e/argon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/2e/00/0f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173/arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/80/e2/2b4651eff771f6fd900d233e175ddc5e2be502c7eb62c0c42f975c6d36cd/async-lru-2.0.4.tar.gz"
    sha256 "b8a59a5df60805ff63220b2a0c5b5393da5521b113cd5465a44eb037d81a5627"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/e2/80/cfbe44a9085d112e983282ee7ca4c00429bc4d1ce86ee5f4e60259ddff7f/Babel-2.14.0.tar.gz"
    sha256 "6919867db036398ba21eb5c7a0f6b28ab8cbc3ae7a73a44ebe34ae74a4e7d363"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/6d/10/77f32b088738f40d4f5be801daa5f327879eadd4562f36a2b5ab975ae571/bleach-6.1.0.tar.gz"
    sha256 "0a31f1837963c41d46bbf1331b8778e1308ea0791db03cc4e7357b97cf42a8fe"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/e7/1d/e55f4664491a5e490ff48f7f6d7555771a46541d226e13348d847ae271c1/comm-0.2.0.tar.gz"
    sha256 "a517ea2ca28931c7007a7a99c562a0fa5883cfb48963140cf642c41c948498be"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/61/fe/0486b90b9ac0d9afced236fdfe6e54c2f45b7ef09225210090f23dc6e48a/debugpy-1.8.0.zip"
    sha256 "12af2c55b419521e33d5fb21bd022df0b5eb267c3e178f1d374a63a2a6bdccd0"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/ba/7f/cedf77ace50aa60c566deaca9066750f06e1fcf6ad24f254d255bb976dd6/fastjsonschema-2.19.1.tar.gz"
    sha256 "e3126a94bdc4623d3de4485f8d468a12f02a67921315ddc87836d6e456dc789d"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "hatch-jupyter-builder" do
    url "https://files.pythonhosted.org/packages/b1/b2/3c304707d4d3c30b2c87f1b8f8b2eb4a682662fea13bd5ab8f16c4c0eb0b/hatch_jupyter_builder-0.8.3.tar.gz"
    sha256 "0dbd14a8aef6636764f88a8fd1fcc9a91921e5c50356e6aab251782f264ae960"
  end

  resource "hatch-nodejs-version" do
    url "https://files.pythonhosted.org/packages/af/b6/c9406cfa9edf740c6b3de6173408a159228eac0cee80eead4a5b9cc88848/hatch_nodejs_version-0.3.2.tar.gz"
    sha256 "8a7828d817b71e50bbbbb01c9bfc0b329657b7900c56846489b9c958de15b54c"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/a1/12/ec23e176d7931a305b76631c0079885fb32424db190b6790cb25ded3f337/ipykernel-6.28.0.tar.gz"
    sha256 "69c11403d26de69df02225916f916b37ea4b9af417da0a8c827f84328d88e5f3"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
    sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/a8/74/77bf12d3dd32b764692a71d4200f03429c41eee2e8a9225d344d91c03aff/jsonschema-4.20.0.tar.gz"
    sha256 "4f614fd46d8d61258610998997743ec5492a648b33cf478c1ddc23ed4598a5fa"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/f8/b9/cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4b/jsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/71/04/4418fca04fd65a26771113a0a46220a1a54a6d6bcc6fae4ad6b69eb27dd5/jupyter_client-8.6.0.tar.gz"
    sha256 "0642244bb83b4764ae60d07e010e15f0e2d275ec4e918a8f7b80fbbef3ca60c7"
  end

  resource "jupyter-console" do
    url "https://files.pythonhosted.org/packages/bd/2d/e2fd31e2fc41c14e2bcb6c976ab732597e907523f6b2420305f9fc7fdbdb/jupyter_console-6.6.3.tar.gz"
    sha256 "566a4bf31c87adbfadf22cdf846e3069b59a71ed5da71d6ba4d8aaad14a53539"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/41/20/017205ca6981f818cea15a44d04972b4b78892a7d27f52a8b6b5f201e44d/jupyter_core-5.5.1.tar.gz"
    sha256 "1553311a97ccd12936037f36b9ab4d6ae8ceea6ad2d5c90d94a909e752178e40"
  end

  resource "jupyter-events" do
    url "https://files.pythonhosted.org/packages/55/36/c65c02b5cedd8f326453dd958f299bfb030609f016d4354217a95d5190e1/jupyter_events-0.9.0.tar.gz"
    sha256 "81ad2e4bc710881ec274d31c6c50669d71bbaa5dd9d01e600b56faa85700d399"
  end

  resource "jupyter-lsp" do
    url "https://files.pythonhosted.org/packages/20/91/bcb8ddcb41e4708ed627ae998200f81360fb10d856188686a7594c2f774e/jupyter-lsp-2.2.1.tar.gz"
    sha256 "b17fab6d70fe83c8896b0cff59237640038247c196056b43684a0902b6a9e0fb"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/02/d8/f592907461f55d0827749601926a046d4c9b5f5abdc8978c747018621de2/jupyter_server-2.12.1.tar.gz"
    sha256 "dc77b7dcc5fc0547acba2b2844f01798008667201eea27c6319ff9257d700a6d"
  end

  resource "jupyter-server-terminals" do
    url "https://files.pythonhosted.org/packages/69/c1/ba084effb487a65c3746ee0c085c1f8a3909d851edba2055f58270a9ce0a/jupyter_server_terminals-0.5.1.tar.gz"
    sha256 "16d3be9cf48be6a1f943f3a6c93c033be259cf4779184c66421709cf63dccfea"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/90/51/9187be60d989df97f5f0aba133fa54e7300f17616e065d1ada7d7646b6d6/jupyterlab_pygments-0.3.0.tar.gz"
    sha256 "721aca4d9029252b11cfa9d185e5b5af4d54772bb8072f9b7036f4170054d35d"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/32/d5/f59cc812a142cc1e8bd751a8f07d7c2b974f89c72fca2ac43febab874ee9/jupyterlab_server-2.25.2.tar.gz"
    sha256 "bd0ec7a99ebcedc8bcff939ef86e52c378e44c2707e053fcd81d046ce979ee63"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/ef/c8/f0173fe3bf85fd891aee2e7bcd8207dfe26c2c683d727c5a6cc3aec7b628/mistune-3.0.2.tar.gz"
    sha256 "fc7f93ded930c92394ef2cb6f04a8aabab4117a91449e72dcc8dfa646a508be8"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/00/bb/5c11c78351430b2aec4cb9e79b4df8c1815e7eb6c38848ff19e8eba317fa/nbclient-0.9.0.tar.gz"
    sha256 "4b28c207877cf33ef3a9838cdc7a54c5ceff981194a82eac59d558f05487295e"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/8b/aa/7563eca73ade359f69605f38012d35024b257afa1db1c1c76b20259753d1/nbconvert-7.13.1.tar.gz"
    sha256 "2dc8267dbdfeedce2dcd34c9e3f1b51af18f43cb105549d1c5a18189ec23ba85"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/54/d8/31dceef56952da6ea2c43405a83c9759a22a86cb530197988cfa8599b178/nbformat-5.9.2.tar.gz"
    sha256 "5f98b5ba1997dff175e77e0c17d5c10a96eaed2cbd1de3533d1fc35d5e111192"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/93/fd/4c3fa3f390d00f4c85d1102988d3fda588e8d45216998715bfa2f5caf411/nest_asyncio-1.5.8.tar.gz"
    sha256 "25aa2ca0d2a5b5531956b9e273b45cf664cae2b145101d73b86b199978d48fdb"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/87/29/0a3afe94904f4b6dad32c2e03865b827eaca18d6997d76f372306a85e0a3/notebook-7.0.6.tar.gz"
    sha256 "ec6113b06529019f7f287819af06c97a2baf7a95ac21a8f6e32192898e9f9a58"
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/ea/10/6c6c7adc0d61e72cfc4055d0671bbd12bdc6ffea86892e903bd2398b9019/notebook_shim-0.2.3.tar.gz"
    sha256 "f69388ac283ae008cd506dda10d0288b09a017d822d5e8c7129a152cbd3ce7e9"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/4d/27/30c865a1e62f1913a0730e667e94459ca038392b6f44d69ef7a585690337/overrides-7.4.0.tar.gz"
    sha256 "9502a3cca51f4fac40b5feca985b6703a5c1f6ad815588a7ca9e285b9dca6757"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/62/42/c32476b110a2d25277be875b82b5669f2cdda7897c165bd22b78f366b3cb/pandocfilters-1.5.0.tar.gz"
    sha256 "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/d1/7feaaacb1a3faeba96c06e6c5091f90695cc0f94b7e8e1a3a3fe2b33ff9a/platformdirs-4.1.0.tar.gz"
    sha256 "906d548203468492d432bcb294d4bc2fff751bf84971fbb2c10918cc206ee420"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/00/02/a4e12fe70cd57137be321785c9d6a046c7f537d5888226a01d083b4c88f6/prometheus_client-0.19.0.tar.gz"
    sha256 "4585b0d1223148c27a225b10dbec5ae9bc4c81a99a3fa80774fa6209935324e1"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/4f/da/95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13/python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/3a/33/1a3683fc9a4bd64d8ccc0290da75c8f042184a1a49c146d28398414d3341/pyzmq-25.1.2.tar.gz"
    sha256 "93f1aa311e8bb912e34f004cf186407a4e90eec4f0ecc0efd26056bf7eda0226"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/96/71/0aabc36753b7f4ad18cbc3c97dea9d6a4f204cbba7b8e9804313366e1c8f/referencing-0.32.0.tar.gz"
    sha256 "689e64fe121843dcfd57b71933318ef1f91188ffb45367332700a86ac8fd6161"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3986-validator" do
    url "https://files.pythonhosted.org/packages/da/88/f270de456dd7d11dcc808abfa291ecdd3f45ff44e3b549ffa01b126464d0/rfc3986_validator-0.1.1.tar.gz"
    sha256 "3d44bde7921b3b9ec3ae4e3adca370438eccebc676456449b145d533b240d055"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/c2/63/94a1e9406b34888bdf8506e91d654f1cd84365a5edafa5f8ff0c97d4d9e1/rpds_py-0.16.2.tar.gz"
    sha256 "781ef8bfc091b19960fc0142a23aedadafa826bc32b433fdfe6fd7f964d7ef44"
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
    url "https://files.pythonhosted.org/packages/ce/21/952a240de1c196c7e3fbcd4e559681f0419b1280c617db21157a0390717b/soupsieve-2.5.tar.gz"
    sha256 "5663d5a7b3bfaeee0bc4372e7fc48f9cff4940b3eec54a6451cc5299f1097690"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/65/ad/e84a68d77e39bee20c44909a8a0e3d9c30616f6cd1e2825f0c0372f3ca97/terminado-0.18.0.tar.gz"
    sha256 "1ea08a89b835dd1b8c0c900d92848147cef2537243361b2e3f4dc15df9b6fded"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/bd/a2/ea124343e3b8dd7712561fe56c4f92eda26865f5e1040b289203729186f2/tornado-6.4.tar.gz"
    sha256 "72291fa6e6bc84e626589f1c29d90a5a6d593ef5ae68052ee2ef000dfd273dee"
  end

  resource "types-python-dateutil" do
    url "https://files.pythonhosted.org/packages/1b/2d/f189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6f/types-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
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
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[ipython python-lsp-server].map do |package_name|
      package = Formula[package_name].opt_libexec
      package/site_packages
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    # install packages into virtualenv and link all jupyter extensions
    skipped = %w[hatch-jupyter-builder hatch-nodejs-version jupyterlab-pygments notebook]
    venv.pip_install resources.reject { |r| skipped.include? r.name }
    venv.pip_install_and_link buildpath
    bin.install_symlink (libexec/"bin").glob("jupyter*")

    # These resources require `jupyterlab` to build, causing a build loop
    # with pip's --no-binary. They need `jlpm` in PATH, so we need to add it.
    # https://github.com/jupyterlab/jupyterlab_pygments/issues/23
    ENV.prepend_path "PATH", bin
    skipped.each do |r|
      venv.pip_install(resource(r), build_isolation: false)
    end

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
      expect -timeout 60 "In "
      send "exit\r"
    EOS
    assert_match "Jupyter console", shell_output("expect -f console.exp")

    (testpath/"notebook.exp").write <<~EOS
      spawn #{bin}/jupyter notebook --no-browser
      expect "ServerApp"
    EOS
    assert_match "ServerApp", shell_output("expect -f notebook.exp")

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
