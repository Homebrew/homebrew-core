class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.321",
      revision: "1c1d276754c13c2c47cf2c96246ca89d7068ef80"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf875a8b6edbeb0479611e7dfbbe1b8cb553853d9e3a780a28360880f14c45eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf875a8b6edbeb0479611e7dfbbe1b8cb553853d9e3a780a28360880f14c45eb"
    sha256 cellar: :any_skip_relocation, monterey:       "0700934e0aabc0e16d65e905bc4524e8a31873605f7ba87525855f0713e7fd34"
    sha256 cellar: :any_skip_relocation, big_sur:        "0700934e0aabc0e16d65e905bc4524e8a31873605f7ba87525855f0713e7fd34"
    sha256 cellar: :any_skip_relocation, catalina:       "0700934e0aabc0e16d65e905bc4524e8a31873605f7ba87525855f0713e7fd34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f7cbe4fea0824b66a4a3372132952dc53a40b76c1193380a5ee9d9e2ce5352"
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
