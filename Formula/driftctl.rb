class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.9.1.tar.gz"
  sha256 "6fa24042e1984ff34dfef9bceda3d9f4a342e1a2ac28c00b2033c99622e040c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a984f3f3aad094c72199841bc67efab4159aa52fc7180deef09b0847b4b15c1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "d267df2d0dee7b07d02c6eb944259719a41c3792aac6450fee3349e90b4c7a1f"
    sha256 cellar: :any_skip_relocation, catalina:      "d267df2d0dee7b07d02c6eb944259719a41c3792aac6450fee3349e90b4c7a1f"
    sha256 cellar: :any_skip_relocation, mojave:        "d267df2d0dee7b07d02c6eb944259719a41c3792aac6450fee3349e90b4c7a1f"
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
