class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.425",
      revision: "a1d61bdc68de7d5f399a08d26cdbe682e24e5627"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9cd6efc5840be60b92d58317b6cd2a0f93b6307e77f7d98b0123a218315130f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cd6efc5840be60b92d58317b6cd2a0f93b6307e77f7d98b0123a218315130f4"
    sha256 cellar: :any_skip_relocation, monterey:       "ade5d3313589cce3ad664f3dffde8a63d3093a42ec5710cdff2bd5b133888896"
    sha256 cellar: :any_skip_relocation, big_sur:        "ade5d3313589cce3ad664f3dffde8a63d3093a42ec5710cdff2bd5b133888896"
    sha256 cellar: :any_skip_relocation, catalina:       "ade5d3313589cce3ad664f3dffde8a63d3093a42ec5710cdff2bd5b133888896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d06b2ea7400856382fe10dabda337d3cb8446be1fc5f3e22220d91506dab17b5"
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
