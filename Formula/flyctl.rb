class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.352",
      revision: "6785a56300282d6b83fee4300c80c65ea0bc0f9f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "86b6994598e400e75c33704f4a59f0b6643bf4e4bb8b29c815fd363920376d83"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86b6994598e400e75c33704f4a59f0b6643bf4e4bb8b29c815fd363920376d83"
    sha256 cellar: :any_skip_relocation, monterey:       "e21c00901871105083b5ec3f4f0c2b6138211de9269b4ec45a521960033c8028"
    sha256 cellar: :any_skip_relocation, big_sur:        "e21c00901871105083b5ec3f4f0c2b6138211de9269b4ec45a521960033c8028"
    sha256 cellar: :any_skip_relocation, catalina:       "e21c00901871105083b5ec3f4f0c2b6138211de9269b4ec45a521960033c8028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fb8e794301fbbc3b8c6f1c5fe218b9f18865213565549f0f85da2f85b8cbbda"
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
