class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.14.0.tar.gz"
  sha256 "1a99050644b4821477aabc7642bbcae8a19b3191e9227cd8078016d78cdd83ac"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0734b1d7fa1a09415bb35b4d9f33f2393d74a471fc82caa6a4ec2ecd1f4af257"
    sha256 cellar: :any_skip_relocation, big_sur:       "b72b8c877335fbf4f1b253b85cbafd50e852857504256a70f15b8d125f5463a5"
    sha256 cellar: :any_skip_relocation, catalina:      "c9dbf6b7b6c7d1f0e4d75f0cc31cb64afbcba47578c00348b650d0adfd49b491"
    sha256 cellar: :any_skip_relocation, mojave:        "6e3385634a45d36d3f8a6861a3eff14760076f59094a028fb9ebfb4e3ac280c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76f1e1d49901a55be51c227bb5507869e877f51d34ae23bf1877cbda913d2836"
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
