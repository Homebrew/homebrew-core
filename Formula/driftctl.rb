class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.24.0.tar.gz"
  sha256 "baa7e1f34fc9b7f0fd29eccaea6a880906fb966827d9fa8ac395444c47321f88"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f2c3a58da7a4a3251120d2d8893e035496a0f261217432143c42b90e0829b00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f2c3a58da7a4a3251120d2d8893e035496a0f261217432143c42b90e0829b00"
    sha256 cellar: :any_skip_relocation, monterey:       "fe9b482dd2ac345f4957336383790d52440365e11a835edeb4fb69b8cf054f3b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe9b482dd2ac345f4957336383790d52440365e11a835edeb4fb69b8cf054f3b"
    sha256 cellar: :any_skip_relocation, catalina:       "fe9b482dd2ac345f4957336383790d52440365e11a835edeb4fb69b8cf054f3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df2599a51cf6baab46968ba6db30c5fd2302c4c5053a5a670a7af4f21608fbe1"
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
