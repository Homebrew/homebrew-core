class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.403",
      revision: "4386a9442af45a4b9c412f87b478accd992291df"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eb375d53cdc3415e622ee374c5741bb3b5ecf23489669377251860820aae4ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5eb375d53cdc3415e622ee374c5741bb3b5ecf23489669377251860820aae4ae"
    sha256 cellar: :any_skip_relocation, monterey:       "c1da9db82aaa988e0f42ebf8be1c6f02c5c0a10b4f56e61c9af3eb5720845c32"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1da9db82aaa988e0f42ebf8be1c6f02c5c0a10b4f56e61c9af3eb5720845c32"
    sha256 cellar: :any_skip_relocation, catalina:       "c1da9db82aaa988e0f42ebf8be1c6f02c5c0a10b4f56e61c9af3eb5720845c32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b8f931ee547a8c5745796138db92c10e6b345fb23139839c10f04e9743af14c"
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
