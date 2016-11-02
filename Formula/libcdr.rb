class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.3.tar.xz"
  sha256 "66e28e502abef7f6f494ce03de037d532f5e7888cfdee62c01203c8325b33f22"
  revision 1

  bottle do
    cellar :any
    sha256 "2b3389e982b7ce3410a003791bedf744fd20de2d6c80dc16720903665f16c01e" => :sierra
    sha256 "f3ccdcc4f8969d3d4cc4769d8019cdc2ecd3619128f3aa7011ad623fe89d220f" => :el_capitan
    sha256 "18d3572f9f3c5bfe5084b339d970d64b3dea8371b5413ffc3874e18d14826be4" => :yosemite
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
