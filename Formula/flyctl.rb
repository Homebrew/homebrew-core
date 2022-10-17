class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.414",
      revision: "463a8297e8c9672949d60bf96a7dddc803c26c6e"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8200b108f2e18b97c74e5da8ba3c63e204ef739315914d685f1a72b40328fbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d8200b108f2e18b97c74e5da8ba3c63e204ef739315914d685f1a72b40328fbe"
    sha256 cellar: :any_skip_relocation, monterey:       "839c00444031643cdfe6fb389f481783ea83e448a84dafaec5816cb122209df5"
    sha256 cellar: :any_skip_relocation, big_sur:        "839c00444031643cdfe6fb389f481783ea83e448a84dafaec5816cb122209df5"
    sha256 cellar: :any_skip_relocation, catalina:       "839c00444031643cdfe6fb389f481783ea83e448a84dafaec5816cb122209df5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a44802db184e59857be8026361e98b8afa34b68a8ea6b8d1832be2b16197fa5"
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
