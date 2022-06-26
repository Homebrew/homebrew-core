class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.4.0.tar.gz"
  sha256 "751db1aeb06e39eaf78388b85cdf8b041de1038525e4eaae922805fdfda6da74"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "31c4f86803694c60afc6cfc49f87ead6d62b18c5f9fd3513f595c42c3aa516be"
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
