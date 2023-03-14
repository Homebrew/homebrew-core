class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.487",
      revision: "4cc5e9abd3e32f6a97941fcce24d6568f31399bb"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49ec2d59922a0d8b6aa7fdb484021ee8f534e3af74628438ff5ec21cd85c18c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49ec2d59922a0d8b6aa7fdb484021ee8f534e3af74628438ff5ec21cd85c18c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "49ec2d59922a0d8b6aa7fdb484021ee8f534e3af74628438ff5ec21cd85c18c6"
    sha256 cellar: :any_skip_relocation, ventura:        "052dedd0f20d6cddbcf8a1e92a0c196f0f0981d52fc9abdfcdb6e2311d517083"
    sha256 cellar: :any_skip_relocation, monterey:       "052dedd0f20d6cddbcf8a1e92a0c196f0f0981d52fc9abdfcdb6e2311d517083"
    sha256 cellar: :any_skip_relocation, big_sur:        "052dedd0f20d6cddbcf8a1e92a0c196f0f0981d52fc9abdfcdb6e2311d517083"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd7e2a86bf6715a6254a7a45c6994fba1b39383d5ec9e2630d2006dd5e0f376c"
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
