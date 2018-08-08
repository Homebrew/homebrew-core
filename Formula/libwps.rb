class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.10/libwps-0.4.10.tar.xz"
  sha256 "1421e034286a9f96d3168a1c54ea570ee7aa008ca07b89de005ad5ce49fb29ca"

  bottle do
    cellar :any
    sha256 "11c36fe9cef93d57b5d1f94fd4e51777e881a3be854570a1d529653802bcbb20" => :high_sierra
    sha256 "911b3443d51a221888399a5934194a83f44cf0c6ebfb2a2b3e19cdce73cdc08c" => :sierra
    sha256 "a5856fdd6440142ed49bf8bcf9c073f33efb16353c2b846fbfff2d6f8076eed6" => :el_capitan
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
