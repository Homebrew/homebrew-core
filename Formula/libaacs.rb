class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.11.0/libaacs-0.11.0.tar.bz2"
  sha256 "6d884381fbb659e2a565eba91e72499778635975e4b3d6fd94ab364a25965387"
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "edf22602c987a889624eb8feb1ef3c13b8bbbb2397af0d4334379992c85b492b" => :big_sur
    sha256 "dcbccde309919c3349987341fda3259e218549d5ec5c34c38c628ff6ada98bce" => :arm64_big_sur
    sha256 "74f17ba980a3b1d763f09869541542716979e8fe8e6ee299a00a9d5fe68bbb5b" => :catalina
    sha256 "97fbb158456e2b35633e387e239a5ccc5e90041a0bba15a139dbf32ea4de872b" => :mojave
    sha256 "6ac467398d3fb886cee220bd7724f1341631b1ac31220e3ee504d687347a731f" => :high_sierra
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
