class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.7.0.tar.gz"
  sha256 "b1f842f04b0b51d5bcf563a70e9842b38b158e24e67c474410b6027a85b43fbb"
  license "Apache-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b1570cf0fad1d8b447c3836c6554a625f10d435dda82b8f3a9ce300d85203759"
    sha256 cellar: :any_skip_relocation, big_sur:       "2f6f3d8466074e6ff69009b04863a53c5b575a85f88b27a3be9f6e9444279303"
    sha256 cellar: :any_skip_relocation, catalina:      "5aed6939f3ec8d301e100b3848e777d0825d4690419c728561799d22ba6e1e22"
    sha256 cellar: :any_skip_relocation, mojave:        "c28109541d8b1be9edcb8775003651e104db174a060c04e3091f2eaa1bd8113c"
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
