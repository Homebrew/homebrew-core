class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.79",
      revision: "e9e9f2c7ec75a2a8513aabb0c8a40f0bbf8b5f01"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71f60701a33c45ececc3c5024fe48e1b2e015226551f7a4951f8a849505f6056"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71f60701a33c45ececc3c5024fe48e1b2e015226551f7a4951f8a849505f6056"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "71f60701a33c45ececc3c5024fe48e1b2e015226551f7a4951f8a849505f6056"
    sha256 cellar: :any_skip_relocation, ventura:        "ad520372d3b5264172884d316b393beb711939aa13453a7d47c11fb01842613a"
    sha256 cellar: :any_skip_relocation, monterey:       "ad520372d3b5264172884d316b393beb711939aa13453a7d47c11fb01842613a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad520372d3b5264172884d316b393beb711939aa13453a7d47c11fb01842613a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "181f4f8a17355f5ea16481c0d7ef1cec65bca78d35c3305b0e4715450bde233c"
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
