class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.11/libwps-0.4.11.tar.xz"
  sha256 "a8fdaabc28654a975fa78c81873ac503ba18f0d1cdbb942f470a21d29284b4d1"

  bottle do
    cellar :any
    sha256 "61b3ad745560c34d24735c1459f418ab083ea80aba8b0b6a64595fafd1916a4a" => :catalina
    sha256 "ca320b85cbcd3f8bf8d17bc5133c99fb83509d88e2e7c5cff4da6c11b2df36ad" => :mojave
    sha256 "ab40a8031a5971abede418b01d851e3ad3031da72f42ad9e5e4a7ac40b6acc0e" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwps/libwps.h>
      int main() {
        return libwps::WPS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-lrevenge-0.0",
                  "-I#{Formula["librevenge"].include}/librevenge-0.0",
                  "-L#{Formula["librevenge"].lib}",
                  "-lwpd-0.10",
                  "-I#{Formula["libwpd"].include}/libwpd-0.10",
                  "-L#{Formula["libwpd"].lib}",
                  "-lwps-0.4", "-I#{include}/libwps-0.4", "-L#{lib}"
    system "./test"
  end
end
