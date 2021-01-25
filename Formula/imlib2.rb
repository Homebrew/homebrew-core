class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.1/imlib2-1.7.1.tar.bz2"
  sha256 "033a6a639dcbc8e03f65ff05e57068e7346d50ee2f2fff304bb9095a1b2bc407"
  license "Imlib2"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "d2af1ccb06b90d94c4a6e0502f722880a2947d126735c0e6e15bb2ec4600955d" => :big_sur
    sha256 "9455235701eb3e7228e8189f99b79c94c3034372d475c7c0ced4468418adafbb" => :arm64_big_sur
    sha256 "530114570c89b19a5b4383adca9168f85ae033ba75627f794c557bd5bb5179f6" => :catalina
    sha256 "4e65ec5a0c3474e47a93b3c25048247c1062c62a5a92a2525842226c4ed238bb" => :mojave
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
