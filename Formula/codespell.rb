class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/26/37/c524f1750635cb8806240013af1fd4147a60019f9a80e788759e3d2fb644/codespell-2.1.0.tar.gz"
  sha256 "19d3fe5644fef3425777e66f225a8c82d39059dcfe9edb3349a8a2cf48383ee5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4d9b687cd4c5a54e31afc47b6c4e33e06f8408fda2d8a0ccc64172b82f83d1fe"
    sha256 cellar: :any_skip_relocation, big_sur:       "bffb02505b16322acbf427d6aeaa7e0cd6dc13a62a4c6db6475a1560b98df76d"
    sha256 cellar: :any_skip_relocation, catalina:      "bffb02505b16322acbf427d6aeaa7e0cd6dc13a62a4c6db6475a1560b98df76d"
    sha256 cellar: :any_skip_relocation, mojave:        "bffb02505b16322acbf427d6aeaa7e0cd6dc13a62a4c6db6475a1560b98df76d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "000d9a448e8009aab61532ef00642afbef2baa61a70271f49793627bb9cfc5e3"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 65)
  end
end
