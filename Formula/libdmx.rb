class Libdmx < Formula
  desc "X.Org: X Window System DMX (Distributed Multihead X) extension library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libdmx-1.1.4.tar.bz2"
  sha256 "253f90005d134fa7a209fbcbc5a3024335367c930adf0f3203e754cf32747243"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
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
      #include "X11/extensions/dmxext.h"

      int main(int argc, char* argv[]) {
        DMXScreenAttributes attributes;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
