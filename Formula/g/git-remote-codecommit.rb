class GitRemoteCodecommit < Formula
  include Language::Python::Virtualenv

  desc "Git Remote Helper to interact with AWS CodeCommit"
  homepage "https://github.com/aws/git-remote-codecommit"
  url "https://files.pythonhosted.org/packages/6c/a0/feb4dfa42e8cb1a0bd91667233254e49696cf6618f51ad5629f6efd89dae/git-remote-codecommit-1.17.tar.gz"
  sha256 "fd4a9ba3fbd88cd455a8e2087765e415da0beaae9932d4e84010069a536de24e"
  license "Apache-2.0"
  revision 3
  head "https://github.com/aws/git-remote-codecommit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1e80c7a0305c46775c5075304d2d3a2b86a512cdaee3fc01c55430be4926fdcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1e80c7a0305c46775c5075304d2d3a2b86a512cdaee3fc01c55430be4926fdcf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e80c7a0305c46775c5075304d2d3a2b86a512cdaee3fc01c55430be4926fdcf"
    sha256 cellar: :any_skip_relocation, sonoma:         "44faea23bfd08f9c8fe52b62f1e4c189908a4135467ec68dbf3db9c271997762"
    sha256 cellar: :any_skip_relocation, ventura:        "44faea23bfd08f9c8fe52b62f1e4c189908a4135467ec68dbf3db9c271997762"
    sha256 cellar: :any_skip_relocation, monterey:       "1e80c7a0305c46775c5075304d2d3a2b86a512cdaee3fc01c55430be4926fdcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d4aa3adaf1e6b2544d85b5d19c88681761b36da46cd8c51c0b98aa70b16d281"
  end

  depends_on "python@3.12"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/9e/c9/844ad5680d847d94adb97b22c30b938ddda86f8a815d439503d4ee545484/botocore-1.34.128.tar.gz"
    sha256 "8d8e03f7c8c080ecafda72036eb3b482d649f8417c90b5dca33b7c2c47adb0c9"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
