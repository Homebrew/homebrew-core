class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/3c/83/c0a3cee67e2af20c7c337fd7cd49b49c9a741e785e7a4c631404a03b7a00/docker-squash-1.2.0.tar.gz"
  sha256 "33120a217fa9804530d1cf8091aacc5abf9020c6bc51c5108ae80ff8625782df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22f2ed6cf69770cf124f4b34ae6acab072980f20a64ddde0dd2bcefc160d8064"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a2a1c315673a73ce47fbdaad1d2cad7cbc315bdaa13bdd97def6173d6f30987c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f1b45e5e2a61c4d05b1ca2de15cc104f4308f3f592a2fc762e053720d606f1f"
    sha256 cellar: :any_skip_relocation, sonoma:         "dcaf0e8241a2835a833aceaa6e51847fa6883b900cb507d3bf824737f4f4c0c1"
    sha256 cellar: :any_skip_relocation, ventura:        "7a7161ecc2b61741ef0a463cfe042adae1e7b73f10b7c0a6d69876dd4c14bb08"
    sha256 cellar: :any_skip_relocation, monterey:       "7a72386b0f310c257b4b6bcdcdaf8af33a0e8c648407d0da945d7ba2f53a8d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e663b2866d6c5fb9f6a4ac4f907cf482ee457e7181b3e076d1aba479f476e9cc"
  end

  depends_on "python-certifi"
  depends_on "python-packaging"
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
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/cc/abf6746cc90bc52df4ba730f301b89b3b844d6dc133cb89a01cfe2511eb9/urllib3-2.2.0.tar.gz"
    sha256 "051d961ad0c62a94e50ecf1af379c3aba230c66c710493493560c0c223c49f20"
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
