class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.1.5.tar.gz"
  sha256 "4b9c8056c3e45bcfb068b4536b037eb9986b75fa2f86f561ea3ddd87946b7127"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4d8a4f0bdaca718d236935c03088fef172aba98a4ad7aa5a840857f0d255710e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "486e32a213c6d5e5960417d1f3acabbf72e50d176a9e906abbc4aca7a18dee9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "47a4758e7d645ecb87a127b6d204e0065ed5ad8110b066d2e9124c690978b744"
    sha256 cellar: :any_skip_relocation, ventura:        "5d7eb5c590cbe263520a9cfc94bea33d836c1c6ddd87a451d4ff99e57b4d1737"
    sha256 cellar: :any_skip_relocation, monterey:       "ec9c00d0905d5b1ec4240ab28fbcb8752f252b06ff1288f329fd8438bd9b52e8"
    sha256 cellar: :any_skip_relocation, big_sur:        "00de13e987b5400904c6e454308ccba6363994c9949722d9f629d1174b1ecc1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9993c8707f6c2316f7835b277bf1d600b12ee98036e8aacd26acf91017d5532c"
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cli")
    system "./documentation/build.sh"
    man1.install "documentation/fend.1"
  end

  test do
    assert_equal "1000 m", shell_output("#{bin}/fend 1 km to m").strip
  end
end
