class Librevenge < Formula
  desc "Base library for writing document import filters"
  homepage "https://sourceforge.net/p/libwpd/wiki/librevenge/"
  url "https://dev-www.libreoffice.org/src/librevenge-0.0.4.tar.bz2"
  mirror "https://downloads.sourceforge.net/project/libwpd/librevenge/librevenge-0.0.4/librevenge-0.0.4.tar.bz2"
  sha256 "c51601cd08320b75702812c64aae0653409164da7825fd0f451ac2c5dbe77cbf"

  bottle do
    cellar :any
    sha256 "42b53d00d39a37a0173cf227f8a72915b8ae15c90d527ed87344800f63ba865b" => :catalina
    sha256 "8621d9448ed04170c2990e1e002822a5d609310a968701684cb17204f4db643c" => :mojave
    sha256 "807378d354736300cb44c4e5105b0fc0bff09a4fe14fcb3a0cae40c7bf167fee" => :high_sierra
    sha256 "2f8a2a371c35b578d181d1ce8d45084a2f699bbed95cabd10f5cd75977249542" => :sierra
    sha256 "827a37488cc92f16ba8f4d7343e7944c7faed4b8cf9d930f49d93e4104784c94" => :el_capitan
    sha256 "a95c4fc2b7832e226d21a209811a2f149b8fde4962d07d354e3a6cb80b7f0a01" => :yosemite
    sha256 "45c4df842b9cf38554efeb4d04f2c2abf2ed8341e0fb4bc0d80830e02e1fbfeb" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "boost"

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
      #include <librevenge/librevenge.h>
      int main() {
        librevenge::RVNGString str;
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-lrevenge-0.0",
                   "-I#{include}/librevenge-0.0", "-L#{lib}"
  end
end
