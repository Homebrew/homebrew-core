class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.328",
      revision: "be3bfa29309d757864b565f0954aa84f1de255f2"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b833c839a3db859b536e970d53838e5955470b13aae9f7a2696ff6a3dbd60812"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b833c839a3db859b536e970d53838e5955470b13aae9f7a2696ff6a3dbd60812"
    sha256 cellar: :any_skip_relocation, monterey:       "ae53b1fa0e8107339ff9ae29c31936af57b523ec11d927bdde1236b11cc8b987"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae53b1fa0e8107339ff9ae29c31936af57b523ec11d927bdde1236b11cc8b987"
    sha256 cellar: :any_skip_relocation, catalina:       "ae53b1fa0e8107339ff9ae29c31936af57b523ec11d927bdde1236b11cc8b987"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5deab07e5bb13a2edbcc4e1be28ce637dfdbb7aa618b7efdbb2b97a8d579e90"
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
