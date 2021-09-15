class Locust < Formula
  include Language::Python::Virtualenv

  desc "Scalable user load testing tool written in Python"
  homepage "https://locust.io/"
  url "https://files.pythonhosted.org/packages/cc/6a/58ecf10f383daedc5d6002e162ac895fbc6caa3dc680bef2470f2fba6d92/locust-2.2.1.tar.gz"
  sha256 "5d65c9b4894f2ac47ed1a4c6f330705f478ed9c8fbf9931be913390e638b3aa7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "014ebff56b25b1fa3c6a1627f847a4b135046471bdeb6830ac58c1a55131b1a4"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4232840aa56769b58a4f5254851db3c5f74fc6069e4063c51d4e91ae730f79b"
    sha256 cellar: :any_skip_relocation, catalina:      "c6bfbc56ed1b299defa5f3fb5b3f13d49596f096c7eeff073fe3014d1cb897b5"
    sha256 cellar: :any_skip_relocation, mojave:        "1d98ac97b351cff24482e45ce68582b0d1eaa6e2b2b02e2a51a1145ce182779d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17653c08ce5937dd6cbc90eea37894118484bfe405c6effdee3e4ff1c86cb4b2"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "Brotli" do
    url "https://files.pythonhosted.org/packages/2a/18/70c32fe9357f3eea18598b23aa9ed29b1711c3001835f7cf99a9818985d0/Brotli-1.0.9.zip"
    sha256 "4d1b810aa0ed773f81dceda2cc7b403d01057458730e309856356d4ef4188438"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/4e/2af0238001648ded297fb54ceb425ca26faa15b341b4fac5371d3938666e/charset-normalizer-2.0.4.tar.gz"
    sha256 "f23667ebe1084be45f6ae0538e4a5a865206544097e4e8bbcacf42cd02a348f3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "ConfigArgParse" do
    url "https://files.pythonhosted.org/packages/42/1c/3e40ae017361f30b01b391b1ee263ec93e4c2666221c69ebba297ff33be6/ConfigArgParse-1.5.2.tar.gz"
    sha256 "c39540eb4843883d526beeed912dc80c92481b0c13c9787c91e614a624de3666"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/c0/df/c516b5f38a670b6b0de604c2637ed5860db03692c2f8542fd1f60c2552a7/Flask-2.0.1.tar.gz"
    sha256 "1c4c257b1892aec1398784c63791cbaa43062f1f7aeb555c4da961b20ee68f55"
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
    url "https://files.pythonhosted.org/packages/33/2e/49317db0bbd846720ce15fd43641b17a208e6466c582ecbe845e35092ea2/gevent-21.8.0.tar.gz"
    sha256 "43e93e1a4738c922a2416baf33f0afb0a20b22d3dba886720bc037cd02a98575"
  end

  resource "geventhttpclient" do
    url "https://files.pythonhosted.org/packages/00/61/faca72f023fc488f44e54b1804846e80ba18f58b5c5e88a5b25190191d6a/geventhttpclient-1.5.1.tar.gz"
    sha256 "4aead64253d2769a6528544f7812ce8d71ae13551d079f2d9a3533d72818f2e0"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/72/7e/d8586068d47adba73afc085249712bd266cd7ffbf27d8bc260c33e9d6133/greenlet-1.1.1.tar.gz"
    sha256 "c0f22774cd8294078bdf7392ac73cf00bfa1e5e0ed644bd064fdabc5f2a2f481"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cb/38/4c4d00ddfa48abe616d7e572e02a04273603db446975ab46bbcd36552005/idna-3.2.tar.gz"
    sha256 "467fbad99067910785144ce333826c71fb0e63a425657295239737f7ecd125f3"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/58/66/d6c5859dcac92b442626427a8c7a42322068c5cd5d4a463ce78b93f730b7/itsdangerous-2.0.1.tar.gz"
    sha256 "9e724d68fc22902a1435351f84c3fb8623f303fffcc566a4cb952df8c572cff0"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  resource "msgpack" do
    url "https://files.pythonhosted.org/packages/59/04/87fc6708659c2ed3b0b6d4954f270b6e931def707b227c4554f99bd5401e/msgpack-1.0.2.tar.gz"
    sha256 "fae04496f5bc150eefad4e9571d1a76c55d021325dcd484ce45065ebbdd00984"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/e1/b0/7276de53321c12981717490516b7e612364f2cb372ee8901bd4a66a000d7/psutil-5.8.0.tar.gz"
    sha256 "0c9ccb99ab76025f2f0bbecf341d4656e9c1351db8cc8a03ccd62e318ab4b5c6"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/d6/67/98d0d6ac5c784190a0f9728410902471552cffc78cef37830cd86b9cd70d/pyzmq-22.2.1.tar.gz"
    sha256 "6d18c76676771fd891ca8e0e68da0bbfb88e30129835c0ade748016adb3b6242"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/e7/01/3569e0b535fb2e4a6c384bdbed00c55b9d78b5084e0fb7f4d0bf523d7670/requests-2.26.0.tar.gz"
    sha256 "b8aa58f8cf793ffd8782d3d8cb19e66ef36f7aba4353eec859e74678b01b07a7"
  end

  resource "roundrobin" do
    url "https://files.pythonhosted.org/packages/3e/5d/60ce8f2ad7b8c8f7124a78eead5ecfc7f702ba80d8ad1e93b25337419a75/roundrobin-0.0.2.tar.gz"
    sha256 "ac30cb78570a36bb0ce0db7b907af9394ec7a5610ece2ede072280e8dd867caa"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/e3/bd/a49e5f756b2f29010b5be321fe02478660dbf8fefea3f078493c86011b5f/Werkzeug-2.0.1.tar.gz"
    sha256 "1de1db30d010ff1af14a009224ec49ab2329ad2cde454c8a708130642d579c42"
  end

  resource "zope.event" do
    url "https://files.pythonhosted.org/packages/30/00/94ed30bfec18edbabfcbd503fcf7482c5031b0fbbc9bc361f046cb79781c/zope.event-4.5.0.tar.gz"
    sha256 "5e76517f5b9b119acf37ca8819781db6c16ea433f7e2062c4afc2b6fbedb1330"
  end

  resource "zope.interface" do
    url "https://files.pythonhosted.org/packages/ae/58/e0877f58daa69126a5fb325d6df92b20b77431cd281e189c5ec42b722f58/zope.interface-5.4.0.tar.gz"
    sha256 "5dba5f530fec3f0988d83b78cc591b58c0b6eb8431a85edd1569a0539a8a5a0e"
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
    ENV["LOCUST_HOST"] = "http://httpbin.org/"
    ENV["LOCUST_USERS"] = "2"

    system "locust", "--headless", "--run-time", "30s"
  end
end
