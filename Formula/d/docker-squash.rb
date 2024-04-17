class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/3c/83/c0a3cee67e2af20c7c337fd7cd49b49c9a741e785e7a4c631404a03b7a00/docker-squash-1.2.0.tar.gz"
  sha256 "33120a217fa9804530d1cf8091aacc5abf9020c6bc51c5108ae80ff8625782df"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bfa932abd1316f319812c252189325624a050239c973e6e5a66485930a31f86"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bfa932abd1316f319812c252189325624a050239c973e6e5a66485930a31f86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bfa932abd1316f319812c252189325624a050239c973e6e5a66485930a31f86"
    sha256 cellar: :any_skip_relocation, sonoma:         "9bfa932abd1316f319812c252189325624a050239c973e6e5a66485930a31f86"
    sha256 cellar: :any_skip_relocation, ventura:        "9bfa932abd1316f319812c252189325624a050239c973e6e5a66485930a31f86"
    sha256 cellar: :any_skip_relocation, monterey:       "9bfa932abd1316f319812c252189325624a050239c973e6e5a66485930a31f86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32f69c90868e5307a8219537171f599916ec019731f44c412fe86f7818850736"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/25/14/7d40f8f64ceca63c741ee5b5611ead4fb8d3bcaf3e6ab57d2ab0f01712bc/docker-7.0.0.tar.gz"
    sha256 "323736fb92cd9418fc5e7133bc953e11a9da04f4483f828b527db553f1e7e5a3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/7a/50/7fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79/urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "does-not-exist:1234"
    output = shell_output("#{bin}/docker-squash not_an_image 2>&1", 1)
    assert_match "Could not create Docker client", output
  end
end
