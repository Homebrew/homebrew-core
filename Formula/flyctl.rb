class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.357",
      revision: "bf83260b9931b2bc271c08bca2956b342bded318"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "19266318195681e83070af83026a85ed0a66f7abad93d38b985bf3b978efd360"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "19266318195681e83070af83026a85ed0a66f7abad93d38b985bf3b978efd360"
    sha256 cellar: :any_skip_relocation, monterey:       "c1db241ac11682da8f65ee030bb04a1921e19e99b0078b2ee8169e0b7d21ee4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1db241ac11682da8f65ee030bb04a1921e19e99b0078b2ee8169e0b7d21ee4e"
    sha256 cellar: :any_skip_relocation, catalina:       "c1db241ac11682da8f65ee030bb04a1921e19e99b0078b2ee8169e0b7d21ee4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "732d1acd8c724c845a3fb2984d1e6843b72184214d35a7b5ce7a23c402051e66"
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
