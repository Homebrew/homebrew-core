class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "https://libwpg.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpg-0.3.2.tar.xz"
  sha256 "57faf1ab97d63d57383ac5d7875e992a3d190436732f4083310c0471e72f8c33"

  bottle do
    cellar :any
    sha256 "3b4dc04c896972980242d47d138cec836921ceb31b4cb09ecfe516b3a263544d" => :high_sierra
    sha256 "fe76db6238dd00ce05a0ba9c9c80b69cc18b431fa0c7198b23be67cf9e609e76" => :sierra
    sha256 "0e2dbed131e06e439dfda9ba83b429def82964cb17f6c418adfb321931014c84" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libwpd"
  depends_on "librevenge"

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
    system ENV.cc, "test.cpp", "-o", "test",
                   "-lrevenge-0.0", "-I#{Formula["librevenge"].include}/librevenge-0.0",
                   "-lwpg-0.3", "-I#{include}/libwpg-0.3"
    system "./test"
  end
end
