class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.16.1.tar.gz"
  sha256 "3827a253c70ee5f18091efbff0f922c8f71e7d947c5d4e74294e33f1dfd06b88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1f5c563b24abd73f2e0394a2cdf54c1cec39ef3d1e9a4420921a6e01d809f14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1f5c563b24abd73f2e0394a2cdf54c1cec39ef3d1e9a4420921a6e01d809f14"
    sha256 cellar: :any_skip_relocation, monterey:       "da7f7a5ef2242c539c6bef82524b380ea8702a15562d6435737e7278e17ebb29"
    sha256 cellar: :any_skip_relocation, big_sur:        "da7f7a5ef2242c539c6bef82524b380ea8702a15562d6435737e7278e17ebb29"
    sha256 cellar: :any_skip_relocation, catalina:       "da7f7a5ef2242c539c6bef82524b380ea8702a15562d6435737e7278e17ebb29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60a519a3471a9bf597d1499ed98a6ae74f899fdf32c3d51b1187f8412651ab0e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/cloudskiff/driftctl/build.env=release
      -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}
    ].join(" ")

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
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
