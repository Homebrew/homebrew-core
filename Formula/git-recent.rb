class GitRecent < Formula
  desc "See your latest local git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/v1.1.1.tar.gz"
  sha256 "790c0de09ea19948b3b0ad642d82c30ee20c8d14a04b761fa2a2f716dc19eedc"

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
