class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.0/imlib2-1.7.0.tar.bz2"
  sha256 "1976ca3db48cbae79cd0fc737dabe39cc81494fc2560e1d22821e7dc9c22b37d"
  license "Imlib2"
  revision 1

  bottle do
    sha256 "460c1523b721a0a2d14d46ea95a4fb7a07ca6b177a4e7d0b0d54d00801bb289e" => :catalina
    sha256 "98dc695e5f9c64e5f375a630c47a5495c366b943b749691b758b63a868b40e5a" => :mojave
    sha256 "ad2c1d6563f4fd03b035c952c2076d498fbdc1261f8b408f7b6c2d681a4f81ef" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-amd64=no
      --without-id3
      --without-x
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/imlib2_conv", test_fixtures("test.png"), "imlib2_test.png"
  end
end
