class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.377",
      revision: "3c0910719a71b8bde358a11f04fda280c3872892"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfbe3bce8233af43d999f797abdf16f3bc64b6b3d47c6525f78d8d9c00b6af74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfbe3bce8233af43d999f797abdf16f3bc64b6b3d47c6525f78d8d9c00b6af74"
    sha256 cellar: :any_skip_relocation, monterey:       "69a436f1de6849b7b716ab805fd5b54d0eb51422e93028f5364402553090506b"
    sha256 cellar: :any_skip_relocation, big_sur:        "69a436f1de6849b7b716ab805fd5b54d0eb51422e93028f5364402553090506b"
    sha256 cellar: :any_skip_relocation, catalina:       "69a436f1de6849b7b716ab805fd5b54d0eb51422e93028f5364402553090506b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8801d74ada4b80f813a218b88be2cca46a9bc3ab449fda44fde7ad1945ede6b3"
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
