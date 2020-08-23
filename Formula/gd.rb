class Gd < Formula
  desc "Graphics library to dynamically manipulate images"
  homepage "https://libgd.github.io/"
  url "https://github.com/libgd/libgd/releases/download/gd-2.3.0/libgd-2.3.0.tar.xz"
  sha256 "ecd9155b9a417fb3f837f29e5966323796de247789163761dd72dbf83bfcac58"

  bottle do
    cellar :any
    sha256 "ebc4192da4580942545084cf2f5c36dc4645a5c83244224905e01dee4e50837e" => :catalina
    sha256 "c014efe5f692b3146a4416c0acdaad3c632064d50aad2c18598cfb32fb31ee69" => :mojave
    sha256 "0bd97ae0be0bfaa7554d0628a69b5fd8cba27de7ff5bde0533d4a1b6445be614" => :high_sierra
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
