class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.34.1.tar.gz"
  sha256 "ce1d38464ba9c4fd7173baaf276601f37fac51a798725aa4880eafe8321805dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f4d99ac685a1f936b6ee40015f400f9956c56b599342ac0430d4a48635e572a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f4d99ac685a1f936b6ee40015f400f9956c56b599342ac0430d4a48635e572a"
    sha256 cellar: :any_skip_relocation, monterey:       "ab3ff056af629a743d8572db8396d7313beb74865084fff05e8637b9d1c53923"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab3ff056af629a743d8572db8396d7313beb74865084fff05e8637b9d1c53923"
    sha256 cellar: :any_skip_relocation, catalina:       "ab3ff056af629a743d8572db8396d7313beb74865084fff05e8637b9d1c53923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7967c1d718aa5b55f29c4d89020334ef976195d37604717940871b088132fa9"
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
