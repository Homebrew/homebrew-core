class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "6e21ee6ec7c14044b3a78a0ee4819bfa42ee2b60c52216bd71e64f3822164fb3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "83dce2d32cedc5a302aaeaeaf84b0c85410dd23b963591147ebbc5055c86048c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "83dce2d32cedc5a302aaeaeaf84b0c85410dd23b963591147ebbc5055c86048c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83dce2d32cedc5a302aaeaeaf84b0c85410dd23b963591147ebbc5055c86048c"
    sha256 cellar: :any_skip_relocation, sonoma:        "1524c3ddfaca02305641197f7fddd5b38ad556be3425466a09156e53ce0bf669"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6581db366ae6efe514092c939fd1755879d5b4ed635bd11ef46cbdfdc9f64116"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8b9fec8ba6fbbfc66ed585785ff856d6638ef50b7de975d4efbfb70d3f10e569"
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
