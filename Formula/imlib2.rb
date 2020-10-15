class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.0/imlib2-1.7.0.tar.bz2"
  sha256 "1976ca3db48cbae79cd0fc737dabe39cc81494fc2560e1d22821e7dc9c22b37d"
  license "Imlib2"
  revision 2

  livecheck do
    url :stable
  end

  bottle do
    sha256 "3b036ab0c372688bdd116674d463f85b7a1fc900dcb71deddbfa5aa28fca0be1" => :catalina
    sha256 "ab1f7ef9cd4c1b7eced2f47f20bed71d724d09c48907675e4144ae039a10d297" => :mojave
    sha256 "153ebc859ca8a20b20b9d24db87667b8d338fd0e571f01f8400262e3d5700f86" => :high_sierra
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
