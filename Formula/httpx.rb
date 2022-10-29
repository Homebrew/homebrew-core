class Httpx < Formula
  desc "Fast and multi-purpose HTTP toolkit"
  homepage "https://github.com/projectdiscovery/httpx"
  url "https://github.com/projectdiscovery/httpx/archive/v1.2.5.tar.gz"
  sha256 "297b34f574bedd9575926f1e8c9f630a39ab54311bd2df821536359735a2b161"
  license "MIT"
  head "https://github.com/projectdiscovery/httpx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b7888b639fd3292429226e3fdc5c51bc023b5686cca5455db6be88f48edeb56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8847479dcfd206f2b400c59275b5c89c99f61a432f3f9b4c0b26872509480d15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e16f44d2f3ffaa3f0826ee09d02917587474aa353e1b3c3cbcf135c6c47b1b90"
    sha256 cellar: :any_skip_relocation, monterey:       "35d1275e6be68e1ecff9d1df7000e10943a67a059756fa114f8bf93cd5526bb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "49d8597fec0d9e68d1365ecf7d8b8d8a825073c0f8ad7b49057c11b17bf7308f"
    sha256 cellar: :any_skip_relocation, catalina:       "0b1f4f21353bd9d413209252e44ba281f1a363e2ebede6f697f32d7dfd244b85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19f6383086cd06ca7bbade724e0852f83e53a5a2eb9bae00a56cbec588e263ae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/httpx"
  end

  test do
    output = JSON.parse(shell_output("#{bin}/httpx -silent -title -json -u example.org"))
    assert_equal 200, output["status_code"]
    assert_equal "Example Domain", output["title"]
  end
end
