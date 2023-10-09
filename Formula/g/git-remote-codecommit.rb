class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/6c/a0/feb4dfa42e8cb1a0bd91667233254e49696cf6618f51ad5629f6efd89dae/git-remote-codecommit-1.17.tar.gz"
  sha256 "fd4a9ba3fbd88cd455a8e2087765e415da0beaae9932d4e84010069a536de24e"
  license "Apache-2.0"
  revision 1
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ad858e57ea1e623128df76151f824e9a76793edbe6d189ec0d62d96e687fa79"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d39c660362cc0835912543e67dd16d58422a7a1b081d293e7eee18c03d7b53e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91bf27b22f0dbd2d1d786e979e4c999d3da45ceb0c889cdce23b0e99674bc45c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c64fce98dc6352af38f44c5410bc6a4d5f8d22b2fd3ef89fddcfbc9276a089b3"
    sha256 cellar: :any_skip_relocation, ventura:        "445c2b8553c8a29fb4dd7cd21f3778f4832789f1d097375088f83c18771b813c"
    sha256 cellar: :any_skip_relocation, monterey:       "a8169c42a8deb50dc86ee9b56b342894bd0c1e1cc8ac7cf65ccb2d5a72ffe47e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "799d2de7d2c06ec19be93a5150226861fb4c2ff3188bf572119814cfbe163173"
  end

  depends_on "python@3.12"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/02/d8/f7d2a1247b9430c0e8be761b4b2485930d2b45f14ec912ce0fdb4aeec348/botocore-1.31.62.tar.gz"
    sha256 "272b78ac65256b6294cb9cdb0ac484d447ad3a85642e33cb6a3b1b8afee15a4c"
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
    url "https://files.pythonhosted.org/packages/8b/00/db794bb94bf09cadb4ecd031c4295dd4e3536db4da958e20331d95f1edb7/urllib3-2.0.6.tar.gz"
    sha256 "b19e1a85d206b56d7df1d5e683df4a7725252a964e3993648dd0fb5a1c157564"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
