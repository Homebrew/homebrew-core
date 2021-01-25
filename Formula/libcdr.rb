class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.6.tar.xz"
  sha256 "01cd00b04a030977e544433c2d127c997205332cd9b8e35ec0ee17110da7f861"
  revision 2

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "ff990e3679d616548a67184a2b5a8030912c7c1a411119dd82c57f29893e2dec" => :big_sur
    sha256 "d1f5de8a24925e0e30822b31805cb73eb5e2c6072e4e88c8fc0f86e7ef992bdb" => :arm64_big_sur
    sha256 "8c07a139f24c7548cfd8eb6b5bba59ab643d0030d05fb52eb2baf7a825a232fa" => :catalina
    sha256 "9a1aff2e64f3d103b416b7bcc07c2431777660eee1466af64d9717cbcca9454b" => :mojave
    sha256 "f602a7919ea9e6921f3597f061b96b466d3291c597c355f410bd340b4b8e23d3" => :high_sierra
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
