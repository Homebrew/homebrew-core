class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.17.0.tar.gz"
  sha256 "e50c84cf26b29cf0738fc960fc3afd34a0f784714c2abbc26259a34ed6ed854e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93f7811326d5f6bd1569c068c4510b8549fb2edabb0b3ea881a2a7ea6e0e8ed5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93f7811326d5f6bd1569c068c4510b8549fb2edabb0b3ea881a2a7ea6e0e8ed5"
    sha256 cellar: :any_skip_relocation, monterey:       "f69711dca11c51f7fa9b21c6459ca1f120eb881232b68e61874bc23cc88d0937"
    sha256 cellar: :any_skip_relocation, big_sur:        "f69711dca11c51f7fa9b21c6459ca1f120eb881232b68e61874bc23cc88d0937"
    sha256 cellar: :any_skip_relocation, catalina:       "f69711dca11c51f7fa9b21c6459ca1f120eb881232b68e61874bc23cc88d0937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32d6babab2f20af53df693e03746605247f444b9cea9eede8aa81604cdc14fa7"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/cloudskiff/driftctl/build.env=release
      -X github.com/cloudskiff/driftctl/pkg/version.version=v#{version}
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
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
