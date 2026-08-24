class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "59bc97328ee6cfd5977a0ebf43cabc1ec5111e7a58ec0411c375fa4c33f3a6ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e00c777ac3f2b3dd1fe72425b12ffed48335f7a772786623dc2ee34a613d3004"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e00c777ac3f2b3dd1fe72425b12ffed48335f7a772786623dc2ee34a613d3004"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e00c777ac3f2b3dd1fe72425b12ffed48335f7a772786623dc2ee34a613d3004"
    sha256 cellar: :any_skip_relocation, sonoma:        "90c62dfa31ae7dd25bfed7063d1ecf7e580236c2c82fc4eca9d06cff9d8382cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ddd2b2dc52a865ba25f4cd2613590b97a2b051473a72d42f5438873e60f1d98"
    sha256 cellar: :any,                 x86_64_linux:  "3d43306f17d6dde9ed909c0d85f7033053cab31bda9955bd42801c291b8cee40"
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
