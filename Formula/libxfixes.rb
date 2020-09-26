class Libxfixes < Formula
  desc "X.Org: Header files for the XFIXES extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXfixes-5.0.3.tar.bz2"
  sha256 "de1cd33aff226e08cefd0e6759341c2c8e8c9faf8ce9ac6ec38d43e287b22ad6"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "libx11"
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
      #include "X11/extensions/Xfixes.h"

      int main(int argc, char* argv[]) {
        XFixesSelectionNotifyEvent event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
