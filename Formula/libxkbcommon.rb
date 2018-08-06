class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.8.2.tar.xz"
  sha256 "7ab8c4b3403d89d01898066b72cb6069bddeb5af94905a65368f671a026ed58c"

  bottle do
    sha256 "312c64c48750fc47521bcb885c7df0e1861faefe860f56a3da07ab21ceab82ee" => :high_sierra
    sha256 "c62af888dc0c7440c5c7c3554fa0525a74164a1fc64d6a96c3287bb62e923073" => :sierra
    sha256 "118510c232bf71eb5dd5c2601a07a47d9c478053359e5bad0eb05705d7645e05" => :el_capitan
  end

  head do
    url "https://github.com/xkbcommon/libxkbcommon.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :x11
  depends_on "bison" => :build
  depends_on "pkg-config" => :build

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
