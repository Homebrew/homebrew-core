class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.35.2.tar.gz"
  sha256 "4cd001551c994dbbedc2f7c5fe647fe055e00afdd6ef54fcf1a0beed160f6cc0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16b3c212081347e048bd664df0ef53c6c6a0a10d6e83410b0398153fac3d0320"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16b3c212081347e048bd664df0ef53c6c6a0a10d6e83410b0398153fac3d0320"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd1b4882b29861e98b680df0d722c301ee641fe982da2bb7dec05cfdf14121c"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd1b4882b29861e98b680df0d722c301ee641fe982da2bb7dec05cfdf14121c"
    sha256 cellar: :any_skip_relocation, catalina:       "2cd1b4882b29861e98b680df0d722c301ee641fe982da2bb7dec05cfdf14121c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2db06fe1c97e91be72c9c4f8fe351de818d2e7ace5b5a782f9b2f68b6685bbb5"
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
    assert_match "Could not find a way to authenticate on AWS!",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
