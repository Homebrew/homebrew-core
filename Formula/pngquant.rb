class Pngquant < Formula
  desc "PNG image optimizing utility"
  homepage "https://pngquant.org/"
  url "https://pngquant.org/pngquant-2.11.4-src.tar.gz"
  sha256 "d4e6b4860aa297d5ae57cf5f4f0a1d83ee0ea54b0b0d1dd8cd5f51d27e5ef3e6"
  head "https://github.com/pornel/pngquant.git"

  bottle do
    cellar :any
    sha256 "25edb7fd8d0f4980cc5abb27283821ed0d559d5f35f8a50bfd1130a917c5c4bb" => :high_sierra
    sha256 "871530f5c7254d24ce20f072776cf56e416750b4c287b28edbbed01f36f4916a" => :sierra
    sha256 "3adfdb133644976df11f2a2070b0374b43b1e0917e198f16d3c89a983579c9d7" => :el_capitan
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
