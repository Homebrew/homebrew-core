class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.7.4/imlib2-1.7.4.tar.bz2"
  sha256 "8371f71fe4e40dd5b189150fa264d88f046dd45061c5fad1260347c205d3992d"
  license "Imlib2"

  bottle do
    sha256 arm64_monterey: "87e224ad574bf8e2d02e5f42a51ed3103a0c02865f385b8a29307fb4e72497f9"
    sha256 arm64_big_sur:  "7d646f7b6b8cf7f0002d89e0c2735fc16dc711084664d52ea7ad9c4157302b3d"
    sha256 monterey:       "d1ca59cb6dc3ad2fd4b19d19a1ecde321b9dc93d60230a3b19821331aba8fb66"
    sha256 big_sur:        "5705ac8d8c2aa6bcf8931b310742b3fd99cf0c7a2a7914a1dea50296d921fcae"
    sha256 catalina:       "0948b05c33a2037b0bd2044acf87eded935de17946139996692e1bba704ad01f"
    sha256 mojave:         "b0507e4e44035eeaa252add2deb30dc9af1ea1a5d80726a05c4e8698431f9053"
    sha256 x86_64_linux:   "fe7081af03dbd33b999baa1ead3a68e3d0f27925aec0f828a89a4b503d4cfbbf"
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
