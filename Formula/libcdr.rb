class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.4.tar.xz"
  sha256 "e7a7e8b00a3df5798110024d7061fe9d1c3330277d2e4fa9213294f966a4a66d"
  revision 1

  bottle do
    cellar :any
    sha256 "f6b143bfe94f06336056675105bbcab520daed7bc3e59c04a4cb707d1b305bdf" => :high_sierra
    sha256 "d8e16c30d8921fd8a95ccad74c4be62fc664b1a669e35e7acddd8e2ecd8a3e47" => :sierra
    sha256 "e14154c7eadbd4157c3fa754017f2b8f0bacf36da0fe1d50ff9b3fd8067e3ad9" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cppunit" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    ENV.cxx11
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
    system "./configure", "--disable-werror",
                          "--without-docs",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
