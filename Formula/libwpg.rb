class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "https://libwpg.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpg-0.3.3.tar.xz"
  sha256 "99b3f7f8832385748582ab8130fbb9e5607bd5179bebf9751ac1d51a53099d1c"

  bottle do
    cellar :any
    sha256 "d12ae12e729a2d2e327f07fe927e02dd15151a987b7cab0a19ca94ee15f8cfde" => :catalina
    sha256 "162171b22e6df4f4f4169634fc6872d40bea9a17a9c49e01dd737e9d74b1d445" => :mojave
    sha256 "dd0c4dc2a9369d7d6b97f930dd63e6f4ddd9d12d0372c12e13d2a22cf6a0cd06" => :high_sierra
    sha256 "cf9ab0d990b3fccb101312999f6d0ea5980990edd279ae994cf3c7f9c33a7d55" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwpg/libwpg.h>
      int main() {
        return libwpg::WPG_AUTODETECT;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpg-0.3",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpg-0.3", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end
