class Gifski < Formula
  desc "Highest-quality GIF encoder based on pngquant"
  homepage "https://gif.ski/"
  url "https://github.com/ImageOptim/gifski/archive/refs/tags/1.33.0.tar.gz"
  sha256 "e7c37f178b62ae4ae26e7fba7d08fff29a4e7c6d401ab4a24d45e7c94d8c2af9"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6a26f2f9f8a792975bb5865ceea1fe5e140b00a4e23beeb6e2cdeb84868eeb9c"
    sha256 cellar: :any,                 arm64_sonoma:  "a258c61b6ececcb3270318dc9e36f8fdc5c5605897355d5da0a72b2ba3860ace"
    sha256 cellar: :any,                 arm64_ventura: "bb9a7f723b6f2176c5805be229000a05c0e573bea4cb247a4b49beb436c80c24"
    sha256 cellar: :any,                 sonoma:        "f3d27ef1e3845269bddac0e76632e81bcb5aa7ea9d16c5b52d5d3810e2c9cf63"
    sha256 cellar: :any,                 ventura:       "ef8e5b73042edf2167670dca1eaf1d77646ba00e32a636da7ec243f94050e57b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d62ef5b1f5f9b608d2605fed56f86d5654124c880fc0eb791683578da50d976d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c38a2e6784b77bcdd086fb70dfad916bd47f0e97d55f7162bdb9529ffb8ded9"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "ffmpeg@6"

  uses_from_macos "llvm" => :build

  def install
    system "cargo", "install", "--features", "video", *std_cargo_args
  end

  test do
    png = test_fixtures("test.png")
    system bin/"gifski", "-o", "out.gif", png, png
    assert_path_exists testpath/"out.gif"
    refute_predicate (testpath/"out.gif").size, :zero?
  end
end
