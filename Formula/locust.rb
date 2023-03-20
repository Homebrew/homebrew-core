class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/b8/14/b3baf7d9d283121c44475b4f45afb6c8dbcdad27b92c75db1c850f199e21/locust-2.15.1.tar.gz"
  sha256 "a6307f3bf995c180f66e7caed94360b8c8ed95d64dca508614d803d5b0b39f15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "afeeeb7fce47568e0baf27d4ced80d7acef1e2ed4e022725d0b9222827217bc3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02f29adc1a5be8feb1f97317f57174d36a9b701c5409119d9bc3375789967750"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b33ff31624185f3d7a0a6adb919e0a33aabfc3b1f219baa05c67ae432b86966c"
    sha256 cellar: :any_skip_relocation, ventura:        "50c4e5c9732440cbc5904d1c1dad19c2172e12cbc548f4c613ef5fdf8773e307"
    sha256 cellar: :any_skip_relocation, monterey:       "c68bdc2230bfe8e94f6de495207ee59d6830c241729d7d5291ff504eb22f8730"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3a92c3eb747443ff81078c3a112a5247fba4f54370aec55acdd1ac455d7ff48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f22f9c48d5f1eff29d6084dcb782bd07176393a4e92b0aef47516efe5399e7b6"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/16/05/385451bc8d20a3aa1d8934b32bd65847c100849ebba397dbf6c74566b237/ConfigArgParse-1.5.3.tar.gz"
    sha256 "1b0b3cbf664ab59dada57123c81eff3d9737e0d11d8cf79e3d6eb10823f1739f"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/e8/5c/ff9047989bd995b1098d14b03013f160225db2282925b517bb4a967752ee/Flask-2.2.3.tar.gz"
    sha256 "7eb373984bf1c770023fce9db164ed0c3353cd0b53f130f4693da0ca756a2e6d"
  end

  resource "Flask-BasicAuth" do
    url "https://files.pythonhosted.org/packages/16/18/9726cac3c7cb9e5a1ac4523b3e508128136b37aadb3462c857a19318900e/Flask-BasicAuth-0.2.0.tar.gz"
    sha256 "df5ebd489dc0914c224419da059d991eb72988a01cdd4b956d52932ce7d501ff"
  end

  resource "Flask-Cors" do
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

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/dc/a1/eba11a0d4b764bc62966a565b470f8c6f38242723ba3057e9b5098678c30/msgpack-1.0.5.tar.gz"
    sha256 "c075544284eadc5cddc70f4757331d99dcbc16b2bbd4849d15f8aae4cf36d31c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/59/5b/2e1b7498b4a3118bf03b65c16dba9acbe9112f48415a16ae814894033f6a/pyzmq-25.0.1.tar.gz"
    sha256 "44a24f7ce44e70d20e2a4c9ba5af70b4611df7a4b920eed2c8e0bdd5a5af225f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "roundrobin" do
    url "https://files.pythonhosted.org/packages/38/97/6508c09e3af7eaee96e7b66a7dc7bbdbe8e6b85b8d2bbbb89612cf621bad/roundrobin-0.0.4.tar.gz"
    sha256 "7e9d19a5bd6123d99993fb935fa86d25c88bb2096e493885f61737ed0f5e9abd"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/02/3c/baaebf3235c87d61d6593467056d5a8fba7c75ac838b8d100a5e64eba7a0/Werkzeug-2.2.3.tar.gz"
    sha256 "2e1ccc9417d4da358b9de6f174e3ac094391ea1d4fbef2d667865d819dfd0afe"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/42/49/ba8610674cad200da2f9c87b5f52fdcf18b02dd743a8a1e90726803cc42f/zope.event-4.6.tar.gz"
    sha256 "81d98813046fc86cc4136e3698fee628a3282f9c320db18658c21749235fce80"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/38/6f/fbfb7dde38be7e5644bb342c4c7cdc444cd5e2ffbd70d091263b3858a8cb/zope.interface-5.5.2.tar.gz"
    sha256 "bfee1f3ff62143819499e348f5b8a7f3aa0259f9aca5e0ddae7391d059dce671"
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
