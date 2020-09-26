class Libxi < Formula
  desc "X.Org: Library for the X Input Extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXi-1.7.10.tar.bz2"
  sha256 "36a30d8f6383a72e7ce060298b4b181fd298bc3a135c8e201b7ca847f5f81061"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxext"
  depends_on "libxfixes"
  depends_on "xorgproto"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
      --enable-specs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/extensions/XInput.h"

      int main(int argc, char* argv[]) {
        XDeviceButtonEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
