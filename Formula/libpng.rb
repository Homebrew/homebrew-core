class Libpng < Formula
  desc "Library for manipulating PNG images"
  homepage "http://www.libpng.org/pub/png/libpng.html"
  url "https://downloads.sourceforge.net/project/libpng/libpng16/1.6.39/libpng-1.6.39.tar.xz"
  mirror "https://sourceforge.mirrorservice.org/l/li/libpng/libpng16/1.6.39/libpng-1.6.39.tar.xz"
  sha256 "1f4696ce70b4ee5f85f1e1623dc1229b210029fa4b7aee573df3e2ba7b036937"
  license "libpng-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/libpng[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "27fb15928d0f711e37715342e2245b48536a09aff722c68910c5a1b947a37ef5"
    sha256 cellar: :any,                 arm64_monterey: "3866f0b5172ab2d599f2cb43e14870b2a444dee43964ce5ececa35b885c9330d"
    sha256 cellar: :any,                 arm64_big_sur:  "cf59cedc91afc6f2f3377567ba82b99b97744c60925a5d1df6ecf923fdb2f234"
    sha256 cellar: :any,                 ventura:        "28c60231600a95cf267784ece25d0e2e5f220001baab625789cbdc7fb94611b6"
    sha256 cellar: :any,                 monterey:       "d33e5b6d0b21373ddd6dca2d6eaf6c8314315fa882ce32fe02618a8d8bfd4cde"
    sha256 cellar: :any,                 big_sur:        "86306aeedc4f2bc156897cb04e0a221cff1ee7fe5108c0e7a829543ebe4203a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "499c5d31e7d78ab405e95aa16fc713e5ae4686d8919f5b94c8864fdde26e62de"
  end

  head do
    url "https://github.com/glennrp/libpng.git", branch: "libpng16"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "test"
    system "make", "install"

    # Avoid rebuilds of dependants that hardcode this path.
    inreplace lib/"pkgconfig/libpng.pc", prefix, opt_prefix
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <png.h>

      int main()
      {
        png_structp png_ptr;
        png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, NULL, NULL, NULL);
        png_destroy_write_struct(&png_ptr, (png_infopp)NULL);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lpng", "-o", "test"
    system "./test"
  end
end
