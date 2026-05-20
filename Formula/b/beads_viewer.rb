class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.16.3.tar.gz"
  sha256 "f4d27d9e83a8a3f0f2827e19672baceb5966cdb2851d35273df8064c9e2d402e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c425fbd3e06591f06e665cc7715763f1b131032ffe7d1fe3a87316a42fab4253"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c425fbd3e06591f06e665cc7715763f1b131032ffe7d1fe3a87316a42fab4253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c425fbd3e06591f06e665cc7715763f1b131032ffe7d1fe3a87316a42fab4253"
    sha256 cellar: :any_skip_relocation, sonoma:        "890ebb8155519159e30501600ed65a6f3bb4ac9cf8cc54b694990d30746ba865"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d8c52cabdc7398bcd64e0f2ebad3c76c31f4657d9cd20e4fe77114a754e2aa3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c2a7a193410006a7dcd18f3d59717ce50372c356c9a1687492a7e5e551c4538"
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
