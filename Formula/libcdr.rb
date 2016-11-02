class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.3.tar.xz"
  sha256 "66e28e502abef7f6f494ce03de037d532f5e7888cfdee62c01203c8325b33f22"

  bottle do
    cellar :any
    sha256 "a5a0b4baa11bc9b16f0cc622a084820c48244a46a418bb8601aaf06df767e812" => :sierra
    sha256 "1fc79e7941d8f11bf40ed29d16a861cc479666daf9cc0c0aff38c34a2fbd69d4" => :el_capitan
    sha256 "d9e03af78b3587210c53e3121b43a2eb4062b51853c80bfc1245cffc882178d3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "cppunit" => :build
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
                                "-lcdr-0.1"
    system "./test"
  end
end
