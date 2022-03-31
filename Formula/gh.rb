class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.7.0.tar.gz"
  sha256 "d6cd8887f22fd57d477a0e640b63f7632b345056bf01b4dfc080e1e7a8191136"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6c89eda2537f55def232192c14182ede14937ae2e0f906c07070bedb0b0503e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf4dbaebf14efa5afcdde3ecf6f0a0a19c955142ba0f243994a05ca01a94cf6a"
    sha256 cellar: :any_skip_relocation, monterey:       "b122c62851ed16f82232ea79892dbb790e71a6b5d04e6458f2c41446e86975c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "1bf231ae6fdea3c85feb6e15e6036412a3581f3da0f6e177461099a40bc79823"
    sha256 cellar: :any_skip_relocation, catalina:       "5a3a005cd5449ee492c9152da195516bcff37673b04ee781bce9cbe11f1c7dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aecf37ed802e1aa6ede4ec59a84c16077cb967a86ce9eaf1d3903f7831c4f7d7"
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
