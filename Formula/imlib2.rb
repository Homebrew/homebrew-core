class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.9.1/imlib2-1.9.1.tar.gz"
  sha256 "c319292f5bcab33b91bffaa6f7b0842f9e2d1b90df6c9a2a39db4f24d538b35b"
  license "Imlib2"

  bottle do
    sha256 arm64_monterey: "acaa25e7ae6473d124fe9eccd31cdf3f968b250fe6ceb90aa0bca03bb5aefde4"
    sha256 arm64_big_sur:  "ce46c731364d432530301e1e3f8b16c5cf09d269e658ba091b107d4dd0bcbdf0"
    sha256 monterey:       "426a3a9bbb3d2dcc1fc034528397d4d5dca5632658948afaea5f894c9d4962f8"
    sha256 big_sur:        "1040596216b85a75b8c4d7f7e8411c324974e50eac47e0a12b5d031d6aea2497"
    sha256 catalina:       "d130d1bac13c47e10e81bf89a57aa06b0fef78710a4a40c14bb454f5dc0a3029"
    sha256 x86_64_linux:   "e23cfeb030588b855455841f10d6a1fcb5a33ece3d00c7d6a88f38394ac15519"
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
