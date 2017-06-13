class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.9.0/libaacs-0.9.0.tar.bz2"
  sha256 "47e0bdc9c9f0f6146ed7b4cc78ed1527a04a537012cf540cf5211e06a248bace"

  bottle do
    cellar :any
    sha256 "07efaa70031e035a007873916e1e288c830b67095c140e358a71801b044c86a9" => :sierra
    sha256 "89afae75a0b0969298bb38cc14de93b2f8a713d4fa15ab62c7bc0f265003d1d4" => :el_capitan
    sha256 "0b3b29f19f636b25e95321aeffbd54303aec2cbca4641671d825284f6cd81fc7" => :yosemite
  end

  head do
    url "https://git.videolan.org/git/libaacs.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "libgcrypt"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include "libaacs/aacs.h"
      #include <stdio.h>

      int main() {
        int major_v = 0, minor_v = 0, micro_v = 0;

        aacs_get_version(&major_v, &minor_v, &micro_v);

        printf("%d.%d.%d", major_v, minor_v, micro_v);
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-laacs",
                   "-o", "test"
    system "./test"
  end
end
