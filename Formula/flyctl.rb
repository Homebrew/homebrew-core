class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.417",
      revision: "3750068b861162180086413cc9a0fc4c563b0510"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fb419a221195c15d14fb0d5b7a6a6c45a3f773cef5a7ca29fb2742f601ce946"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fb419a221195c15d14fb0d5b7a6a6c45a3f773cef5a7ca29fb2742f601ce946"
    sha256 cellar: :any_skip_relocation, monterey:       "a4f661ec8992b03ae57b1466f4ed7db9d3db16ce333224cb29b38e1550e69287"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4f661ec8992b03ae57b1466f4ed7db9d3db16ce333224cb29b38e1550e69287"
    sha256 cellar: :any_skip_relocation, catalina:       "a4f661ec8992b03ae57b1466f4ed7db9d3db16ce333224cb29b38e1550e69287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "237c235f65a2cf383a4de77b24bef9efc5bedb03173cb742f5ae6c5ea63b1280"
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
