class GitRecent < Formula
  desc "Browse your latest git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "6d7de03c2c18f94285671125f55d174ceea0877bc3c74d064c2759b6a895dacf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "250e1fd2e93a1b784fe5c903f68f2961795e7285599ed9ebb31fddfd73405cc6"
  end

  depends_on "fzf"

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
    system "git", "recent-og"
    # User will be 'BrewTestBot' on CI, needs to be set here to work locally
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "brew@test.bot"
    system "git", "commit", "--allow-empty", "-m", "test_commit"
    system "git", "checkout", "-b", "feature-x-branch"
    system "git", "commit", "--allow-empty", "-m", "commit on feature branch"
    system "git", "checkout", "-b", "another-branch"
    system "git", "commit", "--allow-empty", "-m", "commit on another branch"
    system "git", "checkout", "main"

    # Test git-recent-og
    assert_match(/.*main.*seconds? ago.*BrewTestBot.*test_commit/, shell_output("git recent-og"))

    # Test git-recent
    # This should select "feature-x-branch" and the script will check it out.
    with_env "GIT_RECENT_QUERY" => "x" do
      shell_output("#{bin}/git-recent")
    end
    assert_equal "feature-x-branch", shell_output("git rev-parse --abbrev-ref HEAD").strip
  end
end
