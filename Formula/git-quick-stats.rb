class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/2.0.8.tar.gz"
  sha256 "8413ea322382d6158835be429ac8c49ede9e5c6e8df914b6657876a08a917b04"

  bottle :unneeded

  def install
    bin.install "git-quick-stats"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats --branches-by-date")
    assert_match /^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1)
  end
end
