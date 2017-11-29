class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.11.4-src.tar.gz"
  sha256 "d4e6b4860aa297d5ae57cf5f4f0a1d83ee0ea54b0b0d1dd8cd5f51d27e5ef3e6"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "d32d63df7c57e37dbd707e098b4cb4620c02d1ee6d501f5ac74a0d35a12ba8ca" => :high_sierra
    sha256 "979de71b3d8ccedeb91f833d2f27b9d829280cf04d60bba23080d31eec3cb5d7" => :sierra
    sha256 "42b3911c048d6d84a0bc8ad78d2c2d93b54e2469a214ae517557dfdccf0aab60" => :el_capitan
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
