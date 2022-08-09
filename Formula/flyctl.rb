class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.368",
      revision: "f45225c23b6d0accff416577f41ba1c0f6dd1505"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f4cfd684902c24739587dc43f973d0ed6bf3ad6a9d8f9170c7082079aa3ec61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f4cfd684902c24739587dc43f973d0ed6bf3ad6a9d8f9170c7082079aa3ec61"
    sha256 cellar: :any_skip_relocation, monterey:       "fdc357a18cf07011153e240a1ae4bbb92c75cc7cde2089ae79b7e9fa0740581a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fdc357a18cf07011153e240a1ae4bbb92c75cc7cde2089ae79b7e9fa0740581a"
    sha256 cellar: :any_skip_relocation, catalina:       "fdc357a18cf07011153e240a1ae4bbb92c75cc7cde2089ae79b7e9fa0740581a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dfe7068fda69d4f5aa1199c808960df56815d270c69c97ef1da7ab9c1a825a4"
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
