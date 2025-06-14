class GitRecent < Formula
  desc "Browse your latest git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/refs/tags/v2.0.2.tar.gz"
  sha256 "44c117f04f2ed2ac2c9146b0f11b3140cd7f1d82845eca43ed6f7155e929b052"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca4cc371dd0b4803702c639e6685352b028f2275a1c0115299c12c6a85430cf3"
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
