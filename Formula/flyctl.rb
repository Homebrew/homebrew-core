class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.339",
      revision: "16683eaee58dfe371aab92fb98c21d29b0e5e4f6"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9ea9d32c9311996d5e37cdc62d736f2c28d8fe3cfff6a46335ddd1751fe1a291"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ea9d32c9311996d5e37cdc62d736f2c28d8fe3cfff6a46335ddd1751fe1a291"
    sha256 cellar: :any_skip_relocation, monterey:       "315766caf46d043a57af61511a6bf222d1c7a9d47b1ed74b3be06fffb49e5324"
    sha256 cellar: :any_skip_relocation, big_sur:        "315766caf46d043a57af61511a6bf222d1c7a9d47b1ed74b3be06fffb49e5324"
    sha256 cellar: :any_skip_relocation, catalina:       "315766caf46d043a57af61511a6bf222d1c7a9d47b1ed74b3be06fffb49e5324"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec51bc77039a36d59c41212c756c75a24293067bc4d73dcd2734a15d886389aa"
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
