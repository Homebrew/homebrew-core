class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.6.tar.xz"
  sha256 "01cd00b04a030977e544433c2d127c997205332cd9b8e35ec0ee17110da7f861"
  revision 1

  bottle do
    cellar :any
    sha256 "37f8eb2002652e012fc3c5bf198e037b486c3e34eefa2e2f2071e46553eb8b25" => :catalina
    sha256 "1450bf2a4060155b27a8a196de47b1fe94127e77c539a5eace7b6720227a3382" => :mojave
    sha256 "912ed7894574588d6a992ade59b9c6878a25950f668591513a4b2977c5ab9aba" => :high_sierra
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
