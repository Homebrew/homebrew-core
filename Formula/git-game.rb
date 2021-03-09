class GitGame < Formula
  desc "Game for git to guess who made which commit"
  homepage "https://github.com/jsomers/git-game"
  url "https://github.com/jsomers/git-game/archive/1.2.tar.gz"
  sha256 "d893b2c813388754c16d867cf37726cd7e73c9ccd316735aac43bf1cd3ab1412"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "git-game"
  end

  test do
    system "git", "game", "help"
  end
end
