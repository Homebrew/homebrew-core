class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/1.0.11.tar.gz"
  sha256 "b67f567e6f1dd1bb39943f31b4e9d8fc2c1c9414f91aeddc9b55c15018d9c5d5"

  bottle :unneeded

  def install
    bin.install "git-quick-stats"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats branchesByDate")
    assert_match /^Invalid argument/, shell_output("#{bin}/git-quick-stats command", 1)
  end
end
