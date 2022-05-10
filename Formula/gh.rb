class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v2.10.1.tar.gz"
  sha256 "a94ba6a731ad558f7937d0ac46ff8034b56214ec9e24a9ad70296331b1bb12ed"
  license "MIT"

  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4aa659a9c6de950610168a61ca79a0f5b1cd0fb4b40abd5766d281fe0ee617a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4a1f3ba9d17a2dc5bf120fe3d1f8faa8399965abd544b1ba0c2ee3c18596916"
    sha256 cellar: :any_skip_relocation, monterey:       "ac84162e94e6033cd36a6dd7c09306b8cff60b31b0f5b2eedec964d8e83ec47a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f782d4f7c7f54947be17f3731302c150a928912d5024a1e8610d491d0628d820"
    sha256 cellar: :any_skip_relocation, catalina:       "90d095ddbb8403d3379b0b8969f2f4034034b338a261e60257c85d546e941eb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a04ae9008e82b09a5cbaedb4c3ea67849d54d209a9227ee679ca82e49fbe90d1"
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
