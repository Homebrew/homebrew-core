class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "http://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.2.tar.bz2"
  sha256 "d05a986dab9f960e64466072653a900d03f8257b084440d9d16599e16060581e"
  revision 1

  bottle do
    cellar :any
    sha256 "1e78ea129bf0b8d7f9ad362a314ba17000ce7efcbe5641b34d0a4afbc963fce1" => :sierra
    sha256 "b0e31c34dc7cce343d5f3a52b796ee922130378520845d76865d3d2eed133abd" => :el_capitan
    sha256 "1edc9447e7f36698e1d1ed188948f87188e98e407edfb685cc25312cca450784" => :yosemite
    sha256 "b7a494d1b5e726c3bf107f158e2a5d4edd898102e9371509eb86c9c845b123f6" => :mavericks
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
