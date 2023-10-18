class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/6c/0b/3684b7e34c46045dda03b34be50392c689b23fa8788a0c0f7daf98db35d8/docker-squash-1.1.0.tar.gz"
  sha256 "819a87bf44c575c76d8d8f15544363a7a81ca2b176d424b67b39cd2cd9acc89e"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cb889ad1ecaaf80af66a20932b55938048b59d85826c2a4a5037ff1b39a1f1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62f9702c0b00672534187216d9f87e966b9525680282ff9d18d2f94921c47ddb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1738205c1f74d5c1b8d705441cd67159f5a5d44fba131dc5f42e914a85d81a05"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb58adffdfb9187219a19b8bee75151b693c602d845b8c347bf407f45ca29569"
    sha256 cellar: :any_skip_relocation, ventura:        "4e86ff72450897b754e132b559c999a35943a6ec895bd38d894b744724ff249e"
    sha256 cellar: :any_skip_relocation, monterey:       "eb03abf57b4fb9a917165816fa97a3378c0848b445eeb8e4a2fbf1e65daa846e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da87b72818b3e22a73372cb433b28d617d61d5784308a7c1cfe0a7a71af68787"
  end

  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "docker" do
    url "https://files.pythonhosted.org/packages/f0/73/f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5e/docker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/cb/eb/19eadbb717ef032749853ef5eb1c28e9ca974711e28bccd4815913ba5546/websocket-client-1.6.4.tar.gz"
    sha256 "b3324019b3c28572086c4a319f91d1dcd44e6e11cd340232978c684a7650d0df"
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
