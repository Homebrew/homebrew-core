class Libsm < Formula
  desc "X.Org: X Session Management Library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libSM-1.2.3.tar.bz2"
  sha256 "2d264499dcb05f56438dee12a1b4b71d76736ce7ba7aa6efbf15ebb113769cbb"
  license "MIT"

  bottle do
    cellar :any
    sha256 "6b764ce643e30d5d152eede7592e544fbe1baf4ced75a92589d5e6242dfa55cc" => :big_sur
    sha256 "cea6bfd718aebbc61b9c2cc43e107af7872177700366224459d1ba67e570f8b7" => :arm64_big_sur
    sha256 "0cfe06bc49f376e5f770e378097ecf7e261db7d4b3c51740ddfcb86df36815af" => :catalina
    sha256 "35cca1d4348481da2d35f1c91882e9b32604480a15b679efed3209f74ff8d78b" => :mojave
    sha256 "927db02bae25120237de025a8219899d9ed69d8f4669c6662e170a4e0ce9eee2" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xtrans" => :build
  depends_on "libice"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --enable-docs=no
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/SM/SMlib.h"

      int main(int argc, char* argv[]) {
        SmProp prop;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
