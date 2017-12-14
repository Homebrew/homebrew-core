class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.4.tar.xz"
  sha256 "e7a7e8b00a3df5798110024d7061fe9d1c3330277d2e4fa9213294f966a4a66d"
  revision 2

  bottle do
    cellar :any
    sha256 "a1a24122adee68bbb8fe4d2d2cda90def40230fea990a36091eb860bce3ae086" => :high_sierra
    sha256 "4e8fdcf4cdc32e9b9d2dfe00c7ec74fc53e4a4389d13f866b697cce6a6ff05eb" => :sierra
    sha256 "4d5b32ef2b229897a3126e55e231cb878d2ecee165a2b519fa5b298c07b562d3" => :el_capitan
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
