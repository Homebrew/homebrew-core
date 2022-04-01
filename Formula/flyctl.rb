class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.312",
      revision: "66fc69d604f5d214c9c2b526d63ae0b5d1ffe0b5"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46fb5f783ca3d026afab9fdbf5739c1998f37151f5332227cb026caf900820f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "46fb5f783ca3d026afab9fdbf5739c1998f37151f5332227cb026caf900820f3"
    sha256 cellar: :any_skip_relocation, monterey:       "7eeb37c66e5cfb2c4065463840698520c7d22049eb9a39ed0fe9561f4dbb07f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eeb37c66e5cfb2c4065463840698520c7d22049eb9a39ed0fe9561f4dbb07f8"
    sha256 cellar: :any_skip_relocation, catalina:       "7eeb37c66e5cfb2c4065463840698520c7d22049eb9a39ed0fe9561f4dbb07f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4043bc06c61b7bece21d5789002a51ea6c9d0c87cf4937a5cbcbb6e693c5c18e"
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
