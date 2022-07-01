class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.346",
      revision: "e547d87efe617f5012ba5e4e6f2212ab73f4e3f2"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c6ffa16330be0d02b73cb8526828f3879b18d4373587f6bf6220e6da5cb0610"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c6ffa16330be0d02b73cb8526828f3879b18d4373587f6bf6220e6da5cb0610"
    sha256 cellar: :any_skip_relocation, monterey:       "dad3eb97e3b4292ea3aa0d797a90ab263ada4742f3331a0bc8151e3bbde7ddfd"
    sha256 cellar: :any_skip_relocation, big_sur:        "dad3eb97e3b4292ea3aa0d797a90ab263ada4742f3331a0bc8151e3bbde7ddfd"
    sha256 cellar: :any_skip_relocation, catalina:       "dad3eb97e3b4292ea3aa0d797a90ab263ada4742f3331a0bc8151e3bbde7ddfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7d3ee9eae0eef0102d3b939891eb0285c1bf39ed48d3ccc06d20e7c9ca92bdc"
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
