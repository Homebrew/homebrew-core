class GitRecent < Formula
  desc "See your latest local git branches, formatted real fancy"
  homepage "https://github.com/paulirish/git-recent"
  url "https://github.com/paulirish/git-recent/archive/v1.0.3.tar.gz"
  sha256 "2ea954f3c1cc3917ad1a0ff5cd361dff7c3f82410bd464a9f5decb0a539155ff"

  bottle do
    cellar :any_skip_relocation
    sha256 "5e6979e23694dc1ebed5dceb5d9c8f2e3692cbdf1110960df4e333a7cb49d81a" => :sierra
    sha256 "ad6f9b78d7c5c3769218122c9858238727eca0ef98ea7a958092e0d93cd2df53" => :el_capitan
    sha256 "5e6979e23694dc1ebed5dceb5d9c8f2e3692cbdf1110960df4e333a7cb49d81a" => :yosemite
  end

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
