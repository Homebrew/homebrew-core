class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.30.0.tar.gz"
  sha256 "ee38f4d642e7b3de1aff92f310137f1abc39ffe133a5580d5826b392698b1aaf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52d291e747bdd7cb6e030483f012c6e702ee2a7d3f20bcd3b629208833786bc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "52d291e747bdd7cb6e030483f012c6e702ee2a7d3f20bcd3b629208833786bc5"
    sha256 cellar: :any_skip_relocation, monterey:       "7337687ba83656bb26c29d807c2073488df1333bb3232b097643ed0b52230b00"
    sha256 cellar: :any_skip_relocation, big_sur:        "7337687ba83656bb26c29d807c2073488df1333bb3232b097643ed0b52230b00"
    sha256 cellar: :any_skip_relocation, catalina:       "7337687ba83656bb26c29d807c2073488df1333bb3232b097643ed0b52230b00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e0706ebdebcae65eb9319f3b4c480cb2091334a1228768b2ae0b0a03f031820"
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
