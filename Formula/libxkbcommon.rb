class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.8.2.tar.xz"
  sha256 "7ab8c4b3403d89d01898066b72cb6069bddeb5af94905a65368f671a026ed58c"

  bottle do
    sha256 "95c1b24529a35cc2653397c3d7505fa26332e531264163e3ca6c96b15fef9a67" => :mojave
    sha256 "68c2c32d4a35e4c7b3984fd4df45b29aef77a3cb74da4bb301ce9e3fff86f2ff" => :high_sierra
    sha256 "b8deb446b227b5d6b19e752083486168f76e9c911e542b2cad2bf00f310612ec" => :sierra
    sha256 "ca1f6ac28d09ce0178b219003a3368e60ed3c7de36ec48cb9ea8c57eb844e643" => :el_capitan
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
