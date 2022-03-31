class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/snyk/driftctl/archive/v0.26.0.tar.gz"
  sha256 "e6fa40c2cb407e05b48de9ed697e14ad7bca9557274543a1c5d1ff592c4237c5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3781aa8d46ef8157d5d583b605e4ce46b1ee3ce81e3a2f77243194e785dff731"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3781aa8d46ef8157d5d583b605e4ce46b1ee3ce81e3a2f77243194e785dff731"
    sha256 cellar: :any_skip_relocation, monterey:       "8cc7f95305203831098036c03e4377bf5b3d6a87caa660b81b111c0086e641b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "8cc7f95305203831098036c03e4377bf5b3d6a87caa660b81b111c0086e641b7"
    sha256 cellar: :any_skip_relocation, catalina:       "8cc7f95305203831098036c03e4377bf5b3d6a87caa660b81b111c0086e641b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84d21f547f5c3d85adfab89b6a023a261168206ed4a19a8f50f856d6498281de"
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
