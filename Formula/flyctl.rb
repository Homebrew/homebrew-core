class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.332",
      revision: "4d3bed4271f8a7abbdfd4b859c90e678cf06a12d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "002769ebb39c7d7941564adae3b0758e3e05a82c99e410600244c214af1d65d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "002769ebb39c7d7941564adae3b0758e3e05a82c99e410600244c214af1d65d9"
    sha256 cellar: :any_skip_relocation, monterey:       "2e7e37069e1180f7eea07801b66b0fe2059f48f9534c19dd8049825907706dce"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e7e37069e1180f7eea07801b66b0fe2059f48f9534c19dd8049825907706dce"
    sha256 cellar: :any_skip_relocation, catalina:       "2e7e37069e1180f7eea07801b66b0fe2059f48f9534c19dd8049825907706dce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c84b360e7df55e64a2c7c331b3a3f48754eea684f0e5779a4cf910b87ba233"
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
