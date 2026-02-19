class BeadsViewer < Formula
  desc "Terminal-based UI for the Beads issue tracker"
  homepage "https://github.com/Dicklesworthstone/beads_viewer"
  url "https://github.com/Dicklesworthstone/beads_viewer/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "a10155376933f181c4825fd347cd21cb0f93720513e4a87c691bdafa2a0f2fa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11a3085b386f57230aa47785fa70c996b77772613781330dce827a84495b840b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a3085b386f57230aa47785fa70c996b77772613781330dce827a84495b840b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11a3085b386f57230aa47785fa70c996b77772613781330dce827a84495b840b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9249e8ee982a8f9e8b46309ddf4820b07b6687da80acda48e41c4d6b2f9a2169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1844c57e2ad7df1816a31391fd45221c001b0d8bbc7d3da44d9f851b56972812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44523c6b0d6e1c5f15ba85bdfee29b1d1c6ca3da70dcf2712b55fd183b592263"
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
