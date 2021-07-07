class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.12.0.tar.gz"
  sha256 "8fb57c3268c2c6a85a496b6464e438b9f8743f78b21ac1b8b13950f127aa903b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3eb7ed07e3a731c381a92fa631ddd9d94b19fb8f02a418f3ab263fadf2dc14dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "b66c7db2425bca566662a64b0beffa95d01df7c47dbef9f6d1a45a7a1efb3735"
    sha256 cellar: :any_skip_relocation, catalina:      "b66c7db2425bca566662a64b0beffa95d01df7c47dbef9f6d1a45a7a1efb3735"
    sha256 cellar: :any_skip_relocation, mojave:        "b66c7db2425bca566662a64b0beffa95d01df7c47dbef9f6d1a45a7a1efb3735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3ecfc00b6a0cd8d61996139797331a3df616c9ac4552d7f238f3dff6b20994b"
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
