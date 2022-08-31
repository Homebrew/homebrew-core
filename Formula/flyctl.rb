class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.386",
      revision: "53d515b5aaa1fe396539aab985b0367994096c9c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "669ce614fb0a55566f0367704df255cda6a96fce699750465113738afa2096d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "669ce614fb0a55566f0367704df255cda6a96fce699750465113738afa2096d1"
    sha256 cellar: :any_skip_relocation, monterey:       "b97243b24c1baae8f532a591de2185e6cf44372adb7020a419e0931eaa639fa6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b97243b24c1baae8f532a591de2185e6cf44372adb7020a419e0931eaa639fa6"
    sha256 cellar: :any_skip_relocation, catalina:       "b97243b24c1baae8f532a591de2185e6cf44372adb7020a419e0931eaa639fa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8ca030f64a3239f3d911ad3186d922031aded7d24d0dc62637226f9faa53b92"
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
