class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "c40173354f84df8301121a936b6347c3958430227c53d0ea47718507a104f5da"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16bcd7e356a60ff4b4e4e3e75c297c3610d39976a96e05c26d23347c85071cce"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16bcd7e356a60ff4b4e4e3e75c297c3610d39976a96e05c26d23347c85071cce"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16bcd7e356a60ff4b4e4e3e75c297c3610d39976a96e05c26d23347c85071cce"
    sha256 cellar: :any_skip_relocation, sonoma:        "680bf8eb8af7e871f9c128726595d25ac04d5de7bf63b31edf86f5ba0ac53b31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2c218cc3e7a0f8b9cdfdc66f4fc75f2fc5e87928d8139179b4956512924be48"
    sha256 cellar: :any,                 x86_64_linux:  "10a7c11ff370930052c623ed66d54c34dd0195da6935a81b43b6328f306c1d09"
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
