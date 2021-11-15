class Libxv < Formula
  desc "X.Org: X Video (Xv) extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXv-1.0.11.tar.bz2"
  sha256 "d26c13eac99ac4504c532e8e76a1c8e4bd526471eb8a0a4ff2a88db60cb0b088"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "751c8a6567964980074d171404e6fe855a180cd64aa31e401bf388278e48556e"
    sha256 cellar: :any,                 arm64_big_sur:  "b5dfdcfaf4be9e446ffa3fb494fbd70ca7e141bd6e35a9a5b14416f0edce0730"
    sha256 cellar: :any,                 monterey:       "07d6b774aba6b179cdfe80de4be23beaaa18b4a1bc168479feec08019efc3734"
    sha256 cellar: :any,                 big_sur:        "9449b8a36bcaedf03b437b4ebb8fcfd4f1a421c4e9aa39c736bc9ca374a32427"
    sha256 cellar: :any,                 catalina:       "9e4adc6980cd27f0261b5858d8c660db9b42f2303fdeb579d7f14c982f2cd615"
    sha256 cellar: :any,                 mojave:         "6e32200b7d439f9255e2f5c6c19cb329fe5efd4f51a3ecf681e85320e1a41d5d"
    sha256 cellar: :any,                 high_sierra:    "e94ca27db4487e4af4a906297a184db021d66b3f254332331cb3bb6f5d21fd09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9408bb5b16ea1a61f962232bef021b36638ec9af5229328e52f932131fd8e37f"
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
