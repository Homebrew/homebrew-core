class Cdncheck < Formula
  desc "Utility to detect various technology for a given IP address"
  homepage "https://projectdiscovery.io"
  url "https://github.com/projectdiscovery/cdncheck/archive/refs/tags/v1.1.36.tar.gz"
  sha256 "95178a79dd433452bedd4377779da346282688db6d604394743dfff6dbd890d7"
  license "MIT"
  head "https://github.com/projectdiscovery/cdncheck.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d7b96862e04c482ea907e1b839d9fd11713f3270a77e288d28465b3f162d8b61"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23a243d33844047f2b4acc75cbdb9c0228463a5275485e6672eeb6bf4987d7ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b5f35e2fe8844527e16345fdb087e2625ba147c9139abf95393e021691dc36e"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6d679be03d6cf4276656e6e8ea13ed7d163c8c6afbd3c1a86b312fa37e27c77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b6753351734ca9e44a0649b6a1f20460c79893fb42f4a51fc45ca89b3762748"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cdncheck"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cdncheck -version 2>&1")

    assert_match "Found result: 1", shell_output("#{bin}/cdncheck -i 173.245.48.12/32 2>&1")
  end
end
