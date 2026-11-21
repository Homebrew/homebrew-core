class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "63921bbbb33ddf7d564a38f5594cb15fed9792acf743b91ba1c4ff5de52fa850"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ea0e28eef69866117d2e9a756b8292956da076d066701e5a91e62bcf5da31fc2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea0e28eef69866117d2e9a756b8292956da076d066701e5a91e62bcf5da31fc2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea0e28eef69866117d2e9a756b8292956da076d066701e5a91e62bcf5da31fc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9e172f973a30364a3f4e3a935a8819cbc925a40216ee02e6a4d20088b7faf0c1"
    sha256 cellar: :any,                 x86_64_linux:      "57395508b1da9bd4b9510f1bc8f3167fb9fe32b6fd116fa8b95b68df3567926c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Dicklesworthstone/beads_viewer/pkg/version.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
    generate_completions_from_executable(bin/"bv", shell_parameter_format: :cobra)
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
