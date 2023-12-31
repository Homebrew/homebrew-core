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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d8ba20dcd9f55de970c25529a95bb3473258876b3516b187322418615f27883b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b2c9b27f956a030046be35f93002359c8eaf8c92c1408487ecd5286312e93280"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a810bab4bcbe5fbd32da4ac3453d5f9098a94adef37ad7c0640d456ed32e60f"
    sha256 cellar: :any_skip_relocation, sonoma:         "1af35d3a2e017ef480b2cfcee9330223dafefa5b6209097dcc25b3145d1f08e3"
    sha256 cellar: :any_skip_relocation, ventura:        "15e2a407d36c1731c42aec5acd172ab4cf217fa7d9a7272106bdd799a972bcc6"
    sha256 cellar: :any_skip_relocation, monterey:       "ebe4e3256b7758ff8473ecdb4287eb4422fef1bcef2154adcc9fb455a1cc4860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0c1687232860b04ae552af8b6da12096f022917ed22a246177bf834d2a25d10"
  end

  depends_on "python-dateutil"
  depends_on "python-urllib3"
  depends_on "python@3.12"
  depends_on "six"

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/42/30/e5e2126eca77baedbf51e48241c898d99784d272bcf2fb47f5a10360e555/botocore-1.31.65.tar.gz"
    sha256 "90716c6f1af97e5c2f516e9a3379767ebdddcc6cbed79b026fa5038ce4e5e43e"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "The following URL is malformed",
      pipe_output("#{bin}/git-remote-codecommit capabilities invalid 2>&1")
  end
end
