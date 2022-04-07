class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.316",
      revision: "baa9b3ac194090f1ac04d9deeb82517148988aee"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1999bfd876b0e0a91ea1d6b2ed119fc6cb2c74164b2a49df4194f193b9946b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d1999bfd876b0e0a91ea1d6b2ed119fc6cb2c74164b2a49df4194f193b9946b8"
    sha256 cellar: :any_skip_relocation, monterey:       "fa6af4c0d27c11dbcec9a5efa10b804030cd6930cc4ef7aaae8b5ed3749a0d0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa6af4c0d27c11dbcec9a5efa10b804030cd6930cc4ef7aaae8b5ed3749a0d0c"
    sha256 cellar: :any_skip_relocation, catalina:       "fa6af4c0d27c11dbcec9a5efa10b804030cd6930cc4ef7aaae8b5ed3749a0d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aff23b0e2038c211ff2ea604d18254f857f0a4fb7d4e2a018c4f4cabb69f8b6"
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
