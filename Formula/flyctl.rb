class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.363",
      revision: "011375acd88f34db45a20de5c6d3d7353de5b447"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4b3931e7558d3b5bc82debfdd5b84d50991c25931c6d05aa857cc2fa5e37de5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4b3931e7558d3b5bc82debfdd5b84d50991c25931c6d05aa857cc2fa5e37de5"
    sha256 cellar: :any_skip_relocation, monterey:       "85dcf84e7196affb9a201d980c34d91431e42dfb143bd6521b6fca35db296a60"
    sha256 cellar: :any_skip_relocation, big_sur:        "85dcf84e7196affb9a201d980c34d91431e42dfb143bd6521b6fca35db296a60"
    sha256 cellar: :any_skip_relocation, catalina:       "85dcf84e7196affb9a201d980c34d91431e42dfb143bd6521b6fca35db296a60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "28594b4bb880fbd64c7af189ee55dce204ee905f89161990221b2497b231f223"
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
