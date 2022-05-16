class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Professional collaborative platform for embedded development"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/e1/df/64cdd2b7c2852eefa74caa9319fa427468d79c95882dbaa8657fd61e172e/platformio-6.0.0.tar.gz"
  sha256 "8a4f660bd46f54d6b7271636be93019ec3c1f8ee547250c006661abde2f0946a"
  license "Apache-2.0"
  head "https://github.com/platformio/platformio-core.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a29db1f9f19f41cc8c753cea288205e18268f5753414770ac884ce2e688b63d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acb6f179b8fac0ce6e8943103fe61bd646c6204ccd0bb2e4411f757998878a08"
    sha256 cellar: :any_skip_relocation, monterey:       "e8123fdb3d4acb14040bd1a034ec354df8a7fef1b40b02cbb958221ca75b1bf9"
    sha256 cellar: :any_skip_relocation, big_sur:        "024b2143cf183f2bb0ef570145cd6dbd7aee08bd10d6e4cf89cf833dcff2fcaa"
    sha256 cellar: :any_skip_relocation, catalina:       "abdcade97c71de7c6b7d8007422ae08adf10b5a42e05f07efaa0f49f9e68a18a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fdace9f4f3bceb48a77ba3157b9577ce6b996e9496413db6f0de4725a2433fc9"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

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

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/6d/b6/44c179fdee3857af5e76ee04426cac8119ef736900a0068d12c1c018301c/asgiref-3.5.1.tar.gz"
    sha256 "fddeea3c53fa99d0cdb613c3941cc6e52d822491fc2753fba25768fb5bf4e865"
  end

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/ea/80/3d2dca1562ffa1929017c74635b4cb3645a352588de89e90d0bb53af3317/bottle-0.12.19.tar.gz"
    sha256 "a9d73ffcbc6a1345ca2d7949638db46349f5b2b77dac65d6494d45c23628da2c"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6c/ae/d26450834f0acc9e3d1f74508da6df1551ceab6c2ce0766a593362d6d57f/certifi-2021.10.8.tar.gz"
    sha256 "78884e7c1d4b00ce3cea67b44566851c4343c120abd683433ce934a68ea58872"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/56/31/7bcaf657fafb3c6db8c787a865434290b726653c912085fbd371e9b92e1c/charset-normalizer-2.0.12.tar.gz"
    sha256 "2857e29ff0d34db842cd7ca3230549d1a697f96ee6d3fb071cfa6c7393832597"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
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

  resource "marshmallow" do
    url "https://files.pythonhosted.org/packages/ef/d1/3c7c7d0ed4470c49c971cb5db4c5becdc37bd3969946bba434216c56c08c/marshmallow-3.15.0.tar.gz"
    sha256 "2aaaab4f01ef4f5a011a21319af9fce17ab13bf28a026d1252adab0e035648d5"
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
    url "https://files.pythonhosted.org/packages/a1/86/450dff4ebb201402a6dd286ffab381c6a893e9a46c00067b7db53aa5465a/starlette-0.20.0.tar.gz"
    sha256 "a500c40aba9b7729e396b0b3e4cd37fdbafbd859983a9b60a64359957024d912"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/fe/71/1df93bd59163c8084d812d166c907639646e8aac72886d563851b966bf18/typing_extensions-4.2.0.tar.gz"
    sha256 "f1c24655a0da0d1b67f07e17a5e6b2a105894e6824b92096378bb3668ef02376"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1b/a5/4eab74853625505725cefdf168f48661b2cd04e7843ab836f3f63abf81da/urllib3-1.26.9.tar.gz"
    sha256 "aabaf16477806a5e1dd19aa41f8c2b7950dd3c746362d7e3223dbe6de6ac448e"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/6d/7d/b97c120cad5fd1f66462afb0d5ddd043078f2380b89fccd8a97ef5c95b5c/uvicorn-0.17.6.tar.gz"
    sha256 "5180f9d059611747d841a4a4c4ab675edf54c8489e97f96d0583ee90ac3bfc23"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/f5/58/575e416cd024d23c52de9e17d02f4c5ef4a9c8a7258c6fc8f2b3f96f73cf/wsproto-1.1.0.tar.gz"
    sha256 "a2e56bfd5c7cd83c1369d83b5feccd6d37798b74872866e62616e0ecf111bda8"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/b0/32/242620030c197fdc984f23e956518754d062a0625154514d663685106f3c/zeroconf-0.38.6.tar.gz"
    sha256 "c98f87a9145c58ad544cf1708b5eb2f444d40cd5defc69c88eeaac0527a28795"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/pio boards ststm32")
    assert_match "ST Nucleo F401RE", output
  end
end
