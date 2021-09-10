class Driftctl < Formula
  desc "Detect, track and alert on infrastructure drift"
  homepage "https://driftctl.com"
  url "https://github.com/cloudskiff/driftctl/archive/v0.15.0.tar.gz"
  sha256 "d9c62b6fd8d29a6fc5d78f1d744adcee4ad8639b8a75209b96c18825b993544a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3f055f970fb73143ac04857a5861a0403aa6822e529c7a3107f7740883320163"
    sha256 cellar: :any_skip_relocation, big_sur:       "a5859c618977054048bc290f54ba567f5f56db1d880b7489690d3b6a9317c277"
    sha256 cellar: :any_skip_relocation, catalina:      "a5859c618977054048bc290f54ba567f5f56db1d880b7489690d3b6a9317c277"
    sha256 cellar: :any_skip_relocation, mojave:        "a5859c618977054048bc290f54ba567f5f56db1d880b7489690d3b6a9317c277"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "01210e4350dba7c4d75e84119c02e7d01ea5f6efc51b5bdf984cd30de445b908"
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
