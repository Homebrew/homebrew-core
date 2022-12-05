class Libxv < Formula
  desc "X.Org: X Video (Xv) extension"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXv-1.0.12.tar.xz"
  sha256 "aaf7fa09f689f7a2000fe493c0d64d1487a1210db154053e9e2336b860c63848"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "74132eb9f813efedfd33e9988f0a68771e96b07cde4cbf990eb65f929e8a0713"
    sha256 cellar: :any,                 arm64_monterey: "751c8a6567964980074d171404e6fe855a180cd64aa31e401bf388278e48556e"
    sha256 cellar: :any,                 arm64_big_sur:  "b5dfdcfaf4be9e446ffa3fb494fbd70ca7e141bd6e35a9a5b14416f0edce0730"
    sha256 cellar: :any,                 ventura:        "7f2d42a4ac6c26e9b81cc88d74dd8c5c8869f515ae3d6912b81c4c8f2d24a5aa"
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
