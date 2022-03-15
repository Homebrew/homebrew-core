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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1b37e5f0d683586a13844cf54d60ba53974b6358a29de2b0f12308f0df2c84f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a588a3be973bbc49bd3c037713a9688dc95a617734b5b5560131174121554f9"
    sha256 cellar: :any_skip_relocation, monterey:       "045e0cac75d41a91920962ed9492be496eb244c03fea6515a4d1ecab7cdfdef2"
    sha256 cellar: :any_skip_relocation, big_sur:        "516db270657d2bb61f7d33fcf8d1eddf996fab5fbce19b17c987a250aa378203"
    sha256 cellar: :any_skip_relocation, catalina:       "ce758931eba5c13b1eff7ca5933ac11239dcf383c0b9599936632b5e27faa76a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "928c73d5a730c632988ba9688fe67f755e4e379c9eee1b5043fac9d48c9191bf"
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
