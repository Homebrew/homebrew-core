class GitRecent < Formula
  desc "See your latest local git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "ab9c3f5da92747f7b53f1a301b22433116ee8d204562cc8f0364f70f4a79d318"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "3a4143920243a863447daa6f2b17b3cda4e0a163e8502c6c36a910eee4ee7450"
  end

  depends_on "fzf"

  depends_on macos: :sierra

  on_linux do
    depends_on "util-linux" # for `column`
  end

  conflicts_with "git-plus", because: "both install `git-recent` binaries"

  def install
    bin.install "git-recent"
    bin.install "git-recent-og"
  end

  test do
    system "git", "init", "--initial-branch=main"
    # We are using git-recent-og, since git-recent requires user input.
    system "git", "recent-og"
    # User will be 'BrewTestBot' on CI, needs to be set here to work locally
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    system "git", "commit", "--allow-empty", "-m", "test_commit"
    assert_match(/.*main.*seconds? ago.*BrewTestBot.*test_commit/, shell_output("git recent-og"))
  end
end
