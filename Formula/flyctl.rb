class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.353",
      revision: "a6e61fa6f6a6088b2abfa799fe701124613d6797"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16169121d80af8208ed638af80b229d474d989d5322e029864f19dfab5da228e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16169121d80af8208ed638af80b229d474d989d5322e029864f19dfab5da228e"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a6651319c3c5e0f0742b06f6488766f1de891e2b64b6f117d04ac48347c8f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1a6651319c3c5e0f0742b06f6488766f1de891e2b64b6f117d04ac48347c8f4"
    sha256 cellar: :any_skip_relocation, catalina:       "b1a6651319c3c5e0f0742b06f6488766f1de891e2b64b6f117d04ac48347c8f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b16e059b01d7cd0414f5028b478fb3263df4b42f5f7abf9e322149432a5a31"
  end

  depends_on "go" => :build

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
