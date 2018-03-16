class GitRecent < Formula
  desc "See your latest local git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/v1.0.4.tar.gz"
  sha256 "5dcf4a6b4e947b9d9174be58223d14565ad4ddf00b2b00b5830eaa891a8ed868"

  bottle :unneeded

  depends_on :macos => :sierra

  def install
    bin.install "git-recent"
  end

  test do
    system "git", "init"
    system "git", "recent"
    # User will be 'BrewTestBot' on CI, needs to be set here to work locally
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    system "git", "commit", "--allow-empty", "-m", "test_commit"
    assert_match(/.*master.*seconds? ago.*BrewTestBot.*\n.*test_commit/, shell_output("git recent"))
  end
end
