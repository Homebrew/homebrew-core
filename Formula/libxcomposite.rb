class Libxcomposite < Formula
  desc "X.Org: Client library for the Composite extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXcomposite-0.4.5.tar.bz2"
  sha256 "b3218a2c15bab8035d16810df5b8251ffc7132ff3aa70651a1fba0bfe9634e8f"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "libxfixes"
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
      #include "X11/extensions/Xcomposite.h"

      int main(int argc, char* argv[]) {
        Display *d = NULL;
        int s = DefaultScreen(d);
        Window root = RootWindow(d, s);
        XCompositeReleaseOverlayWindow(d, s);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lXcomposite", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
