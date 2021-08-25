class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.0.0.tar.gz"
  sha256 "5d93535395a6684dee1d9d1d3cde859addd76f56581e0111d95a9c685d582426"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3a768ea1d1c3efbd3d987084d22be74a986fb012bcca9e217ef2eeef2a8899d1"
    sha256 cellar: :any_skip_relocation, big_sur:       "9058e6c649fe788b0fe681ea48219393467e1d495a4121c6741d235ea857ae19"
    sha256 cellar: :any_skip_relocation, catalina:      "8e5805801192978681917fcaea12edaf1ff099998825b0fb8dc5b43cb08075c3"
    sha256 cellar: :any_skip_relocation, mojave:        "24f44d9b4ed8a750dcfacc0897036420942833f58bd4f8c413614cfc8dfff58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac34664fe701dc2917ae0845f2e2f445f6aacbba2648a4f917b25acd87ca6dfa"
  end

  depends_on "go" => :build

  def install
    with_env(
      "GH_VERSION" => version.to_s,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
