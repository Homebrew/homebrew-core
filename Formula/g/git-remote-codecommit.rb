class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/6c/a0/feb4dfa42e8cb1a0bd91667233254e49696cf6618f51ad5629f6efd89dae/git-remote-codecommit-1.17.tar.gz"
  sha256 "fd4a9ba3fbd88cd455a8e2087765e415da0beaae9932d4e84010069a536de24e"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5fa7fb4190f083a0487f6cd76d81de5fff0b2de1560f3a4ed2771813c718740"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "851d49753d31c586baf66b4ae9bf2999f540949cd3f0a34991043baa096d8f64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43ee82fc6d2d60575f2b829d469f9e38117d872afa3a8d58af122848e92563f3"
    sha256 cellar: :any_skip_relocation, ventura:        "28035b9e540732924cc603921de59f82c8d47d58ada794f04868f83b13aa74fb"
    sha256 cellar: :any_skip_relocation, monterey:       "74d2eb666a5449f280e64642b401dfcd97b51f0ffbe754ebbefbc5f19090a98d"
    sha256 cellar: :any_skip_relocation, big_sur:        "32033eb6caa3f053f5af34ab88594a79d5c5386288dbd3275a4c5c02993009d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ae4a5512f35a3b453ebe79ddc4e923a987b4bd92734e8b229e56719dcdb015a"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/b8/7e/989d7fdebd245cc392995fd6720f2f7769f7caa7aac434887e54a1c6d320/botocore-1.31.35.tar.gz"
    sha256 "7e4534325262f43293a9cc9937cb3f1711365244ffde8b925a6ee862bcf30a83"
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
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
