class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-0.7.2.tar.xz"
  sha256 "28a4dc2735863bec2dba238de07fcdff28c5dd2300ae9dfdb47282206cd9b9d8"

  bottle do
    sha256 "f315b5f0587687bfe2a859fc2440980820031a8d984c0b707f468f886953ab0c" => :sierra
    sha256 "b28c61c01bf2b30c2d9250ef4ba8650d3a4040802e2184f1c3673ba717f09ea0" => :el_capitan
    sha256 "87d2bf3128550c3fd80f8d91908c888aa8c19361a189c59a9478af925668710b" => :yosemite
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
    (testpath/"test.c").write <<-EOS.undent
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
