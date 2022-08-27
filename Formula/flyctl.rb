class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.383",
      revision: "16a17b209ab416983c70c3e3ab16ae64bf80059a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b39467bda99c5081ead38933a5f280a71074fc9e6b7d51175fd1504a863bf804"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b39467bda99c5081ead38933a5f280a71074fc9e6b7d51175fd1504a863bf804"
    sha256 cellar: :any_skip_relocation, monterey:       "eeb8a7994e868ea47a335111a0876aadbf546c9958f36c828e90faa576ae7f20"
    sha256 cellar: :any_skip_relocation, big_sur:        "eeb8a7994e868ea47a335111a0876aadbf546c9958f36c828e90faa576ae7f20"
    sha256 cellar: :any_skip_relocation, catalina:       "eeb8a7994e868ea47a335111a0876aadbf546c9958f36c828e90faa576ae7f20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11cb99d716965cc6786e4aa428b18a2850358179dee8be03fe48b9a6f4dd22de"
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
