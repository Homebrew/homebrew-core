class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.335",
      revision: "5be504ef71ad38c344916018472cca49b00202af"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41c661b8ad47bc8d63c0165a44a20ced839081c261fe7aebd70a07e6e1d1afc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f41c661b8ad47bc8d63c0165a44a20ced839081c261fe7aebd70a07e6e1d1afc"
    sha256 cellar: :any_skip_relocation, monterey:       "9bc7d340f22bb5fcdc6e72dbf3d46bd892273500eedec6a34f37bfaaf73f9f19"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bc7d340f22bb5fcdc6e72dbf3d46bd892273500eedec6a34f37bfaaf73f9f19"
    sha256 cellar: :any_skip_relocation, catalina:       "9bc7d340f22bb5fcdc6e72dbf3d46bd892273500eedec6a34f37bfaaf73f9f19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2987ec2dcea5a21c3a3c89290abfe5e7ea97c61cb8c69826a1983c6832201d5"
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
