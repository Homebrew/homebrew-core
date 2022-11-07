class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/2c/d2/bdf76a090f4b0afe254b03333bbe7df2a26818417cbb6f646dc1888104b7/git-remote-codecommit-1.16.tar.gz"
  sha256 "f8e10cc5c177486022e4e7c2c08e671ed35ad63f3a2da1309a1f8eae7b6e69da"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11935d1d9fad643a0d6e57bbbd121628b8e22914c17595c3b7dc1c0fd3d31d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a2d6ee445646a01d35fbf60f863066e1878e5ad7a9f1261bfeaac34559df003"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8640252e0a83ce8f0a7b76e858b66015df078a7b56b601a0aeb103cc76270b0e"
    sha256 cellar: :any_skip_relocation, monterey:       "e39aceccb0187a96cd5ca3c91010255eda8aba9a02b23044bb559ed11498b2be"
    sha256 cellar: :any_skip_relocation, big_sur:        "d73f7e222480c99fe37d021f6df267ce5919f42ec72c697192647683c3e9d9d4"
    sha256 cellar: :any_skip_relocation, catalina:       "ab62f6c49dee5df49161d0ea44ea61fd970149dd27ec7f59fd071d0441532243"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abbcbf451250f25604fb95dadd8a1b46d7208d8d8854a112ed0ec2cbb95e589d"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/61/d0/864d19810c779c8f2cc4e64030414c2056178863c6a61d2f831ab031cc35/botocore-1.29.3.tar.gz"
    sha256 "ac7986fefe1b9c6323d381c4fdee3845c67fa53eb6c9cf586a8e8a07270dbcfe"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
