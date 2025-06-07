class GitGame < Formula
  desc "Game for git to guess who made which commit"
  homepage "https://github.com/jsomers/git-game"
  url "https://github.com/jsomers/git-game/archive/refs/tags/1.3.tar.gz"
  sha256 "6670c73c2ffe2bc2255566c88f26763100bf0b24a94d3fe10d255712d2a8809e"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "fa90fff3303bfe31a09230d1a67d12fcf483e1d82be4bcacad64ce064f396338"
  end

  uses_from_macos "ruby"

  def install
    bin.install "git-game"
  end

  test do
    system "git", "game", "help"
  end
end
