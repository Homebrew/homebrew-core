class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.330",
      revision: "851f5496e6c461e7f3513d06c9dea327da3274d6"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "36fa497c3ee06170d4b90f936b85e1bdff47a91f12ec9e3d3d4ce94772be2c0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "36fa497c3ee06170d4b90f936b85e1bdff47a91f12ec9e3d3d4ce94772be2c0a"
    sha256 cellar: :any_skip_relocation, monterey:       "bc41f5f2b515fa19f3eb6b9ce167431b29419844d34cecdd3fb1d01d70609753"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc41f5f2b515fa19f3eb6b9ce167431b29419844d34cecdd3fb1d01d70609753"
    sha256 cellar: :any_skip_relocation, catalina:       "bc41f5f2b515fa19f3eb6b9ce167431b29419844d34cecdd3fb1d01d70609753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a0f092e0475596c100471b2d9d40ae3bd9a7b92b77ac6bcec54d668ec74c6a"
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
