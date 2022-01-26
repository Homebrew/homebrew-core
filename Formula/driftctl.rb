class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.19.0.tar.gz"
  sha256 "7e6b64ca62ebc6ca2780f3bc2e49803961f1ed8b6819a641b214460f1c8ebcb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d01e96e6833d32d3cee129aad75d772369e72a019e738b540e27c81b1747b08"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d01e96e6833d32d3cee129aad75d772369e72a019e738b540e27c81b1747b08"
    sha256 cellar: :any_skip_relocation, monterey:       "be11df69bfdd4598db4aebb24cd28bddeeb0ffe6266e81f6b43ae025973ee32d"
    sha256 cellar: :any_skip_relocation, big_sur:        "be11df69bfdd4598db4aebb24cd28bddeeb0ffe6266e81f6b43ae025973ee32d"
    sha256 cellar: :any_skip_relocation, catalina:       "be11df69bfdd4598db4aebb24cd28bddeeb0ffe6266e81f6b43ae025973ee32d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56691c7ffbc9094402d6e559ba0a0cf33ba94647566478e7d751e8b3eb92ea05"
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
    assert_match "Downloading terraform provider: aws",
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 1)
  end
end
