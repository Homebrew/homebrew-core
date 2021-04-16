class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.9.1.tar.gz"
  sha256 "5fd35b156a0528ad4e8b68c7058fccf340cca08b0cabd36d872ab855476fb02e"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "34aa2b2d6202fbdf1e30b53f3d77a7ad5fc11c0a3fc7058ef3c54be536bc7c71"
    sha256 cellar: :any_skip_relocation, big_sur:       "251b314337b9de1777856b89523a0fffdfc5f1fb64c88a54a24dcec62cde10a0"
    sha256 cellar: :any_skip_relocation, catalina:      "50eaae7d2bae5686fffad8eaec91ca14b705820f247fa805041fb1279ae28270"
    sha256 cellar: :any_skip_relocation, mojave:        "bbb73de9bf39f26603d6187f4a148a62aaf6e29114bae0f164313a0dfce4a6f5"
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
