class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.504",
      revision: "603f2b76a8d4bc54be5da12d2556d55827cc0fad"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a71f32baaa6ebf26f9180cf03af48678d414966c382c4fef63c735dc2032191d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a71f32baaa6ebf26f9180cf03af48678d414966c382c4fef63c735dc2032191d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a71f32baaa6ebf26f9180cf03af48678d414966c382c4fef63c735dc2032191d"
    sha256 cellar: :any_skip_relocation, ventura:        "4b56d9334a30d88739bb6323c50c7d4b64ae7f201758298f43ccfbe714e06938"
    sha256 cellar: :any_skip_relocation, monterey:       "4b56d9334a30d88739bb6323c50c7d4b64ae7f201758298f43ccfbe714e06938"
    sha256 cellar: :any_skip_relocation, big_sur:        "4b56d9334a30d88739bb6323c50c7d4b64ae7f201758298f43ccfbe714e06938"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70ead96db9b1b4e0390ace3a1fc9d68739f912102f625df5a5580a93f82e63a6"
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

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
