class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.370",
      revision: "1e6c3ed57ac23ee1a6299d18bef83b960c18b529"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "268165987bb109548cd8e4a1a443add40d54459585445f9064a795a403e92b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "268165987bb109548cd8e4a1a443add40d54459585445f9064a795a403e92b82"
    sha256 cellar: :any_skip_relocation, monterey:       "f177e588e2b8b3c8df22275c6393ce9e7aca30106a4e85bfe3b0ae5592d27f6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f177e588e2b8b3c8df22275c6393ce9e7aca30106a4e85bfe3b0ae5592d27f6a"
    sha256 cellar: :any_skip_relocation, catalina:       "f177e588e2b8b3c8df22275c6393ce9e7aca30106a4e85bfe3b0ae5592d27f6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6da35e1d64bcf004a00c8da655d9a0d20fa44a16d1fc35b2df1047ccd06e65c"
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
