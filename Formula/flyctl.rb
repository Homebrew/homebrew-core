class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.395",
      revision: "01205c00e5353dba2b0b770c9e150a9d897c97a1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "434ab633b8e711f67167fef503ce3a28c2a01f9dd92d99f98ae595e2a50a3955"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "434ab633b8e711f67167fef503ce3a28c2a01f9dd92d99f98ae595e2a50a3955"
    sha256 cellar: :any_skip_relocation, monterey:       "73b4f583de060f412545b7f75860c784c17aae92c6ba3cc88b56bf46b7ce5d76"
    sha256 cellar: :any_skip_relocation, big_sur:        "73b4f583de060f412545b7f75860c784c17aae92c6ba3cc88b56bf46b7ce5d76"
    sha256 cellar: :any_skip_relocation, catalina:       "73b4f583de060f412545b7f75860c784c17aae92c6ba3cc88b56bf46b7ce5d76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c1d42b9d825b1bb4df34d5df78596a465acee90c4705dc766e76a3fa2524cdcc"
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
