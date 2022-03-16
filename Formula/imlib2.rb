class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.8.1/imlib2-1.8.1.tar.xz"
  sha256 "522e1e70e65bc0eddfe207617d15c9a395662a7c090661daaa2c294fb7d9fdaa"
  license "Imlib2"

  bottle do
    sha256 arm64_monterey: "b2de245f18e78b436d4d07f3014c56d8270b3492fb69fdeb3582a0d15bf4b67f"
    sha256 arm64_big_sur:  "36251f3feb076561ea14d370a835cc083784dc5e474eacbf245e2fd45b9a57d5"
    sha256 monterey:       "9aa38042fc2b718761512b6a15e83b42e72ded8dd8c2ef7c31d725bb6e24541f"
    sha256 big_sur:        "705df97598ac9dcc97cbebe1c1e0c73e00bfe3767026beab67d4a323895c19b5"
    sha256 catalina:       "29986753fc1e8df3308f04e97c8ac84e1bbeb7261782aeacc368d15e15da4105"
    sha256 x86_64_linux:   "3515128d61ab7d33f66381177b0a99d5001ec5b23b9f121906d40db994c30804"
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

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

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
