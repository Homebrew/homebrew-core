class Libdivecomputer < Formula
  desc "Library for communication with various dive computers."
  homepage "http://www.libdivecomputer.org"
  url "http://www.libdivecomputer.org/releases/libdivecomputer-0.4.2.tar.gz"
  sha256 "f3c5d0229de9dd82602e309273d0eb48fb0ee07fdcfc1ff8206edb6ba5154460"
  head "git://git.code.sf.net/p/libdivecomputer/code"

  bottle do
    cellar :any
    sha256 "6fc75308490219d24aafde94f13027e7db3546eb317925ededb0c7b1abae0624" => :sierra
    sha256 "1c9d15bd10811fbb7eccc9c8e718eec6e3b6ee389c586b7dbf9da56323f8f292" => :el_capitan
    sha256 "cad333cf7353aaebb2e32a7d68e2711df4326d65cc7fd44df9b7e50794e361c9" => :yosemite
    sha256 "a0418e0213a4f14612b9d37560a50cdd316ba7fc56da88000ceca4fe37733e18" => :mavericks
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
    (testpath/"test.c").write <<-EOS.undent
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
