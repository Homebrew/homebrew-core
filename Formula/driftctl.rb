class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.36.0.tar.gz"
  sha256 "8bb8c30fbf39d6e2a9a91e7c725b574f5eea487d4ee1fe1fb2e9274792210f73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "470eaf851537187c46780cadf55a2af2c73986171924e89a9c6fa802599cf0f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "470eaf851537187c46780cadf55a2af2c73986171924e89a9c6fa802599cf0f9"
    sha256 cellar: :any_skip_relocation, monterey:       "438badb9043df400bacc37a423ccc46306ac30fddf66bbdf3cd19f641a26a3c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "438badb9043df400bacc37a423ccc46306ac30fddf66bbdf3cd19f641a26a3c1"
    sha256 cellar: :any_skip_relocation, catalina:       "438badb9043df400bacc37a423ccc46306ac30fddf66bbdf3cd19f641a26a3c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c57042f6202ce67f813d478aab11840767c1d1560aad29af939ee3348806ce9"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/snyk/driftctl/build.env=release
      -X github.com/snyk/driftctl/pkg/version.version=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "bash")
    (bash_completion/"driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "zsh")
    (zsh_completion/"_driftctl").write output

    output = Utils.safe_popen_read("#{bin}/driftctl", "completion", "fish")
    (fish_completion/"driftctl.fish").write output
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/driftctl version")
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
