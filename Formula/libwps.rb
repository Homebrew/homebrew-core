class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.6/libwps-0.4.6.tar.xz"
  sha256 "e48a7c2fd20048a0a8eaf69bad972575f8b9f06e7497c787463f127d332fccd0"

  bottle do
    cellar :any
    sha256 "4789fa12f99c524834e073e3a79a6c4a3f87ab5f824d68d8bb8bad39b2355e22" => :sierra
    sha256 "a9586b8344f581eca0a81336e76eeb64b40031c15fe1cba272e3b31123446c7f" => :el_capitan
    sha256 "74d7a3b0bbddb8ac7b3926fb0997762ab4fa69afffaabe43b5d811809b176a43" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpd"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
