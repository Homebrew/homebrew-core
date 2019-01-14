class GitRecent < Formula
  desc "See your latest local git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/v1.1.0.tar.gz"
  sha256 "71c9b28a5d6e24803e1e6252390265739cfe583d224723da1f067b6d1cc2416b"

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
