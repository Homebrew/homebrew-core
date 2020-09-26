class Libfs < Formula
  desc "X.Org: X Font Service client library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libFS-1.0.8.tar.bz2"
  sha256 "c8e13727149b2ddfe40912027459b2522042e3844c5cd228c3300fe5eef6bd0f"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
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
      #include "X11/fonts/FSlib.h"

      int main(int argc, char* argv[]) {
        FSExtData data;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
