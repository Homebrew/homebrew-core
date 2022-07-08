class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.351",
      revision: "df8c42a6f3c645374c3b41b4cc274f65ea6ded16"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99ccb029ebbd2100a605f7d0f46ac720037a6fec18424a96a1944ec4a132c0aa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99ccb029ebbd2100a605f7d0f46ac720037a6fec18424a96a1944ec4a132c0aa"
    sha256 cellar: :any_skip_relocation, monterey:       "5037705d592e94044e4ecefe61e44c0a49a1d291948dbedec660049cadebcc27"
    sha256 cellar: :any_skip_relocation, big_sur:        "5037705d592e94044e4ecefe61e44c0a49a1d291948dbedec660049cadebcc27"
    sha256 cellar: :any_skip_relocation, catalina:       "5037705d592e94044e4ecefe61e44c0a49a1d291948dbedec660049cadebcc27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12a3d272d92a04e0fe79a36487a9cebbf606ce15cdd893cbba8d59399b168aa1"
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
