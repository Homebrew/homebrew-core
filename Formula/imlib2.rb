class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.8.1/imlib2-1.8.1.tar.xz"
  sha256 "522e1e70e65bc0eddfe207617d15c9a395662a7c090661daaa2c294fb7d9fdaa"
  license "Imlib2"

  bottle do
    sha256 arm64_monterey: "edca176b995676a8806b8c59e2db0b315f79657d9d1e66e60ad9c6d5e11110a2"
    sha256 arm64_big_sur:  "b19e314d382bd994a865ab2eeb3490460cb226430d673e0cd434ab3c3917dcd9"
    sha256 monterey:       "e41598d4fa65712d0347319028fec58609710c3f6412245ddf6764e6a180c27c"
    sha256 big_sur:        "0bd95cba05083714455228fc45356ff74f26cea32530c98577f84a6e6a431c25"
    sha256 catalina:       "88825eb4c206231481e6ae4c84e34ae074a6cf13ab4a58c5fb1c82b857da0d2d"
    sha256 x86_64_linux:   "f667ec469d36ea317a8bd59e3af208b971a6265abbd21b8733a33ef7df079271"
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
