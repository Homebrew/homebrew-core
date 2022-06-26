class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.13.0.tar.gz"
  sha256 "f8bc46bda990bc9947a26f5505533b86903c96f95047b2dacf7c9534e5b86760"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e74682023de43e8cbd2a6497968fbbceff7a52f948e379a775d63ee6b2ab134a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97d16ce248d6b36bd03b9c6e95b8258806de92e8d710a7ab19a03fd920a03bdf"
    sha256 cellar: :any_skip_relocation, monterey:       "c274d927b2358909c696468880ecfa6e6e16cb556f40180560cc376e3d8e28e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "6678af620c31d59bda08fd11e88560e78fabf118df9bac29be7e8556aa05ad3b"
    sha256 cellar: :any_skip_relocation, catalina:       "8a79d795e849befa45bdaf5cd227532af5bb77063c15d4dab849feee3b60b544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd4a9ed8086815a5f6a0f80f51dde3f084fba83bc93743859469b1280d37d29c"
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
