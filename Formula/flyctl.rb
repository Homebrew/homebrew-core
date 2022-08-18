class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.375",
      revision: "d6980be10e051ef24e5b36d1784391a69b553311"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f2004d4b249d40757515f16786ae0424414d825afb016362e52a02214e2bb285"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2004d4b249d40757515f16786ae0424414d825afb016362e52a02214e2bb285"
    sha256 cellar: :any_skip_relocation, monterey:       "3b5034cd5ba4e4b2c22894cb2603ce3611e68f3bf2d73bc66f51a014fa358ab8"
    sha256 cellar: :any_skip_relocation, big_sur:        "3b5034cd5ba4e4b2c22894cb2603ce3611e68f3bf2d73bc66f51a014fa358ab8"
    sha256 cellar: :any_skip_relocation, catalina:       "3b5034cd5ba4e4b2c22894cb2603ce3611e68f3bf2d73bc66f51a014fa358ab8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6837fa9b3b38812c2ca52b29f938acaef000bf3ca5c13aa71949a55d6cb9281"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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
