class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "https://www.libdivecomputer.org/"
  url "https://www.libdivecomputer.org/releases/libdivecomputer-0.6.0.tar.gz"
  sha256 "a0fe75b7e5f7d8b73bfe46beb858dde4f5e2b2692d5270c96e69f5cb34aba15a"
  head "https://git.code.sf.net/p/libdivecomputer/code.git"

  bottle do
    cellar :any
    sha256 "77d221b1a1761aaab3beb86663f18f2610874a9b95158aef7b5620f12bc39310" => :catalina
    sha256 "d27cbe3800c83225dade44ea62ae7ddfa4018866ed1a6628b6f3bda6abf68df7" => :mojave
    sha256 "09dd65b72be93f3364b0b0da389fc4aa4d1fea2094ffe53275544e74ac6a7674" => :high_sierra
    sha256 "bbc60092aee1409bd0001e2f3cfdde47bb3d2348d3bf18f1fc6921920607f947" => :sierra
    sha256 "507134023caaaebd5b1689f324aea50839e13f57d180f7134ee270edc2b02cf6" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "autoreconf", "--install" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libdivecomputer/context.h>
      #include <libdivecomputer/descriptor.h>
      #include <libdivecomputer/iterator.h>
      int main(int argc, char *argv[]) {
        dc_iterator_t *iterator;
        dc_descriptor_t *descriptor;
        dc_descriptor_iterator(&iterator);
        while (dc_iterator_next(iterator, &descriptor) == DC_STATUS_SUCCESS)
        {
          dc_descriptor_free(descriptor);
        }
        dc_iterator_free(iterator);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -ldivecomputer
    ]
    system ENV.cc, "-v", "test.c", "-o", "test", *flags
    system "./test"
  end
end
