class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.0/imlib2-1.7.0.tar.bz2"
  sha256 "1976ca3db48cbae79cd0fc737dabe39cc81494fc2560e1d22821e7dc9c22b37d"
  license "Imlib2"
  revision 2

  bottle do
    sha256 "72866470ea175cfa01858f670fbdc8a19afeda10b2541c9cdf79b08d8f3bb08a" => :catalina
    sha256 "394509ce7f6af7b45b1128f986b137230ad19472073025b43960ff066ebe769f" => :mojave
    sha256 "64eb02446a98a104959f72252f3c57528519f346554ff17f07fa360f35906c03" => :high_sierra
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
