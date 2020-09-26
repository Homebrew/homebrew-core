class Libxfont < Formula
  desc "X.Org: Core of the legacy X11 font system"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfont-1.5.4.tar.bz2"
  sha256 "1a7f7490774c87f2052d146d1e0e64518d32e6848184a18654e8d0bb57883242"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xtrans" => :build
  depends_on "freetype"
  depends_on "libfontenc"
  depends_on "xorgproto"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-devel-docs=no
      --with-freetype-config=#{Formula["freetype"].opt_bin}/freetype-config
      --with-bzip2
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/fonts/fntfilst.h"
      #include "X11/fonts/bitmap.h"

      int main(int argc, char* argv[]) {
        BitmapExtraRec rec;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
