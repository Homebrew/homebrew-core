class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/b8/14/b3baf7d9d283121c44475b4f45afb6c8dbcdad27b92c75db1c850f199e21/locust-2.15.1.tar.gz"
  sha256 "a6307f3bf995c180f66e7caed94360b8c8ed95d64dca508614d803d5b0b39f15"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aeae31e2386864ddff65f787d9dcdbb32de9719b3184786c36e46bebe9e62471"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44685510ece712e723b31f2fc3109339a924dd7b47f620ef7299efc1fb5f541e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "11cc0a4c139f1abb14c584948d0dc170107cdfc9decf40ccd3ee5edc337a75c8"
    sha256 cellar: :any_skip_relocation, ventura:        "74f7f4ad734920a2253f1e56ee4038ade6ba21c34fe195341ac23482fdb25d03"
    sha256 cellar: :any_skip_relocation, monterey:       "3813d5022964e22781cee962a4443421705f7fcd7d4da18746a28cc646f82dd1"
    sha256 cellar: :any_skip_relocation, big_sur:        "80355abe92bd97754fdec1de8df76a63271fc0e14cc53da5fba5f41bbf9f201a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e4451d202536956e22d4ccf12ceda385576d0853db932c7a870736da73b574c"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/e8/f9/a05287f3d5c54d20f51a235ace01f50620984bc7ca5ceee781dc645211c5/blinker-1.6.2.tar.gz"
    sha256 "4afd3de66ef3a9f8067559fb7a1cbe555c17dcbe15971b05d1b625c3e7abe213"
  end

  resource "brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "flask" do
    url "https://files.pythonhosted.org/packages/4d/00/ef81c18da32fdfcde6381c315f4b11597fb6691180a330418848efee0ae7/Flask-2.3.2.tar.gz"
    sha256 "8c2f9abd47a9e8df7f0c3f091ce9497d011dc3b31effcf4c85a6e2b50f4114ef"
  end

  resource "flask-basicauth" do
    url "https://files.pythonhosted.org/packages/16/18/9726cac3c7cb9e5a1ac4523b3e508128136b37aadb3462c857a19318900e/Flask-BasicAuth-0.2.0.tar.gz"
    sha256 "df5ebd489dc0914c224419da059d991eb72988a01cdd4b956d52932ce7d501ff"
  end

  resource "flask-cors" do
    url "https://files.pythonhosted.org/packages/cf/25/e3b2553d22ed542be807739556c69621ad2ab276ae8d5d2560f4ed20f652/Flask-Cors-3.0.10.tar.gz"
    sha256 "b60839393f3b84a0f3746f6cdca56c1ad7426aa738b70d6c61375857823181de"
  end

  resource "gevent" do
    url "https://files.pythonhosted.org/packages/9f/4a/e9e57cb9495f0c7943b1d5965c4bdd0d78bc4a433a7c96ee034b16c01520/gevent-22.10.2.tar.gz"
    sha256 "1ca01da176ee37b3527a2702f7d40dbc9ffb8cfc7be5a03bfa4f9eec45e55c46"
  end

  resource "geventhttpclient" do
    url "https://files.pythonhosted.org/packages/22/d0/619854ff9071f332bcb285d5912d9aa3c80479ef7e95b8907762ba2f3214/geventhttpclient-2.0.9.tar.gz"
    sha256 "8abc39d346e923bd6a7b405d38dd01e19146594b6304032f382eda8b0f631513"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/1e/1e/632e55a04d732c8184201238d911207682b119c35cecbb9a573a6c566731/greenlet-2.0.2.tar.gz"
    sha256 "e7c8dc13af7db097bed64a051d2dd49e9f0af495c26995c00a9ee842690d34c0"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/bf/7f/24a55c3393d54570f26fa8845e8e42e813bf1b7fb668ed5d3de76b71dbe9/pyzmq-25.0.2.tar.gz"
    sha256 "6b8c1bbb70e868dc88801aa532cae6bd4e3b5233784692b786f17ad2962e5149"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "roundrobin" do
    url "https://files.pythonhosted.org/packages/38/97/6508c09e3af7eaee96e7b66a7dc7bbdbe8e6b85b8d2bbbb89612cf621bad/roundrobin-0.0.4.tar.gz"
    sha256 "7e9d19a5bd6123d99993fb935fa86d25c88bb2096e493885f61737ed0f5e9abd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  resource "werkzeug" do
    url "https://files.pythonhosted.org/packages/2d/bf/5a00bb4a70028f7c6000bc9394492154fa9ae3f5226187e3ddcd0aa5eca1/Werkzeug-2.3.4.tar.gz"
    sha256 "1d5a58e0377d1fe39d061a5de4469e414e78ccb1e1e59c0f5ad6fa1c36c52b76"
  end

  resource "zope-event" do
    url "https://files.pythonhosted.org/packages/42/49/ba8610674cad200da2f9c87b5f52fdcf18b02dd743a8a1e90726803cc42f/zope.event-4.6.tar.gz"
    sha256 "81d98813046fc86cc4136e3698fee628a3282f9c320db18658c21749235fce80"
  end

  resource "zope-interface" do
    url "https://files.pythonhosted.org/packages/7a/62/f0d012151af1e8cc0a6c97db74b78141143425dcdf81bc7960c498e28960/zope.interface-6.0.tar.gz"
    sha256 "aab584725afd10c710b8f1e6e208dbee2d0ad009f57d674cb9d1b3964037275d"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"locustfile.py").write <<~EOS
      from locust import HttpUser, task

      class HelloWorldUser(HttpUser):
          @task
          def hello_world(self):
              self.client.get("/headers")
              self.client.get("/ip")
    EOS

    ENV["LOCUST_LOCUSTFILE"] = testpath/"locustfile.py"
    ENV["LOCUST_HOST"] = "http://httpbin.org"
    ENV["LOCUST_USERS"] = "2"

    system bin/"locust", "--headless", "--run-time", "3s"
  end
end
