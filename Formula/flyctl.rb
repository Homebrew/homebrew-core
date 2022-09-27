class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.397",
      revision: "27ec42e72d8fd5d3e21ba506be1dbebabd418d7b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2c8deb6738c4b2c63f8badd640dd7ca9e54455ec2087072f74fda56cecbd3d2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2c8deb6738c4b2c63f8badd640dd7ca9e54455ec2087072f74fda56cecbd3d2"
    sha256 cellar: :any_skip_relocation, monterey:       "fec21997f24de7f927b1b2a1fbf569028ba83f6f734d478c95ec31971960f07e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fec21997f24de7f927b1b2a1fbf569028ba83f6f734d478c95ec31971960f07e"
    sha256 cellar: :any_skip_relocation, catalina:       "fec21997f24de7f927b1b2a1fbf569028ba83f6f734d478c95ec31971960f07e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26802b493ce281ed044eb242ee1ad53ae435e5b4442cc685822fa417a43aa213"
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
