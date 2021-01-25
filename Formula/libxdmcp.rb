class Libxdmcp < Formula
  desc "X.Org: X Display Manager Control Protocol library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXdmcp-1.1.3.tar.bz2"
  sha256 "20523b44aaa513e17c009e873ad7bbc301507a3224c232610ce2e099011c6529"
  license "MIT"

  bottle do
    cellar :any
    sha256 "87be4ae9085ab662369dfefff8a1c0b2fd24142ecfb905e8dea4efd09e1ecae1" => :big_sur
    sha256 "6c17c65a3f5768a620bc177f6ee189573993df7337c6614050c28e400dc6320c" => :arm64_big_sur
    sha256 "123c77fba2179591f3c1588808f33d231e9e04d8a91c99f6684d2c7eb64626b0" => :catalina
    sha256 "1684eb0ed9e92430971293f58347b9b6de899998bf03be9a19e21f69db65b53f" => :mojave
    sha256 "bff6a7f6da6c59277ca41503e66d6b778b6f89c2d1fc9047fde56ae028e3cda4" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "xorgproto"

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
      #include "X11/Xdmcp.h"

      int main(int argc, char* argv[]) {
        xdmOpCode code;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
