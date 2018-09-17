class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.4.tar.xz"
  sha256 "e7a7e8b00a3df5798110024d7061fe9d1c3330277d2e4fa9213294f966a4a66d"
  revision 4

  bottle do
    cellar :any
    sha256 "62ea32034d21096d36a310b356123b5bcbdd186166948d7fb5f3a7615960073a" => :mojave
    sha256 "dae641948636f81478a52a2c12c7d6c8cc0e9f55c8c84189aa8de414dd203a37" => :high_sierra
    sha256 "c390fa73e58dfca988c22edbceb924121e31626e3b7615299332331c24a3f250" => :sierra
    sha256 "bd3236bfd5383a7e98226b41a743f661e407df92f8b15672bd61bbea537a2805" => :el_capitan
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
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
