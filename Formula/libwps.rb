class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.10/libwps-0.4.10.tar.xz"
  sha256 "1421e034286a9f96d3168a1c54ea570ee7aa008ca07b89de005ad5ce49fb29ca"

  bottle do
    cellar :any
    sha256 "15e190d218f3592f8d1114fdb868b271ae5f8fa01ba515d8ee67b4f8926c407b" => :mojave
    sha256 "921f446b2b4fcc0cc52fa9bb66ac8fa64793b1e9c91c65d26e99a0cbe9f823f4" => :high_sierra
    sha256 "40a087dcf1b621edecd982a8f5977f4726176088e761f750a04bced83d414d11" => :sierra
    sha256 "92c01fd9e274ed52cc2c761c85c40ea38f07e7b83deeb988be0968b18c5c9be4" => :el_capitan
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
