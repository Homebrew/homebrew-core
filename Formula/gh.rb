class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.14.4.tar.gz"
  sha256 "be93380e5a7f2822a1bfeff80f23231ee72ca297b9bc05bba0a1c688f9f53ccf"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a58908d4c96a8133d785b39fb81d0279c3575d311a39485590bcee6535c5334d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6fcfef6a72be19fd332777372747b451370707d8a52b2905503bdf61957d02eb"
    sha256 cellar: :any_skip_relocation, monterey:       "41d7e6721726f83c944859ac684b4f6b1f1fe0de20fa8485ffd6fcd56556b8b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6b3b66960b5775645e254f016828376131447591656496e706c4e905b586281"
    sha256 cellar: :any_skip_relocation, catalina:       "0ba7cfe2a437fed202485049a030c5acf17be8ae4a7520c190b6449319529bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a5c3409e7df7d7a0eb32fe76ebccb8b128361e06f93f1f5b5796b58e84c985"
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
