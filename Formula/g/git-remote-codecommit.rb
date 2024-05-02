class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/6c/a0/feb4dfa42e8cb1a0bd91667233254e49696cf6618f51ad5629f6efd89dae/git-remote-codecommit-1.17.tar.gz"
  sha256 "fd4a9ba3fbd88cd455a8e2087765e415da0beaae9932d4e84010069a536de24e"
  license "Apache-2.0"
  revision 2
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1d5c336a96fe1298c4d611911da80992e3eac31b557a617acb8e66b8b88e4efb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c99e7620a096d70ec805849d5422d6b9548d8ad0c92419c926f898d3056e0baf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c51728e7b342f52f887425f139bb6eab3665b0c01b1ae91a4099e10010d469dc"
    sha256 cellar: :any_skip_relocation, sonoma:         "5469b821f4399b31e7c6387e43ffc321fc96f6b0671d025be83c34fa9ffc5e27"
    sha256 cellar: :any_skip_relocation, ventura:        "2f55bc4e410cd2acb0ce8916b18f15a4e4f794768d22e80cbcfa97544271cd3f"
    sha256 cellar: :any_skip_relocation, monterey:       "35c1a9c3b928aaa28c93f69bac223d4e034c93735122a03ae098622ee030f2fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3b4a7162044926b1f1804c6c0f99fc3c8523d82c0642d6d00b17d850bbbb70a"
  end

  depends_on "python@3.12"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/cf/8c9516f6b1fb859e7fcb7413942b51573b54113307a92db46a44497a3b96/botocore-1.34.47.tar.gz"
    sha256 "29f1d6659602c5d79749eca7430857f7a48dd02e597d0ea4a95a83c47847993e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
