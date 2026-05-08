class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/18/d8/695904a15ca14a5c880d9a724b36de2d5ca4a0911d5a668fa7ae8aa6a3dc/esphome-2026.4.3.tar.gz"
  sha256 "0ad90497c1d559130a89795c88ba65b6b6ab1d5c9f4c596757fe3cd563b13317"
  license "MIT"
  head "https://github.com/esphome/esphome.git", branch: "dev"

  # Issue ref: https://github.com/Homebrew/homebrew-core/issues/257992
  no_autobump! because: "macOS resources cannot be updated on linux CI"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d40c15f54bb81cec6280e1711b94a63c743b31aa57c3e62700400c9cb7d24c3a"
    sha256 cellar: :any,                 arm64_sequoia: "78645bd3398cbaf59bdb51622f55f79dc7817487a3c2d5e8bff3831b39695e8d"
    sha256 cellar: :any,                 arm64_sonoma:  "3efc09c4186b07e4631f6915add84ed48ef9e2a928f33deb2d872cfd42a76833"
    sha256 cellar: :any,                 sonoma:        "82546e2dff7224788caff4ddfe865ebc845386d6fc337e8bff5eca4b5eaa8044"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8105a2a457072d4c290cbb4cea1432e99676177d201c1f0942f2b2c40fb5715e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0cc4db73da6996c63d4e0da3ab1e83cf770195937982bf04db697a916bf65b03"
  end

  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  fails_with :clang do
    build 1699
    cause "pyobjc-core uses `-fdisable-block-signature-string`"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic],
                extra_packages:   %w[chardet dbus-fast pyobjc-framework-corebluetooth pyobjc-framework-libdispatch]

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/25/b1/ba6eb7eef5386ec42ab43a28a81b2585f6994878b974e51e82416d4b7423/aioesphomeapi-44.16.1.tar.gz"
    sha256 "834c08314883e2fe3625b8847a591001e1f8e4eeebe5387f10b760c2812660a3"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/19/14/2c5dd9f512b66549ae92767a9c7b330ae88e1932ca57876909410251fe13/anyio-4.13.0.tar.gz"
    sha256 "334b70e641fd2221c1505b3890c69882fe4a2df910cba14d97019b90b24439dc"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "async-interrupt" do
    url "https://files.pythonhosted.org/packages/56/79/732a581e3ceb09f938d33ad8ab3419856181d95bb621aa2441a10f281e10/async_interrupt-1.2.2.tar.gz"
    sha256 "be4331a029b8625777905376a6dc1370984c8c810f30b79703f3ee039d262bf7"
  end

  resource "bitarray" do
    url "https://files.pythonhosted.org/packages/fc/47/b5da717e7bbe97a6dc4c986f053ca55fd3276078d78f68f9e8b417d1425a/bitarray-3.8.1.tar.gz"
    sha256 "f90bb3c680804ec9630bcf8c0965e54b4de84d33b17d7da57c87c30f0c64c6f5"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/36/d3/de6fe4e7065df8c2f1ac1766f5fdccbe75bc18af2cf2dbeecd34d68e1518/bitstring-4.4.0.tar.gz"
    sha256 "e682ac522bb63e041d16cbc9d0ca86a4f00194db16d0847c7efe066f836b2e37"
  end

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/45/8a/5acbd4da6a5a301fab56ff6d6e9e6b6945e6e4a2d1d213898c21b1d3a19b/bleak-2.1.1.tar.gz"
    sha256 "4600cc5852f2392ce886547e127623f188e689489c5946d422172adf80635cf9"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7a/71/cca6167c06d00c81375fd668719df245864076d284f7cb46a694cbeb5454/bottle-0.13.4.tar.gz"
    sha256 "787e78327e12b227938de02248333d788cfe45987edca735f8f88e03472c3f47"
  end

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/bd/cb/09939728be094d155b5d4ac262e39877875f5f7e36eea66beb359f647bd0/cbor2-5.9.0.tar.gz"
    sha256 "85c7a46279ac8f226e1059275221e6b3d0e370d2bb6bd0500f9780781615bcea"
  end

  resource "chacha20poly1305-reuseable" do
    url "https://files.pythonhosted.org/packages/c1/ff/6ca12ab8f4d804cfe423e67d7e5de168130b106a0cb749a1043943c23b6b/chacha20poly1305_reuseable-0.13.2.tar.gz"
    sha256 "dd8be876e25dfc51909eb35602b77a76e0d01a364584756ab3fa848e2407e4ec"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/f3/0d/f7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079/chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/57/75/31212c6bf2503fdf920d87fee5d7a86a2e3bcf444984126f13d8e4016804/click-8.3.2.tar.gz"
    sha256 "14162b8b3b3550a7d479eafa77dfd3c38d9dc8951f6f69c78913a8f9a7540fd5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "crcmod" do
    url "https://files.pythonhosted.org/packages/6b/b0/e595ce2a2527e169c3bcd6c33d2473c1918e0b7f6826a043ca1245dd4e5b/crcmod-1.7.tar.gz"
    sha256 "dc7051a0db5f2bd48665a990d3ec1cc305a466a77358ca4492826f41f283601e"
  end

  resource "dbus-fast" do
    url "https://files.pythonhosted.org/packages/5f/cd/402b0e524bdf37d8b1d22b1d926c538bf1d2eedf115ea1d401c6c08a7d81/dbus_fast-4.0.4.tar.gz"
    sha256 "43137f0b73a7adbf7d5c0e9eb9d8d34df9e6e0aeafade2166e641c52dfe0a853"
  end

  resource "esphome-dashboard" do
    url "https://files.pythonhosted.org/packages/d2/ae/e627cfe96d9c7801e8c9d80cea4df54477430d5eac00b4e4f761c726d8d6/esphome_dashboard-20260408.1.tar.gz"
    sha256 "3de34b24ae7cb2845647c09dedc3e0a6aa04c97c735da5e41b8bd06b16ddfb43"
  end

  resource "esphome-glyphsets" do
    url "https://files.pythonhosted.org/packages/a8/d0/a90161d91647d7d8c46bd9394d6cf4c712afe513629bdbeaaa2e2cef5ae4/esphome_glyphsets-0.2.0.tar.gz"
    sha256 "f68523dabd1960659d1b0d5d2d39e0bf002885228bd494fb8ed857302297d95c"
  end

  resource "esptool" do
    url "https://files.pythonhosted.org/packages/77/25/7b50d81a66f600a60f23258fa134201e97e854271b478ca4e21e9f694355/esptool-5.2.0.tar.gz"
    sha256 "9c355b7d6331cc92979cc710ae5c41f59830d1ea29ec24c467c6005a092c06d6"
  end

  resource "freetype-py" do
    url "https://files.pythonhosted.org/packages/d0/9c/61ba17f846b922c2d6d101cc886b0e8fb597c109cedfcb39b8c5d2304b54/freetype-py-2.5.1.zip"
    sha256 "cfe2686a174d0dd3d71a9d8ee9bf6a2c23f5872385cf8ce9f24af83d076e2fbd"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "icmplib" do
    url "https://files.pythonhosted.org/packages/6d/78/ca07444be85ec718d4a7617f43fdb5b4eaae40bc15a04a5c888b64f3e35f/icmplib-3.0.4.tar.gz"
    sha256 "57868f2cdb011418c0e1d5586b16d1fabd206569fe9652654c27b6b2d6a316de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "intelhex" do
    url "https://files.pythonhosted.org/packages/66/37/1e7522494557d342a24cb236e2aec5d078fac8ed03ad4b61372586406b01/intelhex-2.3.0.tar.gz"
    sha256 "892b7361a719f4945237da8ccf754e9513db32f5628852785aea108dcd250093"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/55/79/de6c16cc902f4fc372236926b0ce2ab7845268dcc30fb2fbb7f71b418631/marshmallow-3.26.2.tar.gz"
    sha256 "bbe2adb5a03e6e3571b573f42527c6fe926e17467833660bebd11593ab8dfd57"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d7/f1/e7a6dd94a8d4a5626c03e4e99c87f241ba9e350cd9e6d75123f992427270/packaging-26.2.tar.gz"
    sha256 "ff452ff5a3e828ce110190feff1178bb1f2ea2281fa2075aadb987c2fb221661"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/f8/dd/4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12/paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "platformio" do
    url "https://files.pythonhosted.org/packages/3d/a8/e5a87ead3e0c25c054fa9dbfcc5e3ad3bca5b830f691fea820ca618fcc3e/platformio-6.1.19.tar.gz"
    sha256 "7b53eaa36fcba554411b669eab845626da7c4b90fa6aaee9fe9f1875d82f5f54"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/6b/6b/a0e95cad1ad7cc3f2c6821fcab91671bd5b78bd42afb357bb4765f29bc41/protobuf-7.34.1.tar.gz"
    sha256 "9ce42245e704cc5027be797c1db1eb93184d44d1cdd71811fb2d9b25ad541280"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/b9/ab/33968940b2deb3d92f5b146bc6d4009a5f95d1d06c148ea2f9ee965071af/pyelftools-0.32.tar.gz"
    sha256 "6de90ee7b8263e740c8715a925382d4099b354f29ac48ea40d840cf7aa14ace5"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "pyobjc-framework-corebluetooth" do
    url "https://files.pythonhosted.org/packages/4b/25/d21d6cb3fd249c2c2aa96ee54279f40876a0c93e7161b3304bf21cbd0bfe/pyobjc_framework_corebluetooth-12.1.tar.gz"
    sha256 "8060c1466d90bbb9100741a1091bb79975d9ba43911c9841599879fc45c2bbe0"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https://files.pythonhosted.org/packages/26/e8/75b6b9b3c88b37723c237e5a7600384ea2d84874548671139db02e76652b/pyobjc_framework_libdispatch-12.1.tar.gz"
    sha256 "4035535b4fae1b5e976f3e0e38b6e3442ffea1b8aa178d0ca89faa9b8ecdea41"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/f3/91/9c6ee907786a473bf81c5f53cf703ba0957b23ab84c264080fb5a450416f/pyparsing-3.3.2.tar.gz"
    sha256 "c777f4d763f140633dcb6d8a3eda953bf7a214dc4eff598413c070bcdc117cbc"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/f7/61/a67338cbecf370d464e71b10e9a31355f909d6937c3a8d6b17dd5d5beb5e/reedsolo-1.7.0.tar.gz"
    sha256 "c1359f02742751afe0f1c0de9f0772cc113835aa2855d2db420ea24393c87732"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "resvg-py" do
    url "https://files.pythonhosted.org/packages/f4/36/f5c34bc62a3574e5cd6a80a7699f2a78c3bd012ab268f7702ecc70cf4333/resvg_py-0.2.6.tar.gz"
    sha256 "dd8942159cbefd3f43389816e90065637dd1e89094f62bc9bd52e62513523444"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "rich-click" do
    url "https://files.pythonhosted.org/packages/04/27/091e140ea834272188e63f8dd6faac1f5c687582b687197b3e0ec3c78ebf/rich_click-1.9.7.tar.gz"
    sha256 "022997c1e30731995bdbc8ec2f82819340d42543237f033a003c7b1f843fc5dc"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "smp" do
    url "https://files.pythonhosted.org/packages/26/3d/2fff3d2fb96f371eaa2621e1d5478db3f27fe11c8c01e8c7320997fb71d5/smp-4.0.2.tar.gz"
    sha256 "11ea847fb6ebfdd4fe9240bfa48c03e7030f74a1372c1fb1672a9988aab8d87f"
  end

  resource "smpclient" do
    url "https://files.pythonhosted.org/packages/47/b0/3a8808c4872811b49d1a639a5d9e8ea16bd222a93b73e566f36ec135d31a/smpclient-6.0.0.tar.gz"
    sha256 "15b7a4e4627ccca82d94def2fc5b837de5fdd8e7c81783764df9ee62ba8b2500"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/c4/68/79977123bb7be889ad680d79a40f339082c1978b5cfcf62c2d8d196873ac/starlette-0.52.1.tar.gz"
    sha256 "834edd1b0a23167694292e94f597773bc3f89f362be6effee198165a35d62933"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tibs" do
    url "https://files.pythonhosted.org/packages/57/cd/6cf028decf1c2df4d26077dd5d0532587d93d4917233d5e004133166a940/tibs-0.5.7.tar.gz"
    sha256 "173dfbecb2309edd9771f453580c88cf251e775613461566b23dbd756b3d54cb"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/f8/f1/3173dfa4a18db4a9b03e5d55325559dab51ee653763bb8745a75af491286/tornado-6.5.5.tar.gz"
    sha256 "192b8f3ea91bd7f1f50c06955416ed76c6b72f96779b962f07f911b91e8d30e9"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/ba/19/1b9b0e29f30c6d35cb345486df41110984ea67ae69dddbc0e8a100999493/tzdata-2026.2.tar.gz"
    sha256 "9173fde7d80d9018e02a662e168e5a2d04f87c41ea174b139fbef642eda62d10"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/8b/2e/c14812d3d4d9cd1773c6be938f89e5735a1f11a9f184ac3639b93cef35d5/tzlocal-5.3.1.tar.gz"
    sha256 "cceffc7edecefea1f595541dbd6e990cb1ea3d19bf01b2809f362a03dd7921fd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c3/d1/8f3c683c9561a4e6689dd3b1d345c815f10f86acd044ee1fb9a4dcd0b8c5/uvicorn-0.40.0.tar.gz"
    sha256 "839676675e87e73694518b5574fd0f24c9d97b46bea16df7b8c05ea1a51071ea"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/92/f4/0738e6849858deae22218be3bbb8207ba83a96e9d0ec7e8e8cd67b30e5ca/voluptuous-0.16.0.tar.gz"
    sha256 "006535e22fed944aec17bef6e8725472476194743c87bd233e912eb463f8ff05"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c7/79/12135bdf8b9c9367b8701c2c19a14c913c120b882d50b014ca0d38083c2c/wsproto-1.3.2.tar.gz"
    sha256 "b86885dcf294e15204919950f666e06ffc6c7c114ca900b060d6e16293528294"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/67/46/10db987799629d01930176ae523f70879b63577060d63e05ebf9214aba4b/zeroconf-0.148.0.tar.gz"
    sha256 "03fcca123df3652e23d945112d683d2f605f313637611b7d4adf31056f681702"
  end

  def install
    # Help `pyobjc-framework-cocoa` pick correct SDK after removing -isysroot from Python formula
    ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}" if OS.mac?

    without = if OS.mac?
      ["dbus-fast"]
    else
      %w[chardet pyobjc-core pyobjc-framework-cocoa pyobjc-framework-corebluetooth pyobjc-framework-libdispatch]
    end

    virtualenv_install_with_resources(without:)

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "esphome",
                                         shell_parameter_format: :arg)
  end

  test do
    (testpath/"test.yaml").write <<~YAML
      esphome:
        name: test
      esp8266:
        board: d1
    YAML

    assert_includes shell_output("#{bin}/esphome config #{testpath}/test.yaml 2>&1"), "INFO Configuration is valid!"
    return if Hardware::CPU.arm?

    ENV.remove_macosxsdk if OS.mac?
    system bin/"esphome", "compile", "test.yaml"
  end
end
