class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "63921bbbb33ddf7d564a38f5594cb15fed9792acf743b91ba1c4ff5de52fa850"
  license "MIT"

  bottle do
    manifest_sha256 "8b45df7616c9d0bf06a594fc0b554a2f0ef0f941b1ded6f52174a73931c6138a"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "57ed05f093c413b1f5d93d5d81f9d148d61eca98a1368bea5cc710b78495e7a6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "57ed05f093c413b1f5d93d5d81f9d148d61eca98a1368bea5cc710b78495e7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "57ed05f093c413b1f5d93d5d81f9d148d61eca98a1368bea5cc710b78495e7a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8b77cb41ac496a38c9af2a826d2db73bbe2be12cabb7191edb12a39993cc13ae"
    sha256 cellar: :any,                 x86_64_linux:      "745af055190c0dc41b53c1a4b5b02a5c66a99a20c2cae6b3fad68f712ea02d9d"
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
