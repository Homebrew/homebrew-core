class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.320",
      revision: "58aae1e8553414efcc6502ad07c5d61a21443e3e"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff956339df144fc2f24c2dcb5eddba8ba828e0408f34e2862863349de60011e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff956339df144fc2f24c2dcb5eddba8ba828e0408f34e2862863349de60011e2"
    sha256 cellar: :any_skip_relocation, monterey:       "16260e076063dde27718e5710e65f3180e801bcdf01ed7c94303887e7e8ecd97"
    sha256 cellar: :any_skip_relocation, big_sur:        "16260e076063dde27718e5710e65f3180e801bcdf01ed7c94303887e7e8ecd97"
    sha256 cellar: :any_skip_relocation, catalina:       "16260e076063dde27718e5710e65f3180e801bcdf01ed7c94303887e7e8ecd97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c41a43fd2f6809c0806f45b4f74b4e91a82cf33d2f85edf364328eb74e0ab18f"
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
