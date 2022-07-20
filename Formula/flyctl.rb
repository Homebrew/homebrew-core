class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.354",
      revision: "a073eda5add1a1e069180a099ac1090be922c1ef"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "230241f0e099f2abeeb7638f8d109bdcf6503966143ce6169e49d1cd61778ec0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "230241f0e099f2abeeb7638f8d109bdcf6503966143ce6169e49d1cd61778ec0"
    sha256 cellar: :any_skip_relocation, monterey:       "6379aab3240a823c61aeabf310c5f85f305786a72edb6f2a5b416f39effc2e40"
    sha256 cellar: :any_skip_relocation, big_sur:        "6379aab3240a823c61aeabf310c5f85f305786a72edb6f2a5b416f39effc2e40"
    sha256 cellar: :any_skip_relocation, catalina:       "6379aab3240a823c61aeabf310c5f85f305786a72edb6f2a5b416f39effc2e40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd99a74acbbff798478ac2ca3bb70f8b6975bfdf804deeb7f2d5521ca4f0c25f"
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
