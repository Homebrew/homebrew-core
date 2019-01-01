class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.5.1/imlib2-1.5.1.tar.bz2"
  sha256 "fa4e57452b8843f4a70f70fd435c746ae2ace813250f8c65f977db5d7914baae"

  bottle do
    rebuild 1
    sha256 "f2bb2e5ca54865edf5808245b54b0b636669e496757989bd4d6a19dc098b152b" => :mojave
    sha256 "0349423dda370df2ec72d02ff5d818f0f7c34197b9d6661212ae03c14b6dfbb0" => :high_sierra
    sha256 "1bebf0a2a3e58f6766e32fe6cbafa8f478788eb9aaed64204fa113204981a3f5" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on :x11

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
