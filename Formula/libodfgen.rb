class Libodfgen < Formula
  desc "ODF export library for projects using librevenge"
  homepage "https://sourceforge.net/p/libwpd/wiki/libodfgen/"
  url "https://dev-www.libreoffice.org/src/libodfgen-0.1.8.tar.xz"
  mirror "https://downloads.sourceforge.net/project/libwpd/libodfgen/libodfgen-0.1.8/libodfgen-0.1.8.tar.xz"
  sha256 "55200027fd46623b9bdddd38d275e7452d1b0ff8aeddcad6f9ae6dc25f610625"
  license any_of: ["MPL-2.0", "LGPL-2.1-or-later"]

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libodfgen[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 1
    sha256 "6a3053ee1b3385554059754b2d0def398f6fe78955cdd00f4a2f96dd40659090" => :big_sur
    sha256 "bd0fbb2ad04609ee8c4f39caad570b715295d08d93c579ec1e8d5b92ed1023b0" => :arm64_big_sur
    sha256 "25fb42ad5715c87c0a23547b59515aa5c0d7cba2e0a5d09d2d2a8eeb06217677" => :catalina
    sha256 "f90434da376c3af4b55640d1c5a870c28339a9174dfda56b7bc79dc6b6b60ec8" => :mojave
    sha256 "b80178fdbf5ca0816879466adc8fbedd671d57db3378ee3c708fefdf9b8f87e3" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "libetonyek" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--without-docs",
                          "--disable-dependency-tracking",
                          "--enable-static=no",
                          "--with-sharedptr=boost",
                          "--disable-werror",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libodfgen/OdfDocumentHandler.hxx>
      int main() {
        return ODF_FLAT_XML;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
      "-lrevenge-0.0",
      "-I#{Formula["librevenge"].include}/librevenge-0.0",
      "-L#{Formula["librevenge"].lib}",
      "-lodfgen-0.1",
      "-I#{include}/libodfgen-0.1",
      "-L#{lib}"
    system "./test"
  end
end
