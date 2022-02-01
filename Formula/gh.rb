class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.5.0.tar.gz"
  sha256 "4e9d1cbcdd2346cab5b7fc176cd57c07ed3628a0241fad8a48fe4df6a354b120"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ead2616a7f6c81fce4b5f2843ce1bfce61de3b4466fde0dbf8ad8a3527cbe8bb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b62ea0af0ebbc009c9bf3bcfcf9434fa6d17a98f314c39100966a66427a3c57"
    sha256 cellar: :any_skip_relocation, monterey:       "b2b6603551177ff4b883336270978090c02ba4013e5a94a266b112c84d0a1a4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "13ef7de23ba81f1d294788733a8251bb3ac426c88b94521def2e4ac3a7270fd0"
    sha256 cellar: :any_skip_relocation, catalina:       "aac581496ca2ee409eacf1fa7885a77d55bfea561c0b16461df2a15043230752"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ed58e116befccc87e1f6d4af40633bfe44c7db00cce507b71dc0905b08aae8"
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
