class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/2c/d2/bdf76a090f4b0afe254b03333bbe7df2a26818417cbb6f646dc1888104b7/git-remote-codecommit-1.16.tar.gz"
  sha256 "f8e10cc5c177486022e4e7c2c08e671ed35ad63f3a2da1309a1f8eae7b6e69da"
  license "Apache-2.0"
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dffeba60e3eb48fbd126bab90879b080855e5cbdedb6f3e98db46d2b131bbb3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08a486ebcb944a5773b5168592e9bb0c318b0e72c5d95ae1c5d630f820ef1fb3"
    sha256 cellar: :any_skip_relocation, monterey:       "3bb9945c532d8312ae5b846df1b74ffb2f0fda5c366064d3b0d5191c2b50db25"
    sha256 cellar: :any_skip_relocation, big_sur:        "0b2a0253e95d5fe4123c139acf10650b973508de8cfabab01447b7a7cf5c63a0"
    sha256 cellar: :any_skip_relocation, catalina:       "bf85c3806faadbbafb279a3353727a34acd5ef7338d9416ebc5c8b3713bd17b0"
    sha256 cellar: :any_skip_relocation, mojave:         "320bddee12ae66769b97892ac8ea95aa78d540d1fca7cc89624e76a97a754548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4afb79abb2426287e0acedb7da22354f8885baf7afd01ed936dd722548406b3d"
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
