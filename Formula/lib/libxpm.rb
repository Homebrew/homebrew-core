class Libxpm < Formula
  desc "X.Org: X Pixmap (XPM) image file format library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXpm-3.5.16.tar.gz"
  sha256 "43a70e6f9b67215fb223ca270d83bdcb868c513948441d5b781ea0765df6bfb4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "2eb0da53c05dabc6eb1625e1883aed741a2d188e45ef463b48e7077e86a0d12e"
    sha256 cellar: :any,                 arm64_ventura:  "c606b23e5c873d1b4d6512170b73135446097b3da8fd22a2295b9a831078fd67"
    sha256 cellar: :any,                 arm64_monterey: "79d7ed885242063ce8ff8b8c3dac461a54c480e36c2108b58921a63b0627989d"
    sha256 cellar: :any,                 arm64_big_sur:  "a41640093820c6dd6ab1d59a6dc281a9f668375715837ac0f48416d9cc52726f"
    sha256 cellar: :any,                 sonoma:         "fbc8c90a232e8da0fa7b993a90fde83544c48a6f2d24c566a704df93f47c595c"
    sha256 cellar: :any,                 ventura:        "f8a2613321779ce767aed474e6c4671892bba15b1b7de6689b3a6ce242b43598"
    sha256 cellar: :any,                 monterey:       "b1d5967e53caa8c13d325c6f94bf5589cd88fc2b40359d696f6753a219ccc5de"
    sha256 cellar: :any,                 big_sur:        "9e36f85fcf3cd6f64ed3b3bfef33bf139edd6904ccdd6825fe6737b20821090d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1989564ad07e0a2d033fd471e1607185d87d82fb97bf367d80b98f25e2f37c1"
  end

  depends_on "gettext" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "libx11"

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-open-zfile
      --disable-silent-rules
      --disable-stat-zfile
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xlib.h"
      #include "X11/xpm.h"

      int main(int argc, char* argv[]) {
        XpmColor color;
        return 0;
      }
    EOS
    system ENV.cc, "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
