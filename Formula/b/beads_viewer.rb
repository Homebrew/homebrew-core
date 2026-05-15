class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "b978063f59a1b693fb43cd48bb8ee9778ea8a12873d62fde40cd133c683cee56"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74cafb34d9c8fdffb10a2698431dda101b5c79b354a7ab24015c494f4bb4216a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "74cafb34d9c8fdffb10a2698431dda101b5c79b354a7ab24015c494f4bb4216a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74cafb34d9c8fdffb10a2698431dda101b5c79b354a7ab24015c494f4bb4216a"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3632685bb45fd9ecaee7642738daa1dc2a19db5203431dc42a3f441f3c4a985"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9da9d785510f6074f1ea5879144a9b358d1dd093517e7d3baf24aa13f455b88f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6947d628d4fb43b4ab492554cf09e4cfa82768d7c5a2a27d1a0c3cbb3a0199"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Dicklesworthstone/beads_viewer/pkg/version.Version=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
