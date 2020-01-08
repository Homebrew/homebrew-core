class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.5.tar.xz"
  sha256 "6ace5c499a8be34ad871e825442ce388614ae2d8675c4381756a7319429e3a48"

  bottle do
    cellar :any
    sha256 "1c27e4e351f32291d89656aa08d9a88202e8fe85858ca55264f1a2ea3fb90694" => :catalina
    sha256 "d5362604839f1948a8b594c53e2db0c1bd419ab63c59e158813d56e916d7201f" => :mojave
    sha256 "99fe39b40cf1977d09536fd15fa7557042c200e5848424b98b1b67fa8ed54198" => :high_sierra
    sha256 "78dec5bba67665dc518c0eb579ed2c0d00065ee5c1ac6da234f05e0c9d734c83" => :sierra
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
