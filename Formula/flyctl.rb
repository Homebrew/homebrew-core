class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.384",
      revision: "142e8bc590024cf48c9e24548cb3f6e7a3ef897f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8cd0925c5d4ac93bbdbe0db5b77c523f1f524810bd10f05b8b991a1ef1ca15e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8cd0925c5d4ac93bbdbe0db5b77c523f1f524810bd10f05b8b991a1ef1ca15e"
    sha256 cellar: :any_skip_relocation, monterey:       "0d7306dd05c91168f2a20f7bbae1ba5baf994b47a9cf002d8055bff5e65dfa9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d7306dd05c91168f2a20f7bbae1ba5baf994b47a9cf002d8055bff5e65dfa9f"
    sha256 cellar: :any_skip_relocation, catalina:       "0d7306dd05c91168f2a20f7bbae1ba5baf994b47a9cf002d8055bff5e65dfa9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "253d7822c1cca8dc0da55e75dafee973595a35ff8914c17338a796975cfcde0c"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
