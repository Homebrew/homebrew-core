class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/42/57/2b07dc5eb131d34a820bbc08a4437ca2ddfff7a47476bffd1822437de910/codespell-2.2.2.tar.gz"
  sha256 "c4d00c02b5a2a55661f00d5b4b3b5a710fa803ced9a9d7e45438268b099c319c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "059cc7dd356d2dbf188227a91bc16698daa98dc0949ed40c98e791602a6938d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "059cc7dd356d2dbf188227a91bc16698daa98dc0949ed40c98e791602a6938d2"
    sha256 cellar: :any_skip_relocation, monterey:       "11aee07f3b9bb98467b85a60c47aec8cf0892e5f78c9efbebe61b27d4d0aefd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "11aee07f3b9bb98467b85a60c47aec8cf0892e5f78c9efbebe61b27d4d0aefd4"
    sha256 cellar: :any_skip_relocation, catalina:       "11aee07f3b9bb98467b85a60c47aec8cf0892e5f78c9efbebe61b27d4d0aefd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fde00f2068ab44164a0010e9dfcb8cd344541dd04fb321ae915954ae1c30efa"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
