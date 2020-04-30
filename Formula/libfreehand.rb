class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.2.tar.xz"
  sha256 "0e422d1564a6dbf22a9af598535425271e583514c0f7ba7d9091676420de34ac"
  revision 5

  bottle do
    cellar :any
    sha256 "6ea892e891e67ea424aa24ef77c3f98dcb335c2bf3411db7a543fb4ac7af7ab5" => :catalina
    sha256 "069885d6f09b90b64a25794c31680945d97a11267946368e8c7aec55983d2524" => :mojave
    sha256 "540a2406f37a7d2d4c1889304b8d33a7fb093624839b59622aa0adb99458066c" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  # remove with version >=0.1.3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7bb2149f314dd174f242a76d4dde8d95d20cbae0/libfreehand/0.1.2.patch"
    sha256 "abfa28461b313ccf3c59ce35d0a89d0d76c60dd2a14028b8fea66e411983160e"
  end

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
