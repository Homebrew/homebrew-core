class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.29.1.tar.gz"
  sha256 "d8e3a45e20db849c0c46a5e5da3ec301af6d50d378f7fc9ca7b6972a18684eef"
  license "MIT"

  bottle do
    manifest_sha256 "e45ef61fd87cb60a058b2b29dad8c246d20c441241ae5332fad37fe7f5421d94"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a512b7189966ff77331c8032028f99bca9b1801b6856147b3db208cbc1aa72b8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a512b7189966ff77331c8032028f99bca9b1801b6856147b3db208cbc1aa72b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a512b7189966ff77331c8032028f99bca9b1801b6856147b3db208cbc1aa72b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ee779ac87c50a28d1cc72fa3238cd09394ce384d7e8d969d49ea55aa09f0bdf6"
    sha256 cellar: :any,                 x86_64_linux:      "0188293ff0d316d661a4698233ae0319a960ab5b4c054db9f34d74fc7495c179"
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
