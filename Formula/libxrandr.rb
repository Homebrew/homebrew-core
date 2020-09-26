class Libxrandr < Formula
  desc "X.Org: X Resize, Rotate and Reflection extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXrandr-1.5.2.tar.bz2"
  sha256 "8aea0ebe403d62330bb741ed595b53741acf45033d3bda1792f1d4cc3daee023"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxrender"
  depends_on "xorgproto"

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
      #include "X11/Xlib.h"
      #include "X11/extensions/Xrandr.h"

      int main(int argc, char* argv[]) {
        XRRScreenSize size;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
