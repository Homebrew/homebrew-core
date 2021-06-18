class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.9.1.tar.gz"
  sha256 "6fa24042e1984ff34dfef9bceda3d9f4a342e1a2ac28c00b2033c99622e040c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d30a29f20bf7ddc412a9771cff5a86ffe14c7dedfe1392cd400ba5f7234ba2b7"
    sha256 cellar: :any_skip_relocation, big_sur:       "f7fed9b688d2c6128d4a4d2ce2d301cabb78f02dffb9d94476e61eaf507f0254"
    sha256 cellar: :any_skip_relocation, catalina:      "f7fed9b688d2c6128d4a4d2ce2d301cabb78f02dffb9d94476e61eaf507f0254"
    sha256 cellar: :any_skip_relocation, mojave:        "f7fed9b688d2c6128d4a4d2ce2d301cabb78f02dffb9d94476e61eaf507f0254"
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
