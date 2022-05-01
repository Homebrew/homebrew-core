class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.325",
      revision: "da2b63810fe3a6f777cf1ac06a2f431ee583fc21"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1eaf3519c28fcf9c7fd919a1259c14fb059f4e8c87d73c2ffc3f9752c63fa2cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eaf3519c28fcf9c7fd919a1259c14fb059f4e8c87d73c2ffc3f9752c63fa2cb"
    sha256 cellar: :any_skip_relocation, monterey:       "51d23c2620cd95ba98968766e20375ffc1d7d8aeb704c1bea16bff711df2bf30"
    sha256 cellar: :any_skip_relocation, big_sur:        "51d23c2620cd95ba98968766e20375ffc1d7d8aeb704c1bea16bff711df2bf30"
    sha256 cellar: :any_skip_relocation, catalina:       "51d23c2620cd95ba98968766e20375ffc1d7d8aeb704c1bea16bff711df2bf30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2b498af43a143323f2f4ca0d802823a75e9b99fa1b590faccb2801354dbbd039"
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
