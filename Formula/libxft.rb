class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.3.tar.bz2"
  sha256 "225c68e616dd29dbb27809e45e9eadf18e4d74c50be43020ef20015274529216"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "libxrender"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xft/Xft.h"

      int main(int argc, char* argv[]) {
        XftFont font;
        return 0;
      }
    EOS
    system ENV.cc, "-I#{Formula["freetype"].opt_include}/freetype2", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
