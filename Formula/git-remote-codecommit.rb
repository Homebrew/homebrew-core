class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/2c/d2/bdf76a090f4b0afe254b03333bbe7df2a26818417cbb6f646dc1888104b7/git-remote-codecommit-1.16.tar.gz"
  sha256 "f8e10cc5c177486022e4e7c2c08e671ed35ad63f3a2da1309a1f8eae7b6e69da"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2d6ee445646a01d35fbf60f863066e1878e5ad7a9f1261bfeaac34559df003"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8640252e0a83ce8f0a7b76e858b66015df078a7b56b601a0aeb103cc76270b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "e39aceccb0187a96cd5ca3c91010255eda8aba9a02b23044bb559ed11498b2be"
    sha256 cellar: :any_skip_relocation, big_sur:        "d73f7e222480c99fe37d021f6df267ce5919f42ec72c697192647683c3e9d9d4"
    sha256 cellar: :any_skip_relocation, catalina:       "ab62f6c49dee5df49161d0ea44ea61fd970149dd27ec7f59fd071d0441532243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abbcbf451250f25604fb95dadd8a1b46d7208d8d8854a112ed0ec2cbb95e589d"
  end

  depends_on "python@3.10"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/ac/96/4d5434c7e5cc0ecb69cc129edd352c3c659bfc33e1228700afc48c7228a9/botocore-1.23.20.tar.gz"
    sha256 "22e1c7b4b2b8b11d7001ca5ef2b41bda9a8be46fb3cb994a2948462666ac5ef1"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/80/be/3ee43b6c5757cabea19e75b8f46eaf05a2f5144107d7db48c7cf3a864f73/urllib3-1.26.7.tar.gz"
    sha256 "4987c65554f7a2dbf30c18fd48778ef124af6fab771a377103da0585e2336ece"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
