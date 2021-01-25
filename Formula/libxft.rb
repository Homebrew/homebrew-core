class Libxft < Formula
  desc "X.Org: X FreeType library"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/libXft-2.3.3.tar.bz2"
  sha256 "225c68e616dd29dbb27809e45e9eadf18e4d74c50be43020ef20015274529216"
  license "MIT"

  bottle do
    cellar :any
    sha256 "5351d66133130a06528dbb2c4e5f68b96b3373df1fe632436586143d2a99d3f6" => :big_sur
    sha256 "f0b3ad1d1305417c5f3d8721a7a5cf1311b464cad8c99a94e4e1468cd756498d" => :arm64_big_sur
    sha256 "468e6b59613df1504055545f7e1662141b159b158856b41288f017e2b975e852" => :catalina
    sha256 "c571235a69c34bf95279c8e415b34f8c8fad9a21eac4a05c55b1beec584f6757" => :mojave
    sha256 "d8a6efe662c060ebe7a638fcd4b1ffc3ba34beb53586827cef583948be17b802" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "libxrender"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
      #include "X11/Xft/Xft.h"

      int main(int argc, char* argv[]) {
        XftFont font;
        return 0;
      }
    EOS
    system ENV.cc, "-I#{Formula["freetype"].opt_include}/freetype2", "test.c"
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
