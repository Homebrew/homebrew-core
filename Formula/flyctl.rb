class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.311",
      revision: "19d7bdfa3d345e5df060f4cc74e1674ab578202d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c34b22db7b8d3e659df722c1eb06a8a3f316862331fd1c823bff6b49bcff965"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c34b22db7b8d3e659df722c1eb06a8a3f316862331fd1c823bff6b49bcff965"
    sha256 cellar: :any_skip_relocation, monterey:       "d5350acb3fbe88ee521441a6231f288870139e1b247502f033f27d95b81728da"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5350acb3fbe88ee521441a6231f288870139e1b247502f033f27d95b81728da"
    sha256 cellar: :any_skip_relocation, catalina:       "d5350acb3fbe88ee521441a6231f288870139e1b247502f033f27d95b81728da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c30208d34f72a4ddddcb2f6b65ba7fb59ac632322d2592c98d0e4a6372c9a5f6"
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
