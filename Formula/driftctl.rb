class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.22.0.tar.gz"
  sha256 "6790d29b0ce71da30b1a9b5e247623f5eefd19ce55a634adf988b933a3b7e7b8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98f485dd0e0d43d29555f5ae6da659ada0d83f3dbbbb1d8fbaa0c88b1832cad5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "98f485dd0e0d43d29555f5ae6da659ada0d83f3dbbbb1d8fbaa0c88b1832cad5"
    sha256 cellar: :any_skip_relocation, monterey:       "4fb2b29745e5865a416c56452b36aee62f06f7d141a610578bac81c8dd467df8"
    sha256 cellar: :any_skip_relocation, big_sur:        "4fb2b29745e5865a416c56452b36aee62f06f7d141a610578bac81c8dd467df8"
    sha256 cellar: :any_skip_relocation, catalina:       "4fb2b29745e5865a416c56452b36aee62f06f7d141a610578bac81c8dd467df8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "789b5734277a9b822ee63d6c444c365d629a1fb5e6f8bb674dfb07285df487ec"
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
