class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.8/libwps-0.4.8.tar.xz"
  sha256 "e478e825ef33f6a434a19ff902c5469c9da7acc866ea0d8ab610a8b2aa94177e"

  bottle do
    cellar :any
    sha256 "b08c28a05de4a8b4b4ee4cc369506edc734b887c3889f1dc229aa7b1ac9a2fa9" => :high_sierra
    sha256 "56b08bd7d8b0dc043ca0bb20db5ba9efd4e03230001fc0c4c3217ef1a1c5ee49" => :sierra
    sha256 "38807433700d4de6975e85b45ea2e795c012cdc96810ef2d49b1cf5e7eddcb4b" => :el_capitan
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
