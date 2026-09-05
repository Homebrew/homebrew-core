class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "da80d5b0e946baa8f7c8a7108a79dbd8c46a9698b37882f44758e7d089957c9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4f41ba330907f3c5e62e69a2a312682448c9fd9274183f2a88c392e31e10cd15"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f41ba330907f3c5e62e69a2a312682448c9fd9274183f2a88c392e31e10cd15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f41ba330907f3c5e62e69a2a312682448c9fd9274183f2a88c392e31e10cd15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce15255f448c794bb1637abef749dc1da1b6d5757bf2fd1a9ab513348ccd9e8e"
    sha256 cellar: :any,                 x86_64_linux:  "406c8db56eafb8549cb9bd01033dc900fe335a7a875e46759c481bdc610f2ac9"
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
