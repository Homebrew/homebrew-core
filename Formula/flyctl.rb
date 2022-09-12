class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.389",
      revision: "b82ec99e957138a3d518a29d5dc84b188c0238dd"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80095e2ce0a1fa945cb1c48d2d8819e7d3303f345f7413312a78b55f166d5dd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80095e2ce0a1fa945cb1c48d2d8819e7d3303f345f7413312a78b55f166d5dd9"
    sha256 cellar: :any_skip_relocation, monterey:       "3b9694e3b2771625a26536a7fbdf2521c8d40b4bbd9d2c8c540beaee3f9aeedf"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b9694e3b2771625a26536a7fbdf2521c8d40b4bbd9d2c8c540beaee3f9aeedf"
    sha256 cellar: :any_skip_relocation, catalina:       "3b9694e3b2771625a26536a7fbdf2521c8d40b4bbd9d2c8c540beaee3f9aeedf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9bda4d829db4f23ea181a97e7480688cb5fcb236560b4bcd2ea481794e41ac"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
