class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.8/libwps-0.4.8.tar.xz"
  sha256 "e478e825ef33f6a434a19ff902c5469c9da7acc866ea0d8ab610a8b2aa94177e"

  bottle do
    cellar :any
    sha256 "af5523256d90cdb6df16716899309e4733d9b21973d50b224d1f4503bc8cbc4a" => :high_sierra
    sha256 "85c11a7406bd2a53e63239f3455c5f205d780d1c487c52779e89507de4c86c72" => :sierra
    sha256 "d9e3474b8f97fb56a76fe0068a075dad95f0905636ff18aa37e4dc77a1019687" => :el_capitan
    sha256 "57cc0b3b1205f97f2af3f38799e160d5eae6bab3dac8bd528f7ebfd4e0a8723c" => :yosemite
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
