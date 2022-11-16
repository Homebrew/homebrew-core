class Libxmu < Formula
  desc "X.Org: X miscellaneous utility routines library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXmu-1.1.4.tar.xz"
  sha256 "210de3ab9c3e9382572c25d17c2518a854ce6e2c62c5f8315deac7579e758244"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "48d915487711edb1aa70ed5a9eb26624d831adda4728e59ce2337b07c4ee18a3"
    sha256 cellar: :any,                 arm64_monterey: "865801c4562cf8ad72721958220699028dcfecb68f6459a7cbcb7bac43839d19"
    sha256 cellar: :any,                 arm64_big_sur:  "2c878690e28c5bfb3304bf4259d8f0475dbcf36d7077b5377ac1de40178d17e6"
    sha256 cellar: :any,                 ventura:        "ec9239a99aa12ea41491bc239debd28be6694a33da38178f5a33bf3c6cfd607d"
    sha256 cellar: :any,                 monterey:       "a392f317ee3058d06fedae373c6cecb877cb133a2ffb641d36bf747dacccb56a"
    sha256 cellar: :any,                 big_sur:        "e61c1b86464e8a59752950147cf8d3a9eba8f982b7915f36f1ed4b9d1a79c933"
    sha256 cellar: :any,                 catalina:       "d68bead5ce8b3ba9c3a7620c6e6e8fd78dd0f0fab612ede85a77753d6f412006"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6d7093b508915146ef2cf2b351da4f98a5a5c8e96f706dd6801de5429968cb1"
  end

  depends_on "pkg-config" => :build
  depends_on "libxext"
  depends_on "libxt"

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
      #include "X11/Xlib.h"
      #include "X11/Xmu/Xmu.h"

      int main(int argc, char* argv[]) {
        XmuArea area;
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lXmu"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
