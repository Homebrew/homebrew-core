class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.338",
      revision: "71aecdc4f22e944e601bd4a6d3e7df481a1fdfcf"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d23caf41e26708079ce3c773477bce2edafa6344fdde8687e019b60277d7c6d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d23caf41e26708079ce3c773477bce2edafa6344fdde8687e019b60277d7c6d3"
    sha256 cellar: :any_skip_relocation, monterey:       "e612b783c461086e170328425df6c916eeef7d49b94166aa3fa46365d90061d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e612b783c461086e170328425df6c916eeef7d49b94166aa3fa46365d90061d4"
    sha256 cellar: :any_skip_relocation, catalina:       "e612b783c461086e170328425df6c916eeef7d49b94166aa3fa46365d90061d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdc040234b20837d542254080e80bff125cac3998e27dedb3eea2f836a322347"
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
