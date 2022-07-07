class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.349",
      revision: "3ad573bdac4a4e6a5707d9e8d8a012ecd89abaa9"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e671a07231c778e9fc381218ae245cbe87bc723b209ef65f1aeb579631ff4191"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e671a07231c778e9fc381218ae245cbe87bc723b209ef65f1aeb579631ff4191"
    sha256 cellar: :any_skip_relocation, monterey:       "80cceca96b997f0d9bb5a5ca35822cf3d8a692e7a13e0669f5ea99b66fe5a398"
    sha256 cellar: :any_skip_relocation, big_sur:        "80cceca96b997f0d9bb5a5ca35822cf3d8a692e7a13e0669f5ea99b66fe5a398"
    sha256 cellar: :any_skip_relocation, catalina:       "80cceca96b997f0d9bb5a5ca35822cf3d8a692e7a13e0669f5ea99b66fe5a398"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f53e3bfdc1e28b1a124f3a085fd7e5fb7d677c41df2927659a4c28b53cb164a7"
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
