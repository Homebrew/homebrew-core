class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/5e/b0/53fb3017c9bfebb1d0378e23470e8d174c46760a946bad4cc9b649da412b/locust-2.37.2.tar.gz"
  sha256 "87b38964284f9f1b1b11f376bceeb6653f1c885df48c2ad8af2702ddf50c802c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b1a8f0959c887bb34e2bb70e08ea5736ad1a3f3db0fe1829f84d6d43997f16c"
    sha256 cellar: :any,                 arm64_sonoma:  "45a89ef095a29f5bfeb425b348f821534d8f56f6e7f7bc31ae56be020771e809"
    sha256 cellar: :any,                 arm64_ventura: "1b1b7a071ede35833e7bd49f34ccdf93a9b1e98a97811d66b52d5eb12069c3ca"
    sha256 cellar: :any,                 sonoma:        "59d2b0884abcb525bd2625ebf4a46ecf527e683781460891fcf27c5dcaec7fbe"
    sha256 cellar: :any,                 ventura:       "cb3f148777fe52a45a8c58148239043a9cb2bdd5f8868dbb34ff82f6f36dd8bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e600e8dcc60f339bc2af442ee4a4352ddd77e1da28649545f23d658e1fcf9b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae1ecba0127225994115f103f071ac3489badcd92fd51b4c246c020a37e2d58f"
  end

  depends_on "cmake" => :build # for pyzmq
  depends_on "ninja" => :build # for pyzmq
  depends_on "certifi"
  depends_on "python@3.13"
  depends_on "zeromq"

  resource "bidict" do
    url "https://files.pythonhosted.org/packages/9a/6e/026678aa5a830e07cd9498a05d3e7e650a4f56a42f267a53d22bcda1bdc9/bidict-0.23.1.tar.gz"
    sha256 "03069d763bc387bbd20e7d49914e75fc4132a41937fa3405417e1a5a2d006d71"
  end

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e4/33/89c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12d/charset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/cd/0f/62ca20172d4f87d93cf89665fbaedcd560ac48b465bd1d92bfc7ea6b0a41/click-8.2.0.tar.gz"
    sha256 "f5452aeddd9988eefa20f90f05ab66f17fce1ee2a36907fd30b05bbb5953814d"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/89/50/dff6380f1c7f84135484e176e0cac8690af72fa90e932ad2a0a60e28c69b/flask-3.1.0.tar.gz"
    sha256 "5f873c5184c897c8d9d1b05df1e3d01b14910ce69607a117bd3277098a5836ac"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/32/d8/667bd90d1ee41c96e938bafe81052494e70b7abd9498c4a0215c103b9667/flask_cors-5.0.1.tar.gz"
    sha256 "6ccb38d16d6b72bbc156c1c3f192bc435bfcc3c2bc864b2df1eb9b2d97b2403c"
  end

  resource "flask-login" do
    url "https://files.pythonhosted.org/packages/c3/6e/2f4e13e373bb49e68c02c51ceadd22d172715a06716f9299d9df01b6ddb2/Flask-Login-0.6.3.tar.gz"
    sha256 "5e23d14a607ef12806c699590b89d0f0e0d67baeec599d75947bf9c147330333"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/ab/75/a53f1cb732420f5e5d79b2563fc3504d22115e7ecfe7966e5cf9b3582ae7/gevent-24.11.1.tar.gz"
    sha256 "8bd1419114e9e4a3ed33a5bad766afff9a3cf765cb440a582a1b3a9bc80c1aca"
  end

  resource "geventhttpclient" do
    url "https://files.pythonhosted.org/packages/29/26/018524ea81b2021dc2fe60e1a9c3f5eb347e09a5364cdcb7b92d7e7d3c28/geventhttpclient-2.3.3.tar.gz"
    sha256 "3e74c1570d01dd09cabdfe2667fbf072520ec9bb3a31a0fd1eae3d0f43847f9b"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/34/c1/a82edae11d46c0d83481aacaa1e578fea21d94a1ef400afd734d47ad95ad/greenlet-3.2.2.tar.gz"
    sha256 "ad053d34421a2debba45aa3cc39acf454acbcd025b3fc1a9f8a0dee237abd485"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "locust-cloud" do
    url "https://files.pythonhosted.org/packages/30/65/e3dfd66ede886b5f84f7767e97539aab65946a29d4dfba41039df9933989/locust_cloud-1.21.5.tar.gz"
    sha256 "f5347c0ab7c22c151fbb9a93001c107ed3f2662584af0af9f159563df1866464"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/fe/8b/3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2/platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "python-engineio" do
    url "https://files.pythonhosted.org/packages/3c/9d/8492fbde3d4cb0e052de8a91a09754f222b5093f0342ef2dac92d60c751f/python_engineio-4.12.1.tar.gz"
    sha256 "9f2b5a645c416208a9c727254316d487252493de52bee0ff70dc29ca9210397e"
  end

  resource "python-socketio" do
    url "https://files.pythonhosted.org/packages/21/1a/396d50ccf06ee539fa758ce5623b59a9cb27637fc4b2dc07ed08bf495e77/python_socketio-5.13.0.tar.gz"
    sha256 "ac4e19a0302ae812e23b712ec8b6427ca0521f7c582d6abb096e36e24a263029"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/b1/11/b9213d25230ac18a71b39b3723494e57adebe36e066397b961657b3b41c1/pyzmq-26.4.0.tar.gz"
    sha256 "4bd13f85f80962f91a651a7356fe0472791a5f7a92f227822b5acf44795c626d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/95/32/0cc40fe41fd2adb80a2f388987f4f8db3c866c69e33e0b4c8b093fdf700e/setuptools-80.4.0.tar.gz"
    sha256 "5a78f61820bc088c8e4add52932ae6b8cf423da2aff268c23f813cfbb13b4006"
  end

  resource "simple-websocket" do
    url "https://files.pythonhosted.org/packages/b0/d4/bfa032f961103eba93de583b161f0e6a5b63cebb8f2c7d0c6e6efe1e3d2e/simple_websocket-1.1.0.tar.gz"
    sha256 "7939234e7aa067c534abdab3a9ed933ec9ce4691b0713c78acb195560aa52ae4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/e6/30/fba0d96b4b5fbf5948ed3f4681f7da2f9f64512e1d303f94b4cc174c24a5/websocket_client-1.8.0.tar.gz"
    sha256 "3239df9f44da632f96012472805d40a23281a991027ce11d2f45a6f24ac4c3da"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  resource "wsproto" do
    url "https://files.pythonhosted.org/packages/c9/4a/44d3c295350d776427904d73c189e10aeae66d7f555bb2feee16d1e4ba5a/wsproto-1.2.0.tar.gz"
    sha256 "ad565f26ecb92588a3e43bc3d96164de84cd9902482b130d0ddbaa9664a85065"
  end

  resource "zope-event" do
    url "https://files.pythonhosted.org/packages/46/c2/427f1867bb96555d1d34342f1dd97f8c420966ab564d58d18469a1db8736/zope.event-5.0.tar.gz"
    sha256 "bac440d8d9891b4068e2b5a2c5e2c9765a9df762944bda6955f96bb9b91e67cd"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/30/93/9210e7606be57a2dfc6277ac97dcc864fd8d39f142ca194fdc186d596fda/zope.interface-7.2.tar.gz"
    sha256 "8b49f1a3d1ee4cdaf5b32d2e738362c7f5e40ac8b46dd7d1a65e82a4872728fe"
  end

  def install
    # skip frontend build
    ENV["SKIP_PRE_BUILD"] = "true"

    virtualenv_install_with_resources
  end

  test do
    (testpath/"locustfile.py").write <<~PYTHON
      from locust import HttpUser, task

      class HelloWorldUser(HttpUser):
          @task
          def hello_world(self):
              self.client.get("/headers")
              self.client.get("/ip")
    PYTHON

    ENV["LOCUST_LOCUSTFILE"] = testpath/"locustfile.py"
    ENV["LOCUST_HOST"] = "http://httpbin.org"
    ENV["LOCUST_USERS"] = "2"

    system bin/"locust", "--headless", "--run-time", "3s"
  end
end
