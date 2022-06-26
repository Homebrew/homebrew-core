class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.337",
      revision: "5cabbf3a1a15f01613dbf29264e4a861bc89b417"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d615117251dadcd5ee4a69713718f7dec25d1104a7efc77a7ce855e6c748e3ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d615117251dadcd5ee4a69713718f7dec25d1104a7efc77a7ce855e6c748e3ba"
    sha256 cellar: :any_skip_relocation, monterey:       "32754b76c8ed956239e11666836b82021c87133061e75d373956e3f619238bce"
    sha256 cellar: :any_skip_relocation, big_sur:        "32754b76c8ed956239e11666836b82021c87133061e75d373956e3f619238bce"
    sha256 cellar: :any_skip_relocation, catalina:       "32754b76c8ed956239e11666836b82021c87133061e75d373956e3f619238bce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b24dcdcec2718b29594bc64298860f7a232dac7739a656a6575e647abb9f1970"
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
