class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://cli.github.com/"
  url "https://github.com/cli/cli/archive/refs/tags/v2.66.1.tar.gz"
  sha256 "e0bb259c61f15f41c1ca04632045d0aaf8fe456e2bc64f15dbfae41cc28d4fea"
  license "MIT"
  head "https://github.com/cli/cli.git", branch: "trunk"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "843a9faa7f54125ca2a07a38ccdb623e9d20cbd2f4493e372125acb417c5bfc2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "843a9faa7f54125ca2a07a38ccdb623e9d20cbd2f4493e372125acb417c5bfc2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "843a9faa7f54125ca2a07a38ccdb623e9d20cbd2f4493e372125acb417c5bfc2"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4dd8c897fa51347f4bec7999ceaa9a3b9864bd35bb05bb796e426281e97c078"
    sha256 cellar: :any_skip_relocation, ventura:       "9b0143990058c1851b0ac2a8f2acf9d92f817567915984f8b4cd52df216a1976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb1efaa8c4a9ea168f119d02f1dfc78fde64730b31373bda789bdbdf0d20b63e"
  end

  depends_on "go" => :build

  deny_network_access! [:postinstall, :test]

  def install
    gh_version = if build.stable?
      version.to_s
    else
      Utils.safe_popen_read("git", "describe", "--tags", "--dirty").chomp
    end

    with_env(
      "GH_VERSION" => gh_version,
      "GO_LDFLAGS" => "-s -w -X main.updaterEnabled=cli/cli",
    ) do
      system "make", "bin/gh", "manpages"
    end
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    generate_completions_from_executable(bin/"gh", "completion", "-s")
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
