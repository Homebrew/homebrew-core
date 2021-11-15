class Platformio < Formula
  include Language::Python::Virtualenv

  desc "Professional collaborative platform for embedded development"
  homepage "https://platformio.org/"
  url "https://files.pythonhosted.org/packages/47/6a/b017d99d9a741466d0baf878742df22627119773041d6449809cfd2aa312/platformio-5.2.3.tar.gz"
  sha256 "94584b1cfd8cc82ee5c51cbecba57e884f906b0c3f2903b136049796d62ae86a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "641f2f3445548061bc689e9b0d06239c7a8ae5d8e2100889847625e6403c9550"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "753122571365cb9e22d0e7dc6de2b9b3481b6bbdeaf1d9b47252c69681e507f1"
    sha256 cellar: :any_skip_relocation, monterey:       "1300b9c2b2b5ffa44a9cbe4cef55054901e2a1fef5090d5f1fc0295d0b9dae54"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b313aef5b5b90e293502a66442934f8d658f390b41f77f34a017337a89aeb15"
    sha256 cellar: :any_skip_relocation, catalina:       "763f253a864454f53138e4765c7bc4fdf298ce97f031689b12f159b1ecf12c7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499e93094a637bbf377d8f081c6a40d8e465c9258d2eed41171a7138c1db38ef"
  end

  depends_on "python-tabulate"
  depends_on "python@3.9"

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/06/f0/af90f3fb4066b0707b6a5af3ffd5fd9b3809bbb52f0153a3c7550e594de3/aiofiles-0.7.0.tar.gz"
    sha256 "a1c4fc9b2ff81568c83e21392a82f344ea9d23da906e4f6a52662764545e19d4"
  end

  resource "ajsonrpc" do
    url "https://files.pythonhosted.org/packages/da/5c/95a9b83195d37620028421e00d69d598aafaa181d3e55caec485468838e1/ajsonrpc-1.2.0.tar.gz"
    sha256 "791bac18f0bf0dee109194644f151cf8b7ff529c4b8d6239ac48104a3251a19f"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/66/02/ca9061e93c487a897859e3a41f6c1a4f494038d2791382169b9a0c528175/anyio-3.3.4.tar.gz"
    sha256 "67da67b5b21f96b9d3d65daa6ea99f5d5282cb09f50eb4456f8fb51dffefc3ff"
  end

  resource "asgiref" do
    url "https://files.pythonhosted.org/packages/07/93/3618b68b4ba6b54bc97b5fd7d90e4981471edfaf51c8321a29a3c76cf47c/asgiref-3.4.1.tar.gz"
    sha256 "4ef1ab46b484e3c706329cedeff284a5d40824200638503f5768edb6de7d58e9"
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
    url "https://files.pythonhosted.org/packages/9f/c5/334c019f92c26e59637bb42bd14a190428874b2b2de75a355da394cf16c1/charset-normalizer-2.0.7.tar.gz"
    sha256 "e019de665e2bcf9c2b64e2e5aa025fa991da8720daa3c1138cadd2fd1856aed0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/bd/e9/72c3dc8f7dd7874812be6a6ec788ba1300bfe31570963a7e788c86280cb9/h11-0.12.0.tar.gz"
    sha256 "47222cb6067e4a307d535814917cd98fd0a57b6788ce715755fa2b6c28b56042"
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
    url "https://files.pythonhosted.org/packages/ee/a6/9e2ad34649f2ea933ee7a3f28a106c4ccba0cb4b2150a03f16b928184fd9/marshmallow-3.14.0.tar.gz"
    sha256 "bba1a940985c052c5cc7849f97da196ebc81f3b85ec10c56ef1f3228aa9cbe74"
  end

  resource "pyelftools" do
    url "https://files.pythonhosted.org/packages/6b/b5/f7022f2d950327ba970ec85fb8f85c79244031092c129b6f34ab17514ae0/pyelftools-0.27.tar.gz"
    sha256 "cde854e662774c5457d688ca41615f6594187ba7067af101232df889a6b7a66b"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "semantic-version" do
    url "https://files.pythonhosted.org/packages/d4/52/3be868c7ed1f408cb822bc92ce17ffe4e97d11c42caafce0589f05844dd0/semantic_version-2.8.5.tar.gz"
    sha256 "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a6/ae/44ed7978bcb1f6337a3e2bef19c941de750d73243fc9389140d62853b686/sniffio-1.2.0.tar.gz"
    sha256 "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/73/8f/8397d6abe5c491ba854164785b10bc6427b03b9299e6106407a56c90a1a2/starlette-0.17.0.tar.gz"
    sha256 "31a889e7d7bf487f70d9d197ed7efadb47fa938c58626ed93e381480833c5b84"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/3c/06/758c0ce8fe0053a86c99824c69eaabf0dacf2a0d935a9cfde18bbef9360a/uvicorn-0.15.0.tar.gz"
    sha256 "d9a3c0dd1ca86728d3e235182683b4cf94cd53a867c288eaeca80ee781b2caff"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/2b/a4/aded0882f8f1cddd68dcd531309a15bf976f301e6a3554055cc06213c227/wsproto-1.0.0.tar.gz"
    sha256 "868776f8456997ad0d9720f7322b746bbe9193751b5b290b7f924659377c8c38"
  end

  resource "zeroconf" do
    url "https://files.pythonhosted.org/packages/cc/66/4b509ea71cf2daf2e590eb1194753b26ee0a593ecbab85dcf1838bac3073/zeroconf-0.36.12.tar.gz"
    sha256 "1f1994f550abfeda10a9d5924c7e5b463213ea5ca87198da751c74995f59e780"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/pio boards ststm32")
    assert_match "ST Nucleo F401RE", output
  end
end
