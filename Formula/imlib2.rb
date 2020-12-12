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
    sha256 "968e5cb051e8a58d8d6a1118a7bcf60903a8895af6a8e97f7a1bd2994a433bf2" => :big_sur
    sha256 "f12cf90a6a2d30419b0d30e030406f1e5bc5d5adda7a7a0f7efb7fc5946ca0d6" => :catalina
    sha256 "6abc2f07f038830a81b3e8ace017c34920c7949e07552ab319a9defb0dfd6599" => :mojave
    sha256 "4484afd5b50f13946e5b12571582d06fa9ac5443f9b32482eab26a20aec2e81a" => :high_sierra
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
