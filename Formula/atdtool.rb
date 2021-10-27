class Atdtool < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for After the Deadline language checker"
  homepage "https://github.com/lpenz/atdtool"
  url "https://files.pythonhosted.org/packages/83/d1/55150f2dd9afda92e2f0dcb697d6f555f8b1f578f1df4d685371e8b81089/atdtool-1.3.3.tar.gz"
  sha256 "a83f50e7705c65e7ba5bc339f1a0624151bba9f7cdec7fb1460bb23e9a02dab9"
  license "BSD-3-Clause"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00860b394d9167bc00b8a31a3edf07aa02ecca3434ad379d2b48e1914f0be191"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00860b394d9167bc00b8a31a3edf07aa02ecca3434ad379d2b48e1914f0be191"
    sha256 cellar: :any_skip_relocation, monterey:       "32171ec53c6f52a2e877ba0b1506be093e42f4d594418a2727675a327daef1c7"
    sha256 cellar: :any_skip_relocation, big_sur:        "32171ec53c6f52a2e877ba0b1506be093e42f4d594418a2727675a327daef1c7"
    sha256 cellar: :any_skip_relocation, catalina:       "32171ec53c6f52a2e877ba0b1506be093e42f4d594418a2727675a327daef1c7"
    sha256 cellar: :any_skip_relocation, mojave:         "32171ec53c6f52a2e877ba0b1506be093e42f4d594418a2727675a327daef1c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e982a3e891104e18964da29892efef84c79da560c3c2525467fcaa48bb28819f"
  end

  deprecate! date: "2020-11-18", because: :repo_archived

  depends_on "python@3.10"

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/atdtool", "--help"
  end
end
