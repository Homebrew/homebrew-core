class GitQuickStats < Formula
  desc "Simple and efficient way to access statistics in git."
  homepage "https://github.com/arzzen/git-quick-stats"
  url "https://github.com/arzzen/git-quick-stats/archive/1.0.3.tar.gz"
  sha256 "00d827ca2d51aa752149342bbd294e5bbba329a67679b9c915cc79e6fd8184a4"

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
