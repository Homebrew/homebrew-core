class Libaacs < Formula
  desc "Implements the Advanced Access Content System specification"
  homepage "https://www.videolan.org/developers/libaacs.html"
  url "https://download.videolan.org/pub/videolan/libaacs/0.9.0/libaacs-0.9.0.tar.bz2"
  sha256 "47e0bdc9c9f0f6146ed7b4cc78ed1527a04a537012cf540cf5211e06a248bace"

  bottle do
    cellar :any
    rebuild 1
    sha256 "02b04ab4f2f48ab65fec5a79756df19ed7dccc9b58006fb861d2ff66c266aff1" => :sierra
    sha256 "9c7aed37c3991fd326c976c498423a1df4801f3ef65c8bc7a8b68a8a87f1bc31" => :el_capitan
    sha256 "5b7526780e9ad562555a03d2d3d66c6aabdc9b0502aad0537b5588ab568fca6f" => :yosemite
    sha256 "d440c657e0cfd21cc6e8b86bed857a731f8cd80fa574a5366a5c70fb6192bbd7" => :mavericks
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
