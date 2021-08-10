class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.14.0.tar.gz"
  sha256 "c5b573de08016de28bcdd95e1b0cf9a0524a5c3a97a2adfa66c66749831df3d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "905ea80d55401ee7bdb9b14d156badccc41ca4dd272647669546fcb4cb38b16e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a4b030c5bf151d80cb14f7d944ec3895b0c7e289f50d9a540caea9d5d056eb85"
    sha256 cellar: :any_skip_relocation, catalina:      "a4b030c5bf151d80cb14f7d944ec3895b0c7e289f50d9a540caea9d5d056eb85"
    sha256 cellar: :any_skip_relocation, mojave:        "a4b030c5bf151d80cb14f7d944ec3895b0c7e289f50d9a540caea9d5d056eb85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "600106c9b7e1ade10359415b43bd6ca3536baf2e93c562ff33635a86aaa898bb"
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
