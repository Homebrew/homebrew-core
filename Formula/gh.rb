class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.6.0.tar.gz"
  sha256 "e5dda0f214f31b523a58ed227bb837695110c2a89e24e7d3e306d017b42002a4"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1abe2683856c2c229019b63dc9355f8976c48efab05d0e1dcae873848719fae2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89e1ba5b04dabcb39eae8e978fa83ea06e635eb62b3802ddbe568aedbc0be5a8"
    sha256 cellar: :any_skip_relocation, monterey:       "8f46a47f28fe4f595161cd754c3a0e8644d4a624385544c29aa0bb61ed662f25"
    sha256 cellar: :any_skip_relocation, big_sur:        "2bf4412cb5b11b1f063118af677e1e609137172941096ee1af0974cfe507b825"
    sha256 cellar: :any_skip_relocation, catalina:       "f0330ff30e68907e7d5c034b34312d1d43c6c56a1424e604ce474958ce4cf2b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81e3856aa92db5c75d43ed3e51a255d86ff0e93afa288b9556c677b954cc951e"
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
