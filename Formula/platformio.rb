class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Professional collaborative platform for embedded development"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/1f/7a/a1ba9282b3efe26ac84760773aba00dd33a582a77b1310a28286d76cb1fa/platformio-6.1.3.tar.gz"
  sha256 "a1e738be028c2e54040c9a6784c22ee8d56390cde7bf927e520c224c881749a8"
  license "Apache-2.0"
  head "https://github.com/platformio/platformio-core.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "569b3b164962739fae031acea67bb443428eb9debc3d0a389abbabdba7bbd0b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "883496592f54b2fbd49ca7a538aabb672a65b4c67bdb90a5dfbcaec3494c9dbe"
    sha256 cellar: :any_skip_relocation, monterey:       "2d326683e717b0383f9f9565b582f07e531c404a6ca19a926ee59358a994334d"
    sha256 cellar: :any_skip_relocation, big_sur:        "cce73eda11044e7845d93f23990382cd4341d5016a23557b8ea6d22f45d511dc"
    sha256 cellar: :any_skip_relocation, catalina:       "58b2d846c648b73fd556c75468f49a0c16750de73a97d55eca3e172564f20925"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d1604e9c2eb0aee81b6d67a07751556e93bafc3e7d7fde6b1d0099208e58272"
  end

  depends_on "libpython-tabulate"
  depends_on "python@3.10"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/10/ca/c416cfacf6a47e1400dad56eab85aa86c92c6fbe58447d12035e434f0d5c/aiofiles-0.8.0.tar.gz"
    sha256 "8334f23235248a3b2e83b2c3a78a22674f39969b96397126cc93664d9a901e59"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/67/c4/fd50bbb2fb72532a4b778562e28ba581da15067cfb2537dbd3a2e64689c1/anyio-3.6.1.tar.gz"
    sha256 "413adf95f93886e442aea925f3ee43baa5a765a64a0f52c6081894f9992fdd0b"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/95/e3/5749d7657b6fb38d65afb3c0b345514a783de7a9feb4fab594fa0bacc2a0/bottle-0.12.21.tar.gz"
    sha256 "787c61b6cc02b9c229bf2663011fac53dd8fc197f7f8ad2eeede29d888d7887e"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cc/85/319a8a684e8ac6d87a1193090e06b6bbb302717496380e225ee10487c888/certifi-2022.6.15.tar.gz"
    sha256 "84c85a9078b11105f04f3036a9482ae10e4621616db313fe045dd24743a0820d"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/93/1d/d9392056df6670ae2a29fcb04cfa5cee9f6fbde7311a1bb511d4115e9b7a/charset-normalizer-2.1.0.tar.gz"
    sha256 "575e708016ff3a5e3681541cb9d79312c416835686d054a23accb873b254f413"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
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
    url "https://files.pythonhosted.org/packages/e8/ac/fb4c578f4a3256561548cd825646680edcadb9440f3f68add95ade1eb791/ifaddr-0.2.0.tar.gz"
    sha256 "cc0cbfcaabf765d44595825fb96a99bb12c79716b73b44330ea38ee2b0c4aed4"
  end

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/50/23/cd717da7c1a78845b3127ba053c2a561d1193b8a0392ca1b4a4e61a5d7d4/marshmallow-3.17.0.tar.gz"
    sha256 "635fb65a3285a31a30f276f30e958070f5214c7196202caa5c7ecf28f5274bc7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/e9/80/00247e07e32e85b964ef81c9fd556b332f85e743e3eaf332325f579c82eb/pyelftools-0.28.tar.gz"
    sha256 "53e5609cac016471d40bd88dc410cd90755942c25e58a61021cfdf7abdfeacff"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/7d/31/f2289ce78b9b473d582568c234e104d2a342fd658cc288a7553d83bb8595/semantic_version-2.10.0.tar.gz"
    sha256 "bdabb6d336998cbb378d4b9db3a4b56a1e3235701dc05ea2690d9a997ed5041c"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/b7/9b/dc9fa4c05a8aceb7abbf057b1279f0007ce8ab42c9b8f31a9c71981955bc/starlette-0.20.4.tar.gz"
    sha256 "42fcf3122f998fefce3e2c5ad7e5edbf0f02cf685d646a83a08d404726af5084"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/9e/1d/d128169ff58c501059330f1ad96ed62b79114a2eb30b8238af63a2e27f70/typing_extensions-4.3.0.tar.gz"
    sha256 "e6d2677a32f47fc7eb2795db1dd15c1f34eff616bcaf2cfb5e997f854fa1c4a6"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/25/36/f056e5f1389004cf886bb7a8514077f24224238a7534497c014a6b9ac770/urllib3-1.26.10.tar.gz"
    sha256 "879ba4d1e89654d9769ce13121e0f94310ea32e8d2f8cf587b77c08bbcdb30d6"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/c1/ec/23abd850aa173e35b0436f46a3385585b131ee0e70a55c408d89cade30a1/uvicorn-0.18.2.tar.gz"
    sha256 "cade07c403c397f9fe275492a48c1b869efd175d5d8a692df649e6e7e2ed8f4e"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/f5/58/575e416cd024d23c52de9e17d02f4c5ef4a9c8a7258c6fc8f2b3f96f73cf/wsproto-1.1.0.tar.gz"
    sha256 "a2e56bfd5c7cd83c1369d83b5feccd6d37798b74872866e62616e0ecf111bda8"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/5d/3f/25d4da0ada92e618a903d0a5d5e096d84b78050c5cb90ad8691a53e8692b/zeroconf-0.38.7.tar.gz"
    sha256 "eaee2293e5f4e6d249f6155f9d3cca1668cb22b2545995ea72c6a03b4b7706d4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/pio boards ststm32")
    assert_match "ST Nucleo F401RE", output
  end
end
