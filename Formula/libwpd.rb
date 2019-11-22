class Libwpd < Formula
  desc "General purpose library for reading WordPerfect files"
  homepage "https://libwpd.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpd-0.10.3.tar.xz"
  sha256 "2465b0b662fdc5d4e3bebcdc9a79027713fb629ca2bff04a3c9251fdec42dd09"

  bottle do
    cellar :any
    sha256 "edb924ac33633d851f162839c2e1ef57734c81bd5a6d3d2cde7750175bd19386" => :catalina
    sha256 "b9cdcbf1e0c875c8666f16a9547386754c40607652b0255d6eda8b2afb2da229" => :mojave
    sha256 "baba04ac2fc8bcd2bbf890f8d7e3e27f7eae3044d960f027634e3d0310447dc8" => :high_sierra
    sha256 "f4ef8b16411ea32e77e35bf0a8109b5f7651931e885ffd4ad7a8933a12d4f749" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libgsf"
  depends_on "librevenge"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwpd/libwpd.h>
      int main() {
        return libwpd::WPD_OK;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpd-0.10",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpd-0.10", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end
