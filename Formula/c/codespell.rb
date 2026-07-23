class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/80/19/45e941380f69c042b43423513d201e6592346f992394347f5e7174c31407/codespell-2.4.3.tar.gz"
  sha256 "cbe085e331227b37bb86ef8bddd08dc768c704ee9a07ca869852c093fa2793e2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3fd518b49389d83851b5319b3ef5ba58ce1c0e043efae48abb83fc392cbef75c"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/codespell --version")
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
