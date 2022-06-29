class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.343",
      revision: "3b7a3a42b9b03484b167b5df40c5bc24f52a0fe1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03c7424f9fbd77996ee37c5deec676069d7395812725f7c5fdd51d0fe73d5159"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03c7424f9fbd77996ee37c5deec676069d7395812725f7c5fdd51d0fe73d5159"
    sha256 cellar: :any_skip_relocation, monterey:       "734931372298c0274d2255fb090f6cccee26135b6ce291b45ff61479d17fd041"
    sha256 cellar: :any_skip_relocation, big_sur:        "734931372298c0274d2255fb090f6cccee26135b6ce291b45ff61479d17fd041"
    sha256 cellar: :any_skip_relocation, catalina:       "734931372298c0274d2255fb090f6cccee26135b6ce291b45ff61479d17fd041"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4b4fea8cdc9f3b1c099d1ece4eabf5ed45d1029323489d6e9c9a1643ed659fc"
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
