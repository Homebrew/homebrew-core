class GitRecent < Formula
  desc "See your latest local git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/v1.0.3.tar.gz"
  sha256 "2ea954f3c1cc3917ad1a0ff5cd361dff7c3f82410bd464a9f5decb0a539155ff"

  bottle :unneeded

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
