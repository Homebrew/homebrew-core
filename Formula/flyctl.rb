class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.380",
      revision: "9d8897e6a6182ebc38075ecd5f5c312a38c3f1ab"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b7f78355e5cbda640e6133f802ea2e03d272d0a97b6165978875a9785713d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6b7f78355e5cbda640e6133f802ea2e03d272d0a97b6165978875a9785713d3"
    sha256 cellar: :any_skip_relocation, monterey:       "5585187782e035403a43f96b8bdac8dee89574d87481a88ace2f58e394055f15"
    sha256 cellar: :any_skip_relocation, big_sur:        "5585187782e035403a43f96b8bdac8dee89574d87481a88ace2f58e394055f15"
    sha256 cellar: :any_skip_relocation, catalina:       "5585187782e035403a43f96b8bdac8dee89574d87481a88ace2f58e394055f15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064fe2454a4c950f8e91030cb591a4aa5738f1161109f4e9e41189f0fec8a07a"
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
