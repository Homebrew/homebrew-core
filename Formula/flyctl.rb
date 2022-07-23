class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.359",
      revision: "15b0f802dd455cc205592681947543b4b506d4fe"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512f5c2c720e31a24fb238657a5936013e00486c22215b968dbaae8a27260f23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "512f5c2c720e31a24fb238657a5936013e00486c22215b968dbaae8a27260f23"
    sha256 cellar: :any_skip_relocation, monterey:       "a34da1b227c735c39627b33749096490a8f77420053b6450aff00f7f52c6b5a1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a34da1b227c735c39627b33749096490a8f77420053b6450aff00f7f52c6b5a1"
    sha256 cellar: :any_skip_relocation, catalina:       "a34da1b227c735c39627b33749096490a8f77420053b6450aff00f7f52c6b5a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac74ab06e9109b4773be2a072f6cb719429ad1bec8a8829b605335e09ee6c0eb"
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
