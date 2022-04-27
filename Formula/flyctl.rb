class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.324",
      revision: "dcb5132241b59a22c00ed0851ee683fb15e2ebe5"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16aec55979480fb4cf25fc3a228a686bae9537876832724c8cb78835cbd127d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16aec55979480fb4cf25fc3a228a686bae9537876832724c8cb78835cbd127d4"
    sha256 cellar: :any_skip_relocation, monterey:       "bfdc8894ad7455b74687c90e9819cb9a2574bca350e197fb0a7ec76ee3aa009b"
    sha256 cellar: :any_skip_relocation, big_sur:        "bfdc8894ad7455b74687c90e9819cb9a2574bca350e197fb0a7ec76ee3aa009b"
    sha256 cellar: :any_skip_relocation, catalina:       "bfdc8894ad7455b74687c90e9819cb9a2574bca350e197fb0a7ec76ee3aa009b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "994331ed6a65ef1db9ca1ae40f725244a5dd9b5d303c13d992821102821e538c"
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
