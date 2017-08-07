class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  revision 2

  stable do
    url "https://github.com/libgd/libgd/releases/download/gd-2.2.4/libgd-2.2.4.tar.xz"
    sha256 "137f13a7eb93ce72e32ccd7cebdab6874f8cf7ddf31d3a455a68e016ecd9e4e6"

    patch do
      url "https://github.com/libgd/libgd/commit/381e89de16125bb0e86ffc144d6fe3e9cfdd898f.patch?full_index=1"
      sha256 "93bcd92e7d18ef1f4cf4466482f41de8f0c65a7644c10bb88d10d59de96a13f1"
    end
  end

  bottle do
    cellar :any
    sha256 "d8b304728206def83aa62cdb17e727f3c83aeb4e9ebd5ff6734194119df68f1e" => :sierra
    sha256 "a55f9020931e261d17d4b6be6d4357d05eb9e1865d21581f430fea59ddadba4d" => :el_capitan
    sha256 "bd74d64762d8b648e04f32262d19b07e7e010b3e3ed637463ce5e2302eab190f" => :yosemite
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
