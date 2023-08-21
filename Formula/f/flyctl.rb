class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.80",
      revision: "b61fe0fa4ef70f2a97aac8abf0d23cb5a3d4c50e"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "424979397746cea71dc9b42b67b4c392a723062b32c5af7b32a5afd75bea55a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "424979397746cea71dc9b42b67b4c392a723062b32c5af7b32a5afd75bea55a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "424979397746cea71dc9b42b67b4c392a723062b32c5af7b32a5afd75bea55a8"
    sha256 cellar: :any_skip_relocation, ventura:        "6c8a3f03c1e0699e202eef7c362bc55e40381fcbf1377743d7e2d48b9b1448ac"
    sha256 cellar: :any_skip_relocation, monterey:       "6c8a3f03c1e0699e202eef7c362bc55e40381fcbf1377743d7e2d48b9b1448ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c8a3f03c1e0699e202eef7c362bc55e40381fcbf1377743d7e2d48b9b1448ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21a6a43431f3afa8de7a945e54a5bf9ff9c11c446c3942c225f16ccf6199531b"
  end

  # go 1.21.0 support bug report, https://github.com/superfly/flyctl/issues/2688
  depends_on "go@1.20" => :build

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

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
