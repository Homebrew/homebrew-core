class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.1/libgd-2.3.1.tar.xz"
  sha256 "9767917d9f818faec4ddd763fe4a4ad9f6322c3d25da290ab2ea3e2ce4b52a7b"
  license :cannot_represent

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6f861db008780a40ea0682f5043a66cd72a076b9bb220f7fdd48655a0dc1ab53"
    sha256 cellar: :any, big_sur:       "ec599087d1cf61ab58ac3d7ddca812cc00cad0eaab80e16382d75ff9b77a28fe"
    sha256 cellar: :any, catalina:      "07806dd972f4f1763d738b3d5ed0d674e14bd3ccddfe53dbe9d64b40f627e453"
    sha256 cellar: :any, mojave:        "9caf104db0a1c87ca2b318e117cf7d182a89c44bfde0f7a8e9d36ceca7984554"
  end

  head do
    url "https://github.com/libgd/libgd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "webp"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-freetype=#{Formula["freetype"].opt_prefix}",
                          "--with-png=#{Formula["libpng"].opt_prefix}",
                          "--without-x",
                          "--without-xpm"
    system "make", "install"
  end

  test do
    system "#{bin}/pngtogd", test_fixtures("test.png"), "gd_test.gd"
    system "#{bin}/gdtopng", "gd_test.gd", "gd_test.png"
  end
end
