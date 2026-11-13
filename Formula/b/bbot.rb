class Bbot < Formula
  include Language::Python::Virtualenv

  desc "OSINT automation tool"
  homepage "https://www.blacklanternsecurity.com/bbot/"
  url "https://files.pythonhosted.org/packages/78/3c/d75416669c46b2731f7207545efd0eb54037b1ca5e1e68dd1dd9118bef73/bbot-3.0.2.tar.gz"
  sha256 "92bd672b306d500d8b24787ee3750ff0317a347b66322b21dae4323afcf11c45"
  license "AGPL-3.0-only"
  revision 4
  head "https://github.com/blacklanternsecurity/bbot.git", branch: "stable"

  bottle do
    sha256 arm64_golden_gate: "ac1f377ee09ddd6bcb08669a456b21b92b45a6b20733536a3d7abeb4e2cc32ac"
    sha256 arm64_tahoe:       "4dad7430b6c75e7d49e59a5db4c5e0897fd903dc7be67321e5b85dc405793004"
    sha256 arm64_sequoia:     "cc09da4e85d99ea219672086e8733dcbabce4e60d20c41fbcbfbf77917b6532e"
    sha256 arm64_linux:       "1ded1e99ab2d26a8dff5a0c002161eedbf4324a43173f25a8e90d3b031eb535e"
    sha256 x86_64_linux:      "92169e735229be0f63f397093dcbc245851a04fb3999b2f30b9ab2e24565d665"
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "openjdk" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for orjson
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "openssl@4"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "xxhash"
  depends_on "yara"
  depends_on "zeromq"
  depends_on "zstd"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  pypi_packages exclude_packages: %w[certifi cryptography pydantic]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/0f/6e/a61e86e43bb6039b31a33a8f5fba76fe1cdacf3661e7b9756d4ff1b28cdc/annotated_doc-0.0.6.tar.gz"
    sha256 "7969bb69912085b2285849c0dcac0b4b374fd180c13cf10a87f284ffcf347bbf"
  end

  resource "ansible-core" do
    url "https://files.pythonhosted.org/packages/9d/9c/320090b2f1542122259cd759d5148678fd98945913837ee05718920f73ea/ansible_core-2.22.0.tar.gz"
    sha256 "bf50b4a0cfa985e30585c7ba301897ea7050d224ca49d2816cab10e33a160e1c"
  end

  resource "ansible-runner" do
    url "https://files.pythonhosted.org/packages/68/4f/62222b42b52cc771db51ccc77ffac19cc5f0196ff61de7c93585845a819b/ansible_runner-2.4.3.tar.gz"
    sha256 "5f3025529bb968fdc3b627457dd8d418dbf9d53bc73735d50e69c28544d53031"
  end

  resource "asndb" do
    url "https://files.pythonhosted.org/packages/37/3d/f4952fb025d45cd3fff5afcf1914ac72da0f8e8b981cda4fe42067b9cf80/asndb-1.1.1.tar.gz"
    sha256 "9272dd29d649ce5c5f5fcc6c84382488120d8f7571656801c8d970e7afc2a03a"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "blastdns" do
    url "https://files.pythonhosted.org/packages/a0/63/5ad427bd5e23780961ba4f183a85d8428d961feabcfaf237347801dd00a0/blastdns-1.9.1.tar.gz"
    sha256 "e0ea09a9f0199a64aad8a6abe54e0f0de523a12e6f96da71e79af7fea9d12f2f"
  end

  resource "blasthttp" do
    url "https://files.pythonhosted.org/packages/90/c2/082a4f3ab60863d8d8b345e8ab28d93b206d9fc3a1482220ae98c928ef92/blasthttp-0.10.1.tar.gz"
    sha256 "480f2d128f59779ea569e8aeddee65c3eb613fb83649682896a27bce74d2bb39"
  end

  resource "cachebox" do
    url "https://files.pythonhosted.org/packages/36/f6/85f176d2518cf1d1be5f981fc2dadf6b131e33fefd721f36b330e3434d6c/cachebox-5.2.3.tar.gz"
    sha256 "b1f68246685aa739bbbd2734befb1465363a1e1042407c154feadb065f17a099"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/5f/6b/6c1553e1e8f672f9423344a1915aad1537439ad3d14a3fbc1a02159cfd94/cachetools-7.3.0.tar.gz"
    sha256 "3f63fc208410f0c3a3b37883c4903ecdacd6f0b259134e6d2e82debd5b2e01de"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "cloudcheck" do
    url "https://files.pythonhosted.org/packages/83/1a/9a1e0c52781c4b600c9926add96f329268dcde6be3d1f95c83d99cb6cd52/cloudcheck-11.2.0.tar.gz"
    sha256 "80287bf7a8917dfbadc5773490c33c57de31be93e4f0f80a03a730f3e6d312ba"
  end

  resource "deepdiff" do
    url "https://files.pythonhosted.org/packages/f9/6b/6a4a5aaf38535eb332c2856aa08e73ed7c549d0851b1215401af0a2db1a7/deepdiff-9.1.0.tar.gz"
    sha256 "07e9e366fab4297755153c4eab795ad4ef3cbd0d51660e847f5751c6bd727687"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a1/cf/05bcdacabdc0aec7dc8e19d76281bd82325df62dae3b6430e9ba57397689/filelock-4.2.10.tar.gz"
    sha256 "fcc3c0cb8bfe7f4b3bb0e231c04b15dbad068cb3c2515f343d8fde4dce93bd5d"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lockfile" do
    url "https://files.pythonhosted.org/packages/17/47/72cb04a58a35ec495f96984dddb48232b551aafb95bde614605b754fe6f7/lockfile-0.12.2.tar.gz"
    sha256 "6aed02de03cba24efabcd600b30540140634fc06cfa603822d508d5361e9f799"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/16/fc/cee2c45553c9a9bf77d8b0c391560c556d7ed756b1f0bb35eb5d48db09ea/markdown_it_py-4.3.0.tar.gz"
    sha256 "91a58fa5b72c71a40cf7177250fd767480d7a2bb3ac426ccfb76fb90305fdaaa"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mmh3" do
    url "https://files.pythonhosted.org/packages/8d/3c/eb1d82a87c504259dac5ce1c7de7587b68ffac841b55d23f8ea2c9df8422/mmh3-5.3.1.tar.gz"
    sha256 "bd86d0c86b52332319d981d03781ff77811a29db544a69902dc06b5506bb3e19"
  end

  resource "orderly-set" do
    url "https://files.pythonhosted.org/packages/4a/88/39c83c35d5e97cc203e9e77a4f93bf87ec89cf6a22ac4818fdcc65d66584/orderly_set-5.5.0.tar.gz"
    sha256 "e87185c8e4d8afa64e7f8160ee2c542a475b738bc891dc3f58102e654125e6ce"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/a9/75/b8a9ba9a15b1b190d1fb21e75e921934c9bcd7e63e137f96b56ed274328c/pycryptodome-3.24.1.tar.gz"
    sha256 "3f9e74444c0ecbec7af232a95d282c74b114d53212ce075ed17b7fd7dca32bb3"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "python-daemon" do
    url "https://files.pythonhosted.org/packages/3d/37/4f10e37bdabc058a32989da2daf29e57dc59dbc5395497f3d36d5f5e2694/python_daemon-3.1.2.tar.gz"
    sha256 "f7b04335adc473de877f5117e26d5f1142f4c9f7cd765408f0877757be5afbf4"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/e2/e1/ea46ab0d707219c098065a37d2add5b53d3b124241aa19429bcd0863e5b4/pyzmq-27.3.0.tar.gz"
    sha256 "bbedb3d1d99babc625f1dd9d7438acefd442b36b75073fd6bc1ef7c0a4b96d56"
  end

  resource "radixtarget" do
    url "https://files.pythonhosted.org/packages/f5/09/ae967b3e5e5b99a447bceaa27d7d4e12f3631ddac749a21def13b9a0173c/radixtarget-4.3.1.tar.gz"
    sha256 "960181f9c5702db201864d464ac0b792c66d37b928a2d94b3e54ac367ad2120b"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/61/27/a5afeb952577b84ee5fe48b8b9ce47ae662dbb69cc5b76c28eff98f83b1e/regex-2026.11.9.tar.gz"
    sha256 "316a70fbd70e999c9664681cb0eb5b4982b2cc0f623c7c86a8a112e1bd4c6277"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "requests-file" do
    url "https://files.pythonhosted.org/packages/3c/f8/5dc70102e4d337063452c82e1f0d95e39abfe67aa222ed8a5ddeb9df8de8/requests_file-3.0.1.tar.gz"
    sha256 "f14243d7796c588f3521bd423c5dea2ee4cc730e54a3cac9574d78aca1272576"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/1d/14/4669927e06631070edb968c78fdb6ce8992e27c9ab2cde4b3993e22ac7af/resolvelib-1.2.1.tar.gz"
    sha256 "7d08a2022f6e16ce405d60b68c390f054efcfd0477d4b9bd019cc941c28fad1c"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/49/b0/6b8a516c5a9e9630bd5293db78314ac012f690305fe93beadea388626efb/setproctitle-1.3.8.tar.gz"
    sha256 "cafe209d064a6efb88cb45a03e97981ff8832802b2b5d009dde0197a3b7b41c8"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "socksio" do
    url "https://files.pythonhosted.org/packages/f8/5c/48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85/socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"

    # Unpin flit-core<3 to support 3.14+
    patch do
      url "https://github.com/sethmlarson/socksio/commit/b326406915fd98a8185c1c160165c5b8963b30c1.patch?full_index=1"
      sha256 "7aefa906b62e2c9a8df255ea742ca97e155ac2e1238e49ce11e3e56e37ee1f8b"
      type :backport
      resolves "https://github.com/sethmlarson/socksio/pull/61"
    end

    # Fix for flit-core>=5
    patch do
      url "https://github.com/sethmlarson/socksio/commit/504f7e51682b9526d3ecc7ea893338af1fedfb2d.patch?full_index=1"
      sha256 "b0c327c4e8fa722669dc372263d735f429015587e02935e2e8cb2b22028c0bfb"
      type :backport
      resolves "https://github.com/sethmlarson/socksio/pull/66"
    end
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/95/48/21a393ff731b8f928fa4f8176f9a7ceba2252ee60a5149f25b45c292aa5c/soupsieve-4.1.tar.gz"
    sha256 "ca9abf7126667010d8f6e9b39bfc1bc3b23c8aed9bcb0f54a754dde969bb8aab"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/7a/53/afac341569b3fd558bf2b5428e925e2eb8753ad9627c1f9188104c6e0c4a/tabulate-0.8.10.tar.gz"
    sha256 "6c57f3f3dd7ac2782770155f3adb2db0b1a269637e42f27599925e64b114f519"
  end

  resource "tldextract" do
    url "https://files.pythonhosted.org/packages/fd/5d/45ece871390ccc985f821353543165bcf3784fa97d8484fd0ca5f2726612/tldextract-5.4.0.tar.gz"
    sha256 "6c9223212c15c25c0da2bf7313893c14f175cb36b64a0c42da67a468e0c61ee3"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/6c/aa/0de7986aa1fa856adb961c67345189b97d13f6e250b34ba68884df865f07/typer-0.29.1.tar.gz"
    sha256 "ab6eb3880bf67ce96147734717f9ec333c06f66e361f3ea947d0be43da39f242"
  end

  resource "unidecode" do
    url "https://files.pythonhosted.org/packages/94/7d/a8a765761bbc0c836e397a2e48d498305a865b70a8600fd7a942e85dcf63/Unidecode-1.4.0.tar.gz"
    sha256 "ce35985008338b676573023acc382d62c264f307c8f7963733405add37ea2b23"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  resource "wordninja" do
    url "https://files.pythonhosted.org/packages/30/15/abe4af50f4be92b60c25e43c1c64d08453b51e46c32981d80b3aebec0260/wordninja-2.0.0.tar.gz"
    sha256 "1a1cc7ec146ad19d6f71941ee82aef3d31221700f0d8bf844136cf8df79d281a"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/50/05/51dcca9a9bf5e1bce52582683ce50980bcadbc4fa5143b9f2b19ab99958f/xmltodict-0.14.2.tar.gz"
    sha256 "201e7c28bb210e374999d1dde6382923ab0ed1a8a5faeece48ab525b7810a553"
  end

  resource "xmltojson" do
    url "https://files.pythonhosted.org/packages/c5/bd/7ff42737e3715eaf0e46714776c2ce75c0d509c7b2e921fa0f94d031a1ff/xmltojson-2.0.3.tar.gz"
    sha256 "68a0022272adf70b8f2639186172c808e9502cd03c0b851a65e0760561c7801d"
  end

  resource "xxhash" do
    url "https://files.pythonhosted.org/packages/c9/b5/3d11d3830ace56d67ea83136c24385c3b07da5a9bc62b73b0b94ac096da3/xxhash-4.1.0.tar.gz"
    sha256 "c9b288e4c1f5dae54417bc8a05e6f6daf505783d916b4783f4dd2f2e7d5db486"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/51/38/347d1fcde4edabd338d5872ca5759ccfb95ff1cf5207dafded981fd08c4f/yara_python-4.5.4.tar.gz"
    sha256 "4c682170f3d5cb3a73aa1bd0dc9ab1c0957437b937b7a83ff6d7ffd366415b9c"
  end

  resource "zstandard" do
    url "https://files.pythonhosted.org/packages/fd/aa/3e0508d5a5dd96529cdc5a97011299056e14c6505b678fd58938792794b1/zstandard-0.25.0.tar.gz"
    sha256 "7713e1179d162cf5c7906da876ec2ccb9c3a9dcbdffef0cc7f70c3667a205f0b"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")
    ENV["XXHASH_LINK_SO"] = "1"

    venv = virtualenv_install_with_resources without: %w[yara-python zstandard]

    resource("yara-python").stage do
      inreplace "setup.py", "self.dynamic_linking = None", "self.dynamic_linking = True"
      venv.pip_install Pathname.pwd
    end

    resource("zstandard").stage do
      args = std_pip_args(prefix: false, build_isolation: true)
      args << "--config-settings=--build-option=--system-zstd"
      system venv.root/"bin/python", "-m", "pip", "install", *args, "."
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bbot --version")

    assert_path_exists testpath/".config/bbot/bbot.yml"
    assert_path_exists testpath/".config/bbot/secrets.yml"
  end
end
