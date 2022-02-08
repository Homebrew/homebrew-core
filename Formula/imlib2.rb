class Imlib2 < Formula
  desc "Image loading and rendering library"
  homepage "https://sourceforge.net/projects/enlightenment/"
  url "https://downloads.sourceforge.net/project/enlightenment/imlib2-src/1.8.0/imlib2-1.8.0.tar.xz"
  sha256 "8925cf2a87f6f4971c1cd2073a7352446fe912d04ff41a05fd6ac20323cc086d"
  license "Imlib2"

  bottle do
    sha256 arm64_monterey: "42ce6444ed4ea88182a2224bd9bc41678f3c5b1541643d00a927194fd008564b"
    sha256 arm64_big_sur:  "8819e6881ab37a4ed403a09907bd4e2b50c58fe95a49f9e7eb01ee1273f22902"
    sha256 monterey:       "acfdb90aedcf59df54b9b4c6401e3a953453ae395267145d8f0e94ea2536ad02"
    sha256 big_sur:        "4d307ed31a85d37607ff47a074a98feed643a5ce3cb01a7bce7ea1726d1a915d"
    sha256 catalina:       "ec75b72d588f58183ee2aee240a7125799c517bbf8e4b6862e7c495dcaf88cce"
    sha256 x86_64_linux:   "9ad7868a77d3a89b8fed50b2fd0571e531c406a7a783dfab35c7eb33ad946944"
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
