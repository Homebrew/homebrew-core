class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.408",
      revision: "aa078398886921a36f4e4a2392203fbaba43586b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f9667bd21705d9843a814c011454cdf6437c4c3c3d358b7d9324353e2a4f870"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f9667bd21705d9843a814c011454cdf6437c4c3c3d358b7d9324353e2a4f870"
    sha256 cellar: :any_skip_relocation, monterey:       "2a5e40774d004ad7dee2e1180bcd0f48b91869d1543cde134777569a2760d004"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a5e40774d004ad7dee2e1180bcd0f48b91869d1543cde134777569a2760d004"
    sha256 cellar: :any_skip_relocation, catalina:       "2a5e40774d004ad7dee2e1180bcd0f48b91869d1543cde134777569a2760d004"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "105017e3423adb77140e74292f4de2a0544e16d880c4dbc10fe0767b1b46b5da"
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

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
