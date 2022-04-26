class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.9.0.tar.gz"
  sha256 "d4aed3f4325bc518cf4af6fc7989ab35b498e42e8f97ba0e6bb07d7e3b14886a"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "735f2b60e490762c0469be0e158e7be89d31ae1c9ad28c58f25d2526d39b5bc9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "322f1e5e3ac0d07cc7726e568d32ead2588efc48d9da45fa752181d8c219cd69"
    sha256 cellar: :any_skip_relocation, monterey:       "25fef68de096bfc3ad4fda2d1c5afe0354141dfbb1be46af9b4f81e04d876518"
    sha256 cellar: :any_skip_relocation, big_sur:        "045d15df38810e3d8bc2df05fdda798d1b4b67c1155952b1c34d6056d5d1e2c6"
    sha256 cellar: :any_skip_relocation, catalina:       "5863a452e2bbec8f03aebdedf11cb39da114fa28f817996d72140686aafab473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06c2bcbab48f05808f1d22eda2c51ced920812336306d85e817990c40660e417"
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
