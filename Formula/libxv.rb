class Libxv < Formula
  desc "X.Org: X Video (Xv) extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXv-1.0.11.tar.bz2"
  sha256 "d26c13eac99ac4504c532e8e76a1c8e4bd526471eb8a0a4ff2a88db60cb0b088"
  license "MIT"

  bottle do
    cellar :any
    sha256 "9449b8a36bcaedf03b437b4ebb8fcfd4f1a421c4e9aa39c736bc9ca374a32427" => :big_sur
    sha256 "b5dfdcfaf4be9e446ffa3fb494fbd70ca7e141bd6e35a9a5b14416f0edce0730" => :arm64_big_sur
    sha256 "9e4adc6980cd27f0261b5858d8c660db9b42f2303fdeb579d7f14c982f2cd615" => :catalina
    sha256 "6e32200b7d439f9255e2f5c6c19cb329fe5efd4f51a3ecf681e85320e1a41d5d" => :mojave
    sha256 "e94ca27db4487e4af4a906297a184db021d66b3f254332331cb3bb6f5d21fd09" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
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
      #include "X11/extensions/Xvlib.h"

      int main(int argc, char* argv[]) {
        XvEvent *event;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
