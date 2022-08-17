class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.374",
      revision: "45fc204721bc0ed086245f6ce2819949a63f3559"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8b7fd8d38eea36672cfb60d7d9ee3132bcacda550d351abce055702c4d4f751"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8b7fd8d38eea36672cfb60d7d9ee3132bcacda550d351abce055702c4d4f751"
    sha256 cellar: :any_skip_relocation, monterey:       "67af4945d17f1f3d55d58123a68b6581cea7bda762570ce7714799a7ff08ab2d"
    sha256 cellar: :any_skip_relocation, big_sur:        "67af4945d17f1f3d55d58123a68b6581cea7bda762570ce7714799a7ff08ab2d"
    sha256 cellar: :any_skip_relocation, catalina:       "67af4945d17f1f3d55d58123a68b6581cea7bda762570ce7714799a7ff08ab2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e946b4400c672b41c5de6d34af23d9b84d6b3d8197626648faafb57bc5358cb8"
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
