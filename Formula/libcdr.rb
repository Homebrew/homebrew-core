class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.3.tar.xz"
  sha256 "66e28e502abef7f6f494ce03de037d532f5e7888cfdee62c01203c8325b33f22"
  revision 2

  bottle do
    cellar :any
    sha256 "4c59ebfbb12f1d71d26b03899691dc6b62dcde619c53c2f096b8efc91aab6bdc" => :sierra
    sha256 "5984f319a2bc8b3e3fd15daffaf588a737395d5e11813af84bba2884a3ebad1a" => :el_capitan
    sha256 "69e4eeaa9f00aa68c8afde1327adf8a7d84d53fc24a4df0cf2d5d29494ccfba1" => :yosemite
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
                                "-lcdr-0.1"
    system "./test"
  end
end
