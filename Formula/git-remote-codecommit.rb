class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/2c/d2/bdf76a090f4b0afe254b03333bbe7df2a26818417cbb6f646dc1888104b7/git-remote-codecommit-1.16.tar.gz"
  sha256 "f8e10cc5c177486022e4e7c2c08e671ed35ad63f3a2da1309a1f8eae7b6e69da"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa3babcfd3c1322c57600ab40cf5f231c466c4b4efe40e789e5900182469681a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a3e4159b111df2c478774b19092c6c526200abd7b3015097a8f0cb5e7af8673"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ced97705990d50c77851badbba049b5772c6c23d259bcc3ac3e36ca2d58b7b75"
    sha256 cellar: :any_skip_relocation, ventura:        "c1cf2b611bbca3623840722e32c300fbd43bb8b66578312aef9e0d83e780c767"
    sha256 cellar: :any_skip_relocation, monterey:       "a700c8e7bfa15993e44e389aa082981432cb2630b6a0fc2ee5ad7948ee8d1040"
    sha256 cellar: :any_skip_relocation, big_sur:        "50d82f4816304ef6fd7a48399fe5019ca8c7eb85e9287c52cb23bfe5881ac017"
    sha256 cellar: :any_skip_relocation, catalina:       "01f8a1c497bf2aa29a0bdbcf97ca326338ffe7a956dd0e2a697c3384f5ef0c2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a00a72c0b27c905f7d2bd830dc6cb4feff9aacbbccc8039c9766943c4ca74ecf"
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
