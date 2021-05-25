class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.9.0.tar.gz"
  sha256 "1c3ad6f50c452920ec867c7a2759a6d53720833aed89ba4290509fc7ddd44e73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "68f339ee9f8b122d3b538c4e64bff960aab38cd464865e1f422c8a7e8a915722"
    sha256 cellar: :any_skip_relocation, big_sur:       "68ac10ea9d7ffe88274b8b6dda677ed4603f399778027bad52776bf6185814b2"
    sha256 cellar: :any_skip_relocation, catalina:      "68ac10ea9d7ffe88274b8b6dda677ed4603f399778027bad52776bf6185814b2"
    sha256 cellar: :any_skip_relocation, mojave:        "68ac10ea9d7ffe88274b8b6dda677ed4603f399778027bad52776bf6185814b2"
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
