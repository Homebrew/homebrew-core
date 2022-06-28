class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.342",
      revision: "7fd1c2e0ad0df6a3bd75b993a1620c3643e3986b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf170ce5dd762145220e49ce43019d5df2387ee5d9a98ac4676e4ffb881e4e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aaf170ce5dd762145220e49ce43019d5df2387ee5d9a98ac4676e4ffb881e4e6"
    sha256 cellar: :any_skip_relocation, monterey:       "811fb97a82a279dda73f2ad29b74c1e511d0d6eaff3030a070adb3c0e059ce90"
    sha256 cellar: :any_skip_relocation, big_sur:        "811fb97a82a279dda73f2ad29b74c1e511d0d6eaff3030a070adb3c0e059ce90"
    sha256 cellar: :any_skip_relocation, catalina:       "811fb97a82a279dda73f2ad29b74c1e511d0d6eaff3030a070adb3c0e059ce90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac974f315d1031af5f4bf10e89aee013750a1068453a6b555e9694e060a422e6"
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
