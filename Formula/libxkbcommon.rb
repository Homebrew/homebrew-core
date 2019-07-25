class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.8.4.tar.xz"
  sha256 "60ddcff932b7fd352752d51a5c4f04f3d0403230a584df9a2e0d5ed87c486c8b"

  bottle do
    cellar :any
    sha256 "d11930a50f52bee01e250ae80e1972a12f10a422bb885df42befdb4784f3a983" => :mojave
    sha256 "da3a6ad4c591da868a4aeb245b9311181a03d4392e82cc5159d24740c8695b86" => :high_sierra
    sha256 "6b78ab52d77c4c1c81485d4071298a38a78ec1d74e55e57786d833ea8ecc58af" => :sierra
  end

  head do
    url "https://github.com/xkbcommon/libxkbcommon.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on :x11

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
