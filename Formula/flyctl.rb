class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.311",
      revision: "19d7bdfa3d345e5df060f4cc74e1674ab578202d"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcea196f570c63f824422e62b0c84af3f3744d6240e427a958c7d0519f4d6172"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fcea196f570c63f824422e62b0c84af3f3744d6240e427a958c7d0519f4d6172"
    sha256 cellar: :any_skip_relocation, monterey:       "2cb7d8614ad18afe2f24f6ef9b969e7aa2dbedc279417bfab1002fe9f7d9b2cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cb7d8614ad18afe2f24f6ef9b969e7aa2dbedc279417bfab1002fe9f7d9b2cc"
    sha256 cellar: :any_skip_relocation, catalina:       "2cb7d8614ad18afe2f24f6ef9b969e7aa2dbedc279417bfab1002fe9f7d9b2cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14407252dd6ac664795fa3a5cc69e719319576d36ef792e0a71f3631cbe99cfa"
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
