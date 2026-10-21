class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "e8895e4de9beb68d243f37d4dd797af0e0223324da541737a1252a2dfa1b1a37"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cab700b6b61c04bb96909dbbbf19d2ff154465327f598d88c3b2279abf245207"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cab700b6b61c04bb96909dbbbf19d2ff154465327f598d88c3b2279abf245207"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cab700b6b61c04bb96909dbbbf19d2ff154465327f598d88c3b2279abf245207"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5d3a43651f8fbe36a1a2f2bf209c4fdfbd70567c9cea644f55d111a694ba1312"
    sha256 cellar: :any,                 x86_64_linux:      "9afeca2eb4e971dd65e85e17f73e2af995959678357eef4b04830ce6e76bfcea"
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
