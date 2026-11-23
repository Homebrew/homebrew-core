class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.28.0.tar.gz"
  sha256 "171c5506d60fd1f90385f3b2eee1388d6e2395a4af5c950d57a3d7d1c0157a99"
  license "MIT"

  bottle do
    manifest_sha256 "c4b60d0abc5158ed895873bedd43aec7de00371e7455a25468041722ba7e3fa5"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f0a8e6b0d48823f37ad7bd65dc81458c899893b79cfeb237a45fcdf6b116c445"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f0a8e6b0d48823f37ad7bd65dc81458c899893b79cfeb237a45fcdf6b116c445"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f0a8e6b0d48823f37ad7bd65dc81458c899893b79cfeb237a45fcdf6b116c445"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a62a1db187177aaf7fdd95adf3c3efcca0b0a6beefac80765d7840a4a98b3f15"
    sha256 cellar: :any,                 x86_64_linux:      "d4c73ff75efca5e798b88682810251d428a9a44e1116ccaf2479cf1cb26ba99e"
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
