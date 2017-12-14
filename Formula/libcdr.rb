class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.4.tar.xz"
  sha256 "e7a7e8b00a3df5798110024d7061fe9d1c3330277d2e4fa9213294f966a4a66d"
  revision 2

  bottle do
    cellar :any
    sha256 "692a27c7734faa0e75501e17605705c211361a77df76546acfc0f3cfc1c6c411" => :high_sierra
    sha256 "e6be25872e9fa42238f6531b6be50a041d167ffbcc9e4c430e6a703e8392eea5" => :sierra
    sha256 "be445fd52deffdef179bac32d01f66b9bb687c878c798f26feda73822cfd5ae5" => :el_capitan
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
