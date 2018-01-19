class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.11.7-src.tar.gz"
  sha256 "d70b46c3335c7abf21944aced2d9d2b54819ab84ed1a140b354d5e8cc9f0fb0a"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "15fab42baf4df4cf6fb56554024eed3ec28fd94ebcedd7075acfb5fcc5ee5291" => :high_sierra
    sha256 "d5c88987657ada8f05f0632701d691fa518815ba5b084f9e31c77722700d4da7" => :sierra
    sha256 "5ee791b257c7ca2a3cd08f87adc5f674b24ab08a3384f7f8745f72f166e3fea3" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libpng"
  depends_on "little-cms2"

  def install
    system "cargo", "build", "--release"
    bin.install "target/release/pngquant"
    man1.install "pngquant.1"
  end

  test do
    system "#{bin}/pngquant", test_fixtures("test.png"), "-o", "out.png"
    assert_predicate testpath/"out.png", :exist?
  end
end
