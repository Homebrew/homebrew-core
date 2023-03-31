class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.501",
      revision: "b8d4d50bf9c141c9fd7fbcd5bdcc8799c47fed6f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "284be5446ca47556ab5464417633e6ed53fe018a82840a1586f71cc9e18e5af6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "284be5446ca47556ab5464417633e6ed53fe018a82840a1586f71cc9e18e5af6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "284be5446ca47556ab5464417633e6ed53fe018a82840a1586f71cc9e18e5af6"
    sha256 cellar: :any_skip_relocation, ventura:        "3662486dde17304bde5c7f2c30a9a53c16c55401ccdfc437e6bb43ddb12739f2"
    sha256 cellar: :any_skip_relocation, monterey:       "3662486dde17304bde5c7f2c30a9a53c16c55401ccdfc437e6bb43ddb12739f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "3662486dde17304bde5c7f2c30a9a53c16c55401ccdfc437e6bb43ddb12739f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49b3b8e45ee398f380264caf2053107e4b33c3515793ac2ddab98e1efef62c21"
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
