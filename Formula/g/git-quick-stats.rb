class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.5.0.tar.gz"
  sha256 "e6cc4b2a2c981a6f3a19801340217b20b16e137bec264d1c89399612b2a9e58e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f41004b9d0cf2df23a3e08d65070745502bb6df33b0f8907412abbe042b7f534"
  end

  on_linux do
    depends_on "util-linux" # for `column`
  end

  def install
    bin.install "git-quick-stats"
    man1.install "git-quick-stats.1"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match(/^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1))
  end
end
