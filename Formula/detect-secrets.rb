class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/fc/79/c5d0c23c552934ba6305a30817652b4c17686cc20d9bd4f762480199b1fb/detect_secrets-1.1.0.tar.gz"
  sha256 "68250b31bc108f665f05f0ecfb34f92423280e48e65adbb887fdf721ed909627"
  license "Apache-2.0"
  revision 1
  head "https://github.com/Yelp/detect-secrets.git"

  bottle do
    sha256 cellar: :any, arm64_monterey: "c4a8923080d7b896ac352b5c13cbc18c0dd74cc56a6452e3d0bbcc759e12dad0"
    sha256 cellar: :any, arm64_big_sur:  "26c83f1239a9a4232991e8c2ac0d7aa5f2657409d647f020a549cf83af96032b"
    sha256 cellar: :any, monterey:       "78f1edcf6f4907ca46695709c13a46c58bd46098644c6ccf533fd0b3dd9edbd9"
    sha256 cellar: :any, big_sur:        "1803df0d2f14fa8eb852f84b1ccf5e7e22da6219f001d1ec5cf617d42c3a095d"
    sha256 cellar: :any, catalina:       "41e50c5f13445c03b7e3d4f0c97d357c5886011d5fc2dcc8a93e89e387a14345"
    sha256 cellar: :any, mojave:         "5feaab84d7f0c91d3453f93c019abf3abd5ec04c66d22798925ecd0b27baeeb9"
  end

  depends_on "libyaml"
  depends_on "python@3.10"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/4f/5a/597ef5911cb8919efe4d86206aa8b2658616d676a7088f0825ca08bd7cb8/urllib3-1.26.6.tar.gz"
    sha256 "f57b4c16c62fa2760b7e3d97c35b255512fb6b59a259730f36ba32ce9f8e342f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
