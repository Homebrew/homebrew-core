class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.2.tar.xz"
  sha256 "0e422d1564a6dbf22a9af598535425271e583514c0f7ba7d9091676420de34ac"
  revision 3

  bottle do
    cellar :any
    sha256 "1ae055c035c29cb61ccbf58b426c653d335b6718b3e80f25ce60eaccd15f4001" => :mojave
    sha256 "fd7d65f977cf1261fb28af4fc781c812b29c6417a6e76ec7ead2d10008ad0309" => :high_sierra
    sha256 "9df762663fdac41d4eeb631efbd3ac5a76a2fb3ca9551b359f771c8d1ad3d1a3" => :sierra
    sha256 "97056ac49cee3fcdb9b69a1e7113dd38828a6c4b676d89f72114e2025abfdac5" => :el_capitan
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--disable-werror",
                          "--disable-tests",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libfreehand/libfreehand.h>
      int main() {
        libfreehand::FreeHandDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libfreehand-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lfreehand-0.1"
    system "./test"
  end
end
