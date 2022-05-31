class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.31.1.tar.gz"
  sha256 "7c555e182b020690aaa7a26e5a400b05c01503f417462dff28423173a887a9ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c1f9aa519098e333a6573fd244bb68620a7d2b8fe2c179b72f57ded0cafe454"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c1f9aa519098e333a6573fd244bb68620a7d2b8fe2c179b72f57ded0cafe454"
    sha256 cellar: :any_skip_relocation, monterey:       "39ffe5c0f5f58fcc4430923071c2bf28b0cfff44d08b59394df6485ced2fe0fd"
    sha256 cellar: :any_skip_relocation, big_sur:        "39ffe5c0f5f58fcc4430923071c2bf28b0cfff44d08b59394df6485ced2fe0fd"
    sha256 cellar: :any_skip_relocation, catalina:       "39ffe5c0f5f58fcc4430923071c2bf28b0cfff44d08b59394df6485ced2fe0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65c04ce7cb1e6c4fc67aa082642eded7bad7cc9c427e41b2a2abd8ea55278d68"
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
      shell_output("#{bin}/driftctl --no-version-check scan 2>&1", 2)
  end
end
