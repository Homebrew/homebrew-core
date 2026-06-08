class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.16.4.tar.gz"
  sha256 "b3a6dddc3dc778d903a8d7f793cbb73eeded3ed72822df9149ba9576b3512608"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aad9c2b5cb98af1c367b9b31d8d2d79c7408ef1ecc52f44623791d1cb16f0e86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aad9c2b5cb98af1c367b9b31d8d2d79c7408ef1ecc52f44623791d1cb16f0e86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aad9c2b5cb98af1c367b9b31d8d2d79c7408ef1ecc52f44623791d1cb16f0e86"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5471a33844551d0ddb6e98356dc5414eee9423c096c1abfce2d4ccfef3ad3c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79e0e1e9cc425ad8aac3c74bb5b8920ff4fa73b7ae8ba5b34e4b33651d2e2a3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9ed2b76c7169ce14240ff1690ad749359ed2acb79f74aa2d5dc99e3101c6d33d"
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
