class GitStandup < Formula
  desc "Git extension to generate reports for standup meetings"
  homepage "https://github.com/kamranahmedse/git-standup"
  url "https://github.com/kamranahmedse/git-standup/archive/1.0.0.tar.gz"
  sha256 "fd3808fb8414308413248b2f47646f51ce7bf7a6b59beb257fbde2e983b60127"
  head "https://github.com/kamranahmedse/git-standup.git"

  bottle :unneeded

  def install
    bin.install "git-standup"
  end

  test do
    system "git", "standup", "--help"
  end
end
