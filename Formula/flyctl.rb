class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.365",
      revision: "e135011f7a871c78cb149ca89ae7bb5407ec7789"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5272c5bc628138564030f7ed3f8fc1083ea087eb49e396b5b17e09bee9cd809"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a5272c5bc628138564030f7ed3f8fc1083ea087eb49e396b5b17e09bee9cd809"
    sha256 cellar: :any_skip_relocation, monterey:       "4e23fd7a586580c2fd26a1e607a36580ab3fe638008ebc005db849fe441e3b45"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e23fd7a586580c2fd26a1e607a36580ab3fe638008ebc005db849fe441e3b45"
    sha256 cellar: :any_skip_relocation, catalina:       "4e23fd7a586580c2fd26a1e607a36580ab3fe638008ebc005db849fe441e3b45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e669d1f098295f27d69c862bf7f0e4b2e8a39e24731e712ae9d6a4b606d2a3d0"
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
