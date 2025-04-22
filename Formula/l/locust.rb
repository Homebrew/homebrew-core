class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/79/21/d5aeeee74173d73d7d8d392e307ec24d8281fca69a2bf1f19199bd84c498/locust-2.35.0.tar.gz"
  sha256 "97f83e591646ca3227644cfb6d4fa590e9a3e3d791ab18b216ca98be235b9b24"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "208b6b13dd1d0c0572f2fd374b80d67cf2dae53bfcfbf43962f85a3908f87bb6"
    sha256 cellar: :any,                 arm64_sonoma:  "956885e31e74bfa3fe0b0a48d19fa36a2abd8ec2b9a5f351e4dc65351ab14ea6"
    sha256 cellar: :any,                 arm64_ventura: "448fc1a125bb47b47179580c0080d5c6d4aced4feff2f607f264fc5e13e66eca"
    sha256 cellar: :any,                 sonoma:        "e5b2ef4978c15358ee114db5ab004f6dad9f7f37120980a3518179239644e661"
    sha256 cellar: :any,                 ventura:       "f2217a8e394f6943690627a73a530f80db3b1a1f09bc432ae570e106cc7a0b8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "02ede1c92b927a5654d76792775536046f9467eff195b665f4f684586a3dbc13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4b38a2a110382824c37aca9a1fdb95c7cc94043b14df2693dd8a4257733fec7"
  end

  depends_on "cmake" => :build # for pyzmq
  depends_on "ninja" => :build # for pyzmq
  depends_on "certifi"
  depends_on "python@3.13"
  depends_on "zeromq"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/21/28/9b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ce/blinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2f/c2/f9e977608bdf958650638c3f1e28f85a1b075f075ebbe77db8555463787b/Brotli-1.1.0.tar.gz"
    sha256 "81de08ac11bcb85841e440c13611c00b67d3bf82698314928d0b676362546724"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
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
    url "https://files.pythonhosted.org/packages/b0/9c/666d8c71b18d0189cf801c0e0b31c4bfc609ac823883286045b1f3ae8994/greenlet-3.2.0.tar.gz"
    sha256 "1d2d43bd711a43db8d9b9187500e6432ddb4fafe112d082ffabca8660a9e01a7"
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

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/cb/d0/7555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4f/msgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
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
    url "https://files.pythonhosted.org/packages/a9/5a/0db4da3bc908df06e5efae42b44e75c81dd52716e10192ff36d0c1c8e379/setuptools-78.1.0.tar.gz"
    sha256 "18fd474d4a82a5f83dac888df697af65afa82dec7323d09c3e37d1f14288da54"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/8a/78/16493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0/urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/9f/69/83029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71e/werkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
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
