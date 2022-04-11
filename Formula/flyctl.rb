class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.317",
      revision: "eb09289f9a7c9b519ccc19ed6506882751645d33"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f3cdba1a06b4c521c1bc3e5d02b9baf69c2fa2ed0ef43901082b49d9abdcb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03f3cdba1a06b4c521c1bc3e5d02b9baf69c2fa2ed0ef43901082b49d9abdcb6"
    sha256 cellar: :any_skip_relocation, monterey:       "dbfc278ed2c23c9169295f81babc82055c2b7560b35393a010cec1854ed0af90"
    sha256 cellar: :any_skip_relocation, big_sur:        "dbfc278ed2c23c9169295f81babc82055c2b7560b35393a010cec1854ed0af90"
    sha256 cellar: :any_skip_relocation, catalina:       "dbfc278ed2c23c9169295f81babc82055c2b7560b35393a010cec1854ed0af90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "123c57abb247614c5a382dab686fb5b55981695ae2a7a6f67169829704ed2c4d"
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

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
