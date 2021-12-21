class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.18.2.tar.gz"
  sha256 "3f24f4d38db085a35efdd9b93ff1dd2b6b9a9bbc1f1ad75291399b2a9a5f3200"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "454ebd1e34ffd71df3b5d6fc42f1bf34da4a1164e8db90af33d3024f0ca04775"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "454ebd1e34ffd71df3b5d6fc42f1bf34da4a1164e8db90af33d3024f0ca04775"
    sha256 cellar: :any_skip_relocation, monterey:       "8b073bfbf77b5eafc9ca57fb706e9d07c11cd2873e55b9971ebb1457bfff2c9a"
    sha256 cellar: :any_skip_relocation, big_sur:        "8b073bfbf77b5eafc9ca57fb706e9d07c11cd2873e55b9971ebb1457bfff2c9a"
    sha256 cellar: :any_skip_relocation, catalina:       "8b073bfbf77b5eafc9ca57fb706e9d07c11cd2873e55b9971ebb1457bfff2c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb61bbf054384b0381ac9f5f80f8fd16a63f8b11d129ce5a7b0d61c75828297"
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
    assert_match "Invalid AWS Region", shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
