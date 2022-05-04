class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.29.0.tar.gz"
  sha256 "3544e2937f11bdabba65e6e32cdc1d37dd81129002138a00cb72696b10125958"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff488e59e5e53f4dd682973ba7fe1b10bb2c9502fb1a772489a4254e331dc22f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff488e59e5e53f4dd682973ba7fe1b10bb2c9502fb1a772489a4254e331dc22f"
    sha256 cellar: :any_skip_relocation, monterey:       "cbf6fde119820c020d7420e28e74eea8813dcbd0eb1ffd0696b3e5cb3e36cd75"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbf6fde119820c020d7420e28e74eea8813dcbd0eb1ffd0696b3e5cb3e36cd75"
    sha256 cellar: :any_skip_relocation, catalina:       "cbf6fde119820c020d7420e28e74eea8813dcbd0eb1ffd0696b3e5cb3e36cd75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e2addd4998da781a3318f62cdb202fa2967fc43e72cbbd8841c5d8c31496e0"
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
    assert_match "Downloading terraform provider: aws",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
