class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.381",
      revision: "ed6bc2a64cd628658dafc498cabe14450685430f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "825e59ccfce4b9fbc9bbdf65d997a4a316392f2beba54bbcd8c6a784e632b08d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "825e59ccfce4b9fbc9bbdf65d997a4a316392f2beba54bbcd8c6a784e632b08d"
    sha256 cellar: :any_skip_relocation, monterey:       "50de8bcf4f36c569f4c6ec3ad84e6b57db11ed3334545acd246c6867ccd52470"
    sha256 cellar: :any_skip_relocation, big_sur:        "50de8bcf4f36c569f4c6ec3ad84e6b57db11ed3334545acd246c6867ccd52470"
    sha256 cellar: :any_skip_relocation, catalina:       "50de8bcf4f36c569f4c6ec3ad84e6b57db11ed3334545acd246c6867ccd52470"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454512a273f72f337f875f7cf795a7ac6a9426a6508524fd7e63e6a8535aec59"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
