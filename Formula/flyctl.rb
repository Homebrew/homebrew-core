class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.378",
      revision: "e72b62b624386f21a9397190bcce227bb01cd7fc"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7569a6d6f2469f915f563f618367a17718140d535a7e7e3dd4c5d34fbcb0a2ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7569a6d6f2469f915f563f618367a17718140d535a7e7e3dd4c5d34fbcb0a2ff"
    sha256 cellar: :any_skip_relocation, monterey:       "88497065676767cd729b8f957b8adf013938d0beb2e410733db92ee56cd42a5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "88497065676767cd729b8f957b8adf013938d0beb2e410733db92ee56cd42a5c"
    sha256 cellar: :any_skip_relocation, catalina:       "88497065676767cd729b8f957b8adf013938d0beb2e410733db92ee56cd42a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4037ecde23f510e2a331a66e1453e49eeec26e6b1aad1531705aea63a1fd2217"
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
