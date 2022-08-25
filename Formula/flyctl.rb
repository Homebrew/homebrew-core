class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.382",
      revision: "654d2efee76659dd0d0bf434c9cf16bf720b6b5c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88d203792b9dd52f5e867506091880b2ba4741dcc896d99beb8d17e92ac5a87c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88d203792b9dd52f5e867506091880b2ba4741dcc896d99beb8d17e92ac5a87c"
    sha256 cellar: :any_skip_relocation, monterey:       "f585e24150c3fa27a21490bbb0eb03769723a1c87e773e2b0cca657b6bdab160"
    sha256 cellar: :any_skip_relocation, big_sur:        "f585e24150c3fa27a21490bbb0eb03769723a1c87e773e2b0cca657b6bdab160"
    sha256 cellar: :any_skip_relocation, catalina:       "f585e24150c3fa27a21490bbb0eb03769723a1c87e773e2b0cca657b6bdab160"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c0d010933b0f1cc8ec7fd2d5e0488ddcf76561afa1374b0aaa163b1d6066024"
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
