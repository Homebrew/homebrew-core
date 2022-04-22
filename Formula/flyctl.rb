class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.322",
      revision: "875c3ecf44a495b7a7ae4011b6d15cd29168fcea"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4384719f3ede504a7f408202b6f807c1cadddd3bb72807e438d21094499476ab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4384719f3ede504a7f408202b6f807c1cadddd3bb72807e438d21094499476ab"
    sha256 cellar: :any_skip_relocation, monterey:       "207e295497208e9f354d369f04051843743e3420b7acb26dd3383b29872e8044"
    sha256 cellar: :any_skip_relocation, big_sur:        "207e295497208e9f354d369f04051843743e3420b7acb26dd3383b29872e8044"
    sha256 cellar: :any_skip_relocation, catalina:       "207e295497208e9f354d369f04051843743e3420b7acb26dd3383b29872e8044"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b39432ad2706713f702ba0f8948e2642664c1380b88cc3d4dd01953828aaf49f"
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
