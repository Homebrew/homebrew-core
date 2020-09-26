class Libxau < Formula
  desc "X.Org: A Sample Authorization Protocol for X"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXau-1.0.9.tar.bz2"
  sha256 "ccf8cbf0dbf676faa2ea0a6d64bcc3b6746064722b606c8c52917ed00dcb73ec"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
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
      #include "X11/Xauth.h"

      int main(int argc, char* argv[]) {
        Xauth auth;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
