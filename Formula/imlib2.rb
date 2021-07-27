class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.2/imlib2-1.7.2.tar.bz2"
  sha256 "525d4e318927471bde4520786dc2550b59ab88533848db2d75c60f5b4e5821a1"
  license "Imlib2"

  bottle do
    sha256 arm64_big_sur: "9455235701eb3e7228e8189f99b79c94c3034372d475c7c0ced4468418adafbb"
    sha256 big_sur:       "d2af1ccb06b90d94c4a6e0502f722880a2947d126735c0e6e15bb2ec4600955d"
    sha256 catalina:      "530114570c89b19a5b4383adca9168f85ae033ba75627f794c557bd5bb5179f6"
    sha256 mojave:        "4e65ec5a0c3474e47a93b3c25048247c1062c62a5a92a2525842226c4ed238bb"
    sha256 x86_64_linux:  "439592effbbc1882d59b695ac98f2d4eaf3c35c7a17578014ef7d13135211975"
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "libxext"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
      --without-id3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
