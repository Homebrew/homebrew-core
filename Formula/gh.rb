class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.5.0.tar.gz"
  sha256 "49c42a3b951b67e29bc66e054fedb90ac2519f7e1bfc5c367e82cb173e4bb056"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "663bd535afe56f4d0cdd1a9677a1bcbf7f603805349120d4938e596beef65cfb" => :big_sur
    sha256 "46285720614f0a69645bd94265c5e1d798beaa92d41a6f3aabcf97f8747859a3" => :arm64_big_sur
    sha256 "0448e049f21a24a2ed9fe20bb5b5a5325b76570ea6faf78d50733954cc8cd715" => :catalina
    sha256 "ae889bc195283a5bf49e887dd2ba521f4c36971170941c4d6105eb76b820c40f" => :mojave
  end

  depends_on "go" => :build

  def install
    ENV["GH_VERSION"] = version.to_s
    ENV["GO_LDFLAGS"] = "-s -w"
    system "make", "bin/gh", "manpages"
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
