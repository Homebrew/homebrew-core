class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.20.0.tar.gz"
  sha256 "b1646173d9e884bf331de862122611dab56f3215a3f2709cff0d596f0c18ca68"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e8ab9474e1463bcd5c7fe0fec174ed9b7da54c7ca1e4952e771a4fe11b351a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e8ab9474e1463bcd5c7fe0fec174ed9b7da54c7ca1e4952e771a4fe11b351a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e8ab9474e1463bcd5c7fe0fec174ed9b7da54c7ca1e4952e771a4fe11b351a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "a07d6c08736733fd85d40de2515b6db4e6c1a785e7ca7f3db36daddac893723a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5094dd30bcf092b9f848562a39a6a4e0ce12f3db19a0a790d2178825dd1d8d01"
    sha256 cellar: :any,                 x86_64_linux:  "ca626c361c78282dba760baf9494600c5425d250e859293ee54d9b8efb761664"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[-X github.com/Dicklesworthstone/beads_viewer/pkg/version.version=v#{version}]
    system "go", "build", *std_go_args(ldflags:, output: bin/"bv"), "./cmd/bv"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/bv --version")

    # Test that it detects missing .beads directory.
    output = shell_output("#{bin}/bv --robot-insights 2>&1", 1)
    assert_match "failed to read beads directory", output
  end
end
