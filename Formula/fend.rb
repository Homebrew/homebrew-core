class Fend < Formula
  desc "Arbitrary-precision unit-aware calculator"
  homepage "https://printfn.github.io/fend"
  url "https://github.com/printfn/fend/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "d2781dfdbaed22b38fabea6897ff2249ac804f9021c921cd67603f3b609994e2"
  license "MIT"
  head "https://github.com/printfn/fend.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ce955e9c59ac7e1695716dfd30a7e9c6552b3b53d79b56bff0425afc8b02d8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ef77429b8d67557d60340f543c7dd1e0ec43eb5b21219fc34909d04eb4aed47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65e3c6cf88d6c77d5172ebfb13d8c7253df47fc84224b91ba3c88ddfadf49838"
    sha256 cellar: :any_skip_relocation, ventura:        "8f5b6703a886f77a60a90d0b87601c2f056bde942e0468c60f007eaf13f5b39b"
    sha256 cellar: :any_skip_relocation, monterey:       "24c6241de0cc348c041aabb33d92451fdbf796e52e7e5edc20043e2e681ca809"
    sha256 cellar: :any_skip_relocation, big_sur:        "6fc8bd151ddb2f542c06d42dbb78e336b2c35e40295f01435c226e0c9e156002"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "681fdad46dd43f0136d34197cfd7863b8068f4bc3d0140652b1243130853f547"
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
