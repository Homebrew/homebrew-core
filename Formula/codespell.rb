class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/42/57/2b07dc5eb131d34a820bbc08a4437ca2ddfff7a47476bffd1822437de910/codespell-2.2.2.tar.gz"
  sha256 "c4d00c02b5a2a55661f00d5b4b3b5a710fa803ced9a9d7e45438268b099c319c"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61440d27339b57aee89b9a612428ac82ab38d38e258a55c8a37796849e2ca298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f70e8354454cd466c9441b81ca3d8ef9e228201ea9f4f1994ac19430fddfcf5"
    sha256 cellar: :any_skip_relocation, monterey:       "7a559ac39ab29bdf76a08bc859f5967da40d724b0260d79a6068e8db5bf0a316"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8d33af30d3c4982dc0d2920e93d5a948c7e813cf07ed7aeaa5a93770d71a88b"
    sha256 cellar: :any_skip_relocation, catalina:       "472182472754219f1e599be8025fbf87622902766f54cce2ad1c3d92353be521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add0ee88b85384f3a22ec3c4d1a0d56ec56f3cbbd4d3034b5def440a568a9b0e"
  end

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
