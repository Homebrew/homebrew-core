class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.2.tar.xz"
  sha256 "b0baabf82d20c08ad000e80fa02154ce2f2ffde1ee60240d6e3a917c3b35560f"
  revision 4

  bottle do
    cellar :any
    sha256 "8dc43db8ed3ea1fc7cb304412e9efd2986eabc564eeb47bd997102662ea35b51" => :sierra
    sha256 "039cb94e097ce9532881485be1bc3ecb2851d980c97ce5f58e9001155ac8ea78" => :el_capitan
    sha256 "4f00a8ce7da9c37d4b3393b30d0fd4aeaa6752c74d160ab32acd3b321949734b" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "libwpd"
  depends_on "icu4c"
  depends_on "librevenge"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
    #include <librevenge-stream/librevenge-stream.h>
    #include <libmspub/MSPUBDocument.h>
    int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libmspub::MSPUBDocument::isSupported(&docStream);
        return 0;
    }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end
