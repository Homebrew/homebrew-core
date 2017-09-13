class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.3.tar.xz"
  sha256 "66e28e502abef7f6f494ce03de037d532f5e7888cfdee62c01203c8325b33f22"
  revision 3

  bottle do
    cellar :any
    sha256 "4d0c8dedeaf32a7dee5ca6f66bf50c5a18c2fbd78b53430f45503bdbf06cd39d" => :sierra
    sha256 "2d892c2038af0be3292fe3fc19865fa0dc72de76bcdb7241139e290ba06c5724" => :el_capitan
    sha256 "9790438fa6f9dd4140984d951f3525e53363efcde0c7897cb498a04caf94ef8e" => :yosemite
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
    (testpath/"test.cpp").write <<-EOS.undent
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
