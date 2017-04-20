class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git."
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/1.0.5.tar.gz"
  sha256 "256633aee79896183ac783462707dbd8ade3d910a16ec2c53bc5be2870aace80"

  bottle :unneeded

  def install
    bin.install "git-quick-stats"
  end

  test do
    system "git", "init"
    assert_match "All branches (sorted by most recent commit)",
      shell_output("#{bin}/git-quick-stats branchesByDate")
    assert_match /^Invalid argument/, shell_output("#{bin}/git-quick-stats command")
  end
end
