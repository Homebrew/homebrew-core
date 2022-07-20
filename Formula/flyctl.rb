class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.356",
      revision: "240fbde85f6143191917932bc1d0e437b839c886"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a692a395c10708a15ad51ef5c62c1d97e3a719f32115a2914bf7c9a568a1fed8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a692a395c10708a15ad51ef5c62c1d97e3a719f32115a2914bf7c9a568a1fed8"
    sha256 cellar: :any_skip_relocation, monterey:       "48db4fb663432a8eb5fdc4353a6dd21c4e7f2b2e1d60b62ff3d70f2ee35ace25"
    sha256 cellar: :any_skip_relocation, big_sur:        "48db4fb663432a8eb5fdc4353a6dd21c4e7f2b2e1d60b62ff3d70f2ee35ace25"
    sha256 cellar: :any_skip_relocation, catalina:       "48db4fb663432a8eb5fdc4353a6dd21c4e7f2b2e1d60b62ff3d70f2ee35ace25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fd6f09308defe984a8b12d5a2ad0c46d0f8525b9ce9ae7c6558b8c4f5299822"
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
