class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.379",
      revision: "86ccbd5f81cd889cfeba9fe366ae79a7ab9d3602"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "82ca523505fbbc75c98c14ed895f27c2754e6a07fef54768445cd2bad0d7d1bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82ca523505fbbc75c98c14ed895f27c2754e6a07fef54768445cd2bad0d7d1bf"
    sha256 cellar: :any_skip_relocation, monterey:       "bef37061b927c007a9c91ba2e20e3375268b360d37c2693928a4851555e94d67"
    sha256 cellar: :any_skip_relocation, big_sur:        "bef37061b927c007a9c91ba2e20e3375268b360d37c2693928a4851555e94d67"
    sha256 cellar: :any_skip_relocation, catalina:       "bef37061b927c007a9c91ba2e20e3375268b360d37c2693928a4851555e94d67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45c429fcdf656e1ca6310c0ef1e2b4a6ba03f389cf208f75c24f5ab13c3a8978"
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
