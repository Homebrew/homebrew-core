class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.32.0.tar.gz"
  sha256 "6b1df3d7dedbb2cbf575d4d902069d1ab72b745483a5620dcdd2faebdb00e9ec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f9cb483758fcf60b3435e556f0512454397eb51365f88cc31ea988fe2ad9f4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f9cb483758fcf60b3435e556f0512454397eb51365f88cc31ea988fe2ad9f4e"
    sha256 cellar: :any_skip_relocation, monterey:       "93203ceb509ea125661246661550e097b04671baf5c4d4ddaf1ee3e8384f6e26"
    sha256 cellar: :any_skip_relocation, big_sur:        "93203ceb509ea125661246661550e097b04671baf5c4d4ddaf1ee3e8384f6e26"
    sha256 cellar: :any_skip_relocation, catalina:       "93203ceb509ea125661246661550e097b04671baf5c4d4ddaf1ee3e8384f6e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1291b0a06616f09b6a6b3d09c564df2cca3a200739183ad0b5cef77970683d8"
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
