class Esphome < Formula
  include Language::Python::Virtualenv

  desc "Make creating custom firmwares for ESP32/ESP8266 super easy"
  homepage "https://github.com/esphome/esphome"
  url "https://files.pythonhosted.org/packages/4d/4a/fbb626a5a0caf0731e03ed6060e0680c7e6a00972b15b45097fb14d08ef2/esphome-2022.3.1.tar.gz"
  sha256 "9f53e1f4744bd3e4649eb2c1ef50f78b7b16cd15425f77daa8b6f9f2bd01c510"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "042633ec573efbf02a44a5c2f779e9c5dbd2e9b1563fb69a456b4a230a145cb1"
    sha256 cellar: :any,                 arm64_big_sur:  "a63fa9fe2ed2c418a79dd5bd0df4f87e6c8c14102975be7ef1f8da1c526dee0c"
    sha256 cellar: :any,                 monterey:       "db53f48fb09250558c4035e64718950863a8b26d818f523510ebef5027a95f05"
    sha256 cellar: :any,                 big_sur:        "6a44e0ef00e64544c2a60feec6be52e98931377649209f09274502c24745ac5d"
    sha256 cellar: :any,                 catalina:       "e531101f11cf58b1a32e74b7e451b8ea41b0b239562f6f9bf8ad75cf48ca4ebc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95083f877349ccdfc5fde06b4d085be2bfd98afa77dc0b662626ce08a4ae6c71"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "protobuf"
  depends_on "python-tabulate"
  depends_on "python@3.9"
  depends_on "six"

  resource "aioesphomeapi" do
    url "https://files.pythonhosted.org/packages/55/fd/bcedfcbaba26f5baad223246c8e1a65d1242232ce353e89e324e8155b789/aioesphomeapi-10.8.2.tar.gz"
    sha256 "0b4e31b2aac0808694c09a2b06a3ea417fdfc6ff76435375bd922b077d6a2f74"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/10/ca/c416cfacf6a47e1400dad56eab85aa86c92c6fbe58447d12035e434f0d5c/aiofiles-0.8.0.tar.gz"
    sha256 "8334f23235248a3b2e83b2c3a78a22674f39969b96397126cc93664d9a901e59"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/4f/d0/b957c0679a9bd0ed334e2e584102f077c3e703f83d099464c3d9569b7c8a/anyio-3.5.0.tar.gz"
    sha256 "a0aeffe2fb1fdf374a8e4b471444f0f3ac4fb9f5a5b542b48824475e0042a5a6"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/ea/2b/3face3a7241f61dc1c58dbe243cc02c15c61ccdcafebc4406f7bb40ce731/asgiref-3.5.0.tar.gz"
    sha256 "2f8abc20f7248433085eda803936d98992f1343ddb022065779f37c5da0181d0"
  end

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/4c/b1/80d58eeb21c9d4ca739770558d61f6adacb13aa4908f4f55e0974cbd25ee/bitstring-3.1.9.tar.gz"
    sha256 "a5848a3f63111785224dca8bb4c0a75b62ecdef56a042c8d6be74b16f7e860e7"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/ea/80/3d2dca1562ffa1929017c74635b4cb3645a352588de89e90d0bb53af3317/bottle-0.12.19.tar.gz"
    sha256 "a9d73ffcbc6a1345ca2d7949638db46349f5b2b77dac65d6494d45c23628da2c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/bf/3d/3d909532ad541651390bf1321e097404cbd39d1d89c2046f42a460220fb3/ecdsa-0.17.0.tar.gz"
    sha256 "b9f500bb439e4153d0330610f5d26baaf18d17b8ced1bc54410d189385ea68aa"
  end

  resource "esphome-dashboard" do
    url "https://files.pythonhosted.org/packages/4f/c6/3668d402f9187e7c2cedee3490e38df77a437b0eedf00e5405b02ce2374d/esphome-dashboard-20220309.0.tar.gz"
    sha256 "27f4f702fd23c13d02252c1cd23f988da88a16ab3db282dfedcb698b3e6b9a6e"
  end

  resource "esptool" do
    url "https://files.pythonhosted.org/packages/60/a4/33907f5b735f9179061bd6b6cae7123d4a2d0cdf46c879fa55e66edef24f/esptool-3.2.tar.gz"
    sha256 "9638ff11c68e621e08e7c3335d4fd9d70b2ddcf7caae778073cd8cc27be1216f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/fa/a6/450568b2d62dd633be53f69890332bb0ce78183ffbe1e514c2b3102efff5/h11-0.13.0.tar.gz"
    sha256 "70813c1135087a248a4d38cc0e1a0181ffab2188141a93eaf567940c3957ff06"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/62/08/e3fc7c8161090f742f504f40b1bccbfc544d4a4e09eb774bf40aafce5436/idna-3.3.tar.gz"
    sha256 "9d643ff0a55b762d5cdb124b8eaa99c66322e2157b69160bc32796e824360e6d"
  end

  resource "ifaddr" do
    url "https://files.pythonhosted.org/packages/3d/fc/4ce147e3997cd0ea470ad27112087545cf83bf85015ddb3054673cb471bb/ifaddr-0.1.7.tar.gz"
    sha256 "1f9e8a6ca6f16db5a37d3356f07b6e52344f6f9f7e806d618537731669eb1a94"
  end

  resource "kconfiglib" do
    url "https://files.pythonhosted.org/packages/86/82/54537aeb187ade9b609af3d2988312350a7fab2ff2d3ec0230ae0410dc9e/kconfiglib-13.7.1.tar.gz"
    sha256 "a2ee8fb06102442c45965b0596944f02c2a1517f092fa208ca307f3fd12a0a22"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/ef/d1/3c7c7d0ed4470c49c971cb5db4c5becdc37bd3969946bba434216c56c08c/marshmallow-3.15.0.tar.gz"
    sha256 "2aaaab4f01ef4f5a011a21319af9fce17ab13bf28a026d1252adab0e035648d5"
  end

  resource "noiseprotocol" do
    url "https://files.pythonhosted.org/packages/76/17/fcf8a90dcf36fe00b475e395f34d92f42c41379c77b25a16066f63002f95/noiseprotocol-0.3.1.tar.gz"
    sha256 "b092a871b60f6a8f07f17950dc9f7098c8fe7d715b049bd4c24ee3752b90d645"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "paho-mqtt" do
    url "https://files.pythonhosted.org/packages/f8/dd/4b75dcba025f8647bc9862ac17299e0d7d12d3beadbf026d8c8d74215c12/paho-mqtt-1.6.1.tar.gz"
    sha256 "2a8291c81623aec00372b5a85558a372c747cbca8e9934dfe218638b8eefc26f"
  end

  resource "platformio" do
    url "https://files.pythonhosted.org/packages/9d/e6/d369eada663ba901e5a9d6783b160ca546515b112b06bbb42851792f3353/platformio-5.2.5.tar.gz"
    sha256 "aa0d1ff8a17ac1952eb45d37a84d4aa6e5d1aa65098bd1525db34be83c42c4ae"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/e9/80/00247e07e32e85b964ef81c9fd556b332f85e743e3eaf332325f579c82eb/pyelftools-0.28.tar.gz"
    sha256 "53e5609cac016471d40bd88dc410cd90755942c25e58a61021cfdf7abdfeacff"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/d6/60/9bed18f43275b34198eb9720d4c1238c68b3755620d20df0afd89424d32b/pyparsing-3.0.7.tar.gz"
    sha256 "18ee9022775d270c55187733956460083db60b37d0d0fb357445f3094eed3eea"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pytz-deprecation-shim" do
    url "https://files.pythonhosted.org/packages/94/f0/909f94fea74759654390a3e1a9e4e185b6cd9aa810e533e3586f39da3097/pytz_deprecation_shim-0.1.0.post0.tar.gz"
    sha256 "af097bae1b616dde5c5744441e2ddc69e74dfdcb0c263129610d85b87445a59d"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/36/2b/61d51a2c4f25ef062ae3f74576b01638bebad5e045f747ff12643df63844/PyYAML-6.0.tar.gz"
    sha256 "68fb519c14306fec9720a2a5b45bc9f0c8d1b9c72adf45c37baedfcd949c35a2"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/c8/cb/bb2ddbd00c9b4215dd57a2abf7042b0ae222b44522c5eb664a8fd9d786da/reedsolo-1.5.4.tar.gz"
    sha256 "b8b25cdc83478ccb06361a0e8fadc27b376a3dfabbb1dc6bb583a998a22c0127"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/60/f3/26ff3767f099b73e0efa138a9998da67890793bfa475d8278f84a30fec77/requests-2.27.1.tar.gz"
    sha256 "68d7c56fd5a8999887728ef304a6d12edc7be74f1cfa47714fc8b414525c9a61"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/cb/56/4aa487b46d09646eb1863faa7026551d8309ece2281794bf13b20f28ab94/semantic_version-2.9.0.tar.gz"
    sha256 "abf54873553e5e07a6fd4d5f653b781f5ae41297a493666b59dcf214006a12b2"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/79/5b/ed3c47284b7056ceedc149f41f93640f030e7f5d945f52dc9bc5973f66dc/starlette-0.18.0.tar.gz"
    sha256 "b45c6e9a617ecb5caf7e6446bd8d767b0084d6217e8e1b08187ca5191e10f097"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/cf/44/cc9590db23758ee7906d40cacff06c02a21c2a6166602e095a56cbf2f6f6/tornado-6.1.tar.gz"
    sha256 "33c6e81d7bd55b468d2e793517c909b139960b6c790a60b7991b9b6b76fb9791"
  end

  resource "tzdata" do
    url "https://files.pythonhosted.org/packages/df/c7/2d8ea31840794fb341bc2c2ea72bf1bd16bd778bd8c0d7c9e1e5f9df1de3/tzdata-2022.1.tar.gz"
    sha256 "8b536a8ec63dc0751342b3984193a3118f8fca2afe25752bb9b7fffd398552d3"
  end

  resource "tzlocal" do
    url "https://files.pythonhosted.org/packages/f7/cc/5543aa3e3e0c10f5fa6d0010eead722e0a5cc610f543fc6e816648d73ed7/tzlocal-4.1.tar.gz"
    sha256 "0f28015ac68a5c067210400a9197fc5d36ba9bc3f8eaf1da3cbd59acdfed9e09"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/6d/7d/b97c120cad5fd1f66462afb0d5ddd043078f2380b89fccd8a97ef5c95b5c/uvicorn-0.17.6.tar.gz"
    sha256 "5180f9d059611747d841a4a4c4ab675edf54c8489e97f96d0583ee90ac3bfc23"
  end

  resource "voluptuous" do
    url "https://files.pythonhosted.org/packages/c0/2c/ccbeb25364e3e0c5e4522f13d66e2fc639bb4d4ecdf73be0959552cbecb4/voluptuous-0.12.2.tar.gz"
    sha256 "4db1ac5079db9249820d49c891cb4660a6f8cae350491210abce741fabf56513"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/2b/a4/aded0882f8f1cddd68dcd531309a15bf976f301e6a3554055cc06213c227/wsproto-1.0.0.tar.gz"
    sha256 "868776f8456997ad0d9720f7322b746bbe9193751b5b290b7f924659377c8c38"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/9b/4a/e37a64b23fdc961ed0137663db022cfb8b37d382ea5a6356f8bab803464c/zeroconf-0.38.3.tar.gz"
    sha256 "1c1feb71f5cf53baa5e00ff2c550edd30b2e6a20779001332115afa2ef64af72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      esphome:
        name: test
        platform: ESP8266
        board: d1
    EOS

    assert_includes shell_output("#{bin}/esphome config #{testpath}/test.yaml 2>&1"), "INFO Configuration is valid!"
  end
end
