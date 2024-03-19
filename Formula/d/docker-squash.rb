class DockerSquash < Formula
  include Language::Python::Virtualenv

  desc "Docker image squashing tool"
  homepage "https://github.com/goldmann/docker-squash"
  url "https://files.pythonhosted.org/packages/3c/83/c0a3cee67e2af20c7c337fd7cd49b49c9a741e785e7a4c631404a03b7a00/docker-squash-1.2.0.tar.gz"
  sha256 "33120a217fa9804530d1cf8091aacc5abf9020c6bc51c5108ae80ff8625782df"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "702715dba292180f02428ccbf35380ec8b2d0811918e39acf5ae7deaac5aab5b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67f06fcb8e4b6375d7b16f2998fdec18f6b68b6b756f0d80ab7e9a0a5d130674"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d40f4879e9575e708cc31d90396e1938bccbf292babb79eb93272fc598c082df"
    sha256 cellar: :any_skip_relocation, sonoma:         "1c9b69038e0948cd87b0bd3bf754dc75a1af01380657b15c430232965dbcd5da"
    sha256 cellar: :any_skip_relocation, ventura:        "fc8c7a6f9fd3eb58603fa685b310f0585cfc040a28ead64044b317cee9bd4e2f"
    sha256 cellar: :any_skip_relocation, monterey:       "cc7f78bdea4758b2bb3ff1ccef1d04301721d756b338e9cf71d0505fa77b4a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f01b0cfe45184c12709cac5ddec452e54b1901c8670db88b3fba8482952d4c41"
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
    url "https://files.pythonhosted.org/packages/bf/3f/ea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2/idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/fb/2b/9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7b/packaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
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
