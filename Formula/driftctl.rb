class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.16.1.tar.gz"
  sha256 "3827a253c70ee5f18091efbff0f922c8f71e7d947c5d4e74294e33f1dfd06b88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "717e0fba0d5c399cec9c02cdaf5c02378c035d1eeabd890c388fe47b4cd2dc4c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "717e0fba0d5c399cec9c02cdaf5c02378c035d1eeabd890c388fe47b4cd2dc4c"
    sha256 cellar: :any_skip_relocation, monterey:       "cfe6627d8f5352bcf2fa45db55a8f1d68cbff0fb1d98891ac001bc074b1b9554"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfe6627d8f5352bcf2fa45db55a8f1d68cbff0fb1d98891ac001bc074b1b9554"
    sha256 cellar: :any_skip_relocation, catalina:       "cfe6627d8f5352bcf2fa45db55a8f1d68cbff0fb1d98891ac001bc074b1b9554"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03b6c6fc05c209379aa52920f9a56feca6cf4d9103b2aa53ee00da8bc1270357"
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
