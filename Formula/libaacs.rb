class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.10.0/libaacs-0.10.0.tar.bz2"
  sha256 "93f6b19ef71e6f73e77bd7535946c09c45330e9b42e832a63a1d6b042f6b12fe"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "e9b92a8a0921ccc76b834210a298e871148948bf01d562e1c2f307de5095b6c0" => :catalina
    sha256 "4eff01204a5115988718468241e81c01ba901bcdab8f39b0e39e13ba62d9076e" => :mojave
    sha256 "abf416c4f94479b975de2ffb3d156207be78ab056b020018b80d11661772d3b8" => :high_sierra
  end

  head do
    url "https://code.videolan.org/videolan/libaacs.git"

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
    (testpath/"test.c").write <<~EOS
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
