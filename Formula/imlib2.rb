class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.0/imlib2-1.7.0.tar.bz2"
  sha256 "1976ca3db48cbae79cd0fc737dabe39cc81494fc2560e1d22821e7dc9c22b37d"
  license "Imlib2"

  bottle do
    sha256 "3f02ff8333cfc8a046432fb078a7ede7d45f0bcda7b7b1dfb7726306eee91a13" => :catalina
    sha256 "5134d4a325c2af69112bd5f3b5408843b513a6546f32f4840671a3575deddb6a" => :mojave
    sha256 "8bf5d8afb1f8a34db501bc46301fd6bbbef3b3a3f9c9863dea180e8f1288f485" => :high_sierra
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
