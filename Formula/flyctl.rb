class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.411",
      revision: "bf07bc29942b3791a71cb5d94c943c0ef11e1f81"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f33d040692ca1c2ecaae3c0ec77bf5f69f9f76b3439a1d1e469593575b7a2d84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f33d040692ca1c2ecaae3c0ec77bf5f69f9f76b3439a1d1e469593575b7a2d84"
    sha256 cellar: :any_skip_relocation, monterey:       "b1d2d6eefddf92dd6f2999f55417519f06e7265119eb86e71a3360a56578c896"
    sha256 cellar: :any_skip_relocation, big_sur:        "b1d2d6eefddf92dd6f2999f55417519f06e7265119eb86e71a3360a56578c896"
    sha256 cellar: :any_skip_relocation, catalina:       "b1d2d6eefddf92dd6f2999f55417519f06e7265119eb86e71a3360a56578c896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2762876c365d56fc5f1fb993810adccf2e7fcfeb74ca9468f015ef28f574544d"
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
