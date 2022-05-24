class Gau < Formula
  desc "Open Threat Exchange, Wayback Machine, and Common Crawl URL fetcher"
  homepage "https://github.com/lc/gau"
  url "https://github.com/lc/gau/archive/v2.1.1.tar.gz"
  sha256 "17bd5b8e3a6a554d82ab5de66bc1f34ce2810a3ba6b8e1456432faff9b191c8f"
  license "MIT"
  head "https://github.com/lc/gau.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38e7339a593bfacf1502d7229c8efbd0437c9d047f395d4519bc81ae4680c1ad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "69c6b9c13e1ac20d1dac6bb8b256b21ea9c7361ad2f252483536b9dcf706a3dc"
    sha256 cellar: :any_skip_relocation, monterey:       "84d56775d9e7c3c0237804eb00f47ef8899b08b82ee1405230aab4a51e754a70"
    sha256 cellar: :any_skip_relocation, big_sur:        "74f4cffe9ee51402a8ff40161c4f19927de6f1e559e9f23598211fe3a7723137"
    sha256 cellar: :any_skip_relocation, catalina:       "9542546cd3c6c975765fdf6320f5f3041ac5de48a77a225b748966dede196ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14d7301ff3f4211804cfb704361e2018ea17f42457ba04a455457c36b9d39ad1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gau"
  end

  test do
    output = shell_output("#{bin}/gau --providers wayback brew.sh")
    assert_match %r{https?://brew\.sh(/|:)?.*}, output
  end
end
