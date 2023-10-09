class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/6c/0b/3684b7e34c46045dda03b34be50392c689b23fa8788a0c0f7daf98db35d8/docker-squash-1.1.0.tar.gz"
  sha256 "819a87bf44c575c76d8d8f15544363a7a81ca2b176d424b67b39cd2cd9acc89e"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2192e33e077d5d46f8224ff3a3bc6abad280e8ec019a4be3068b494dbc5de8c4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1378ee2d57a777149fa93da180174a165b85d82cd2c1e686f3aa664a7e31f165"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f9b8818aa16b4435f124e524a0dfdc9b7ee6d2c0b70a6a44f7b1fef8185493d"
    sha256 cellar: :any_skip_relocation, sonoma:         "1643c33c2dcddb68bc6a4136e45d29b02af568668f67f25f96774b2f129a52c9"
    sha256 cellar: :any_skip_relocation, ventura:        "72b86a6b8181906bca85cf8b1d0e79c0c1c2f4b7abc16f23de6b1a7df46a8be5"
    sha256 cellar: :any_skip_relocation, monterey:       "7f295aec12b06b917e5a60cea7a72dfb1da44bc51e98c00626aa7f945c06ee51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45b79a5ffbc39ca1153f75e7645639ce225dd557ac90a22ce56149edfc0a8185"
  end

  depends_on "python-certifi"
  depends_on "python-packaging"
  depends_on "python@3.11"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/44/34/551f30cbdc0515c39c2e78ef5919615785cd370844e40ada82367c1fab3f/websocket-client-1.6.3.tar.gz"
    sha256 "3aad25d31284266bcfcfd1fd8a743f63282305a364b8d0948a43bd606acc652f"
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
