class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.6.tar.xz"
  sha256 "01cd00b04a030977e544433c2d127c997205332cd9b8e35ec0ee17110da7f861"
  revision 2

  bottle do
    cellar :any
    sha256 "f86e084ac50639a550db4619bd254ab94421b9a0040242a623da7aaf418e4afe" => :catalina
    sha256 "e43b06246ab43c2038d4770a5d2199c454fd07861e61c4148e929329bf067c32" => :mojave
    sha256 "a99715e61c8e4b1f2219f895b41cbaa51337b85b0f664f3efa11f2141be325ee" => :high_sierra
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
