class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.8.0.tar.xz"
  sha256 "e829265db04e0aebfb0591b6dc3377b64599558167846c3f5ee5c5e53641fe6d"

  bottle do
    sha256 "28d51647f3b5abec404ccff46ff0ccb204a83899fa98b3372f2a385d1f75cc33" => :high_sierra
    sha256 "0100185bea1d4c6a8e49ae49c5ef55f62b8632a93ecaf37c947357406ddee22b" => :sierra
    sha256 "aa6f65c02240f22518bfc908063cc1f49962d1de06ef7c49cf1f9bcf03f5f814" => :el_capitan
    sha256 "7e003f5129969f4f3af726469343eebf26e64683521f1c0cf9cde830304a69d0" => :yosemite
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
