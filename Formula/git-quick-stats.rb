class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git"
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/1.0.14.tar.gz"
  sha256 "835f6a207203d8ccbf35acaa1ccb5f7de4fe2e98ff7ea72f52be7b1fbffe951c"

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
