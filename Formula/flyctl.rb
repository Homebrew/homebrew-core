class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.347",
      revision: "d5a5435fb09b8d7c5959a826df0f07960ae4fd14"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1fb244a53151295b5a897ad9a008e517289c5f9999ee645917153cdd706f35c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1fb244a53151295b5a897ad9a008e517289c5f9999ee645917153cdd706f35c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd394964ed5b51b0f2e9c0076e286f3b1d7fe405dc1310d4633b7e3c3c7d9b83"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd394964ed5b51b0f2e9c0076e286f3b1d7fe405dc1310d4633b7e3c3c7d9b83"
    sha256 cellar: :any_skip_relocation, catalina:       "dd394964ed5b51b0f2e9c0076e286f3b1d7fe405dc1310d4633b7e3c3c7d9b83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05c6564e03b498e0fa4eb0b38b86704e1ddcffb586fec9c07eb6971be52c643c"
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
