class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "https://dev-www.libreoffice.org/src/libodfgen-0.1.6.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.6/libodfgen-0.1.6.tar.bz2"
  sha256 "2c7b21892f84a4c67546f84611eccdad6259875c971e98ddb027da66ea0ac9c2"

  bottle do
    cellar :any
    sha256 "f6aaac828b7989327fdc4a9ef4e256c68be09ab8d8cb2c1e4372d527d12506b0" => :mojave
    sha256 "42a2c0bca9c48d8c47bfc54d2b584839dcfe43051c846ddb9d7dd25c449ebe0c" => :high_sierra
    sha256 "d18687624066fd7e4e45a6a72ef03b387189f0e1931f1a64e4c6dcabe99e0ae0" => :sierra
    sha256 "b8b0cd9fb81020c6d6018830d75f75004a8edd9f7034e630937e92512b2ee35f" => :el_capitan
    sha256 "342c71b7855e8a8699638f01f917c29ce85a0d7f695fc2e404446fef3b0eedd4" => :yosemite
    sha256 "a3062a3348ba437f1cad676dd5c3c58e1541b0ec8cdd5413ab165248d18bd63e" => :mavericks
  end

  depends_on "boost" => :build
  depends_on "libetonyek" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--with-sharedptr=boost",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
      "-lrevenge-0.0",
      "-I#{Formula["librevenge"].include}/librevenge-0.0",
      "-L#{Formula["librevenge"].lib}",
      "-lodfgen-0.1",
      "-I#{include}/libodfgen-0.1",
      "-L#{lib}"
    system "./test"
  end
end
