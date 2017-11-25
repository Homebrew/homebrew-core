class Libdivecomputer < Formula
  desc "Library for communication with various dive computers"
  homepage "http://www.libdivecomputer.org/"
  url "http://www.libdivecomputer.org/releases/libdivecomputer-0.6.0.tar.gz"
  sha256 "a0fe75b7e5f7d8b73bfe46beb858dde4f5e2b2692d5270c96e69f5cb34aba15a"
  head "https://git.code.sf.net/p/libdivecomputer/code.git"

  bottle do
    cellar :any
    sha256 "4e7fbffd31ead052c6beefd62d1cb54ae11a2ac40c7b541a577d7cef2c28ecd4" => :high_sierra
    sha256 "421c9cdb2470f048f039398f4d7ed1d2cf9246ff1e45d818a1fd6694b35cc61d" => :sierra
    sha256 "9b4dfa981e34e9cb9a7649d2937ee1825f56fe03ba36668b8d2829bc4a898860" => :el_capitan
    sha256 "d315349ff5b91d9366eeab3fe2d68feab74f43f0dae453ed6c8eb5502215494f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "libusb" => :recommended

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
