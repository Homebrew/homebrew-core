class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.3.tar.xz"
  sha256 "f0225f0ff03f6bec4847d7c2d8719a36cafc4b97a09e504b610372cc5b981c97"

  bottle do
    cellar :any
    sha256 "bd35b73b9a1d0a740a113dfd921f62a103cd66c83018b027a1a97415509a6732" => :high_sierra
    sha256 "1e00c58cbc9530cf5bf0a344cf2aaa16e5613c88ab4e3883668975917cc05a95" => :sierra
    sha256 "1fec7ae574d1addc7d6f89fb6b4bd5212b88e431add06b656a204a2a41708e09" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "libwpd"
  depends_on "icu4c"
  depends_on "librevenge"

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
      #include <librevenge-stream/librevenge-stream.h>
      #include <libmspub/MSPUBDocument.h>
      int main() {
          librevenge::RVNGStringStream docStream(0, 0);
          libmspub::MSPUBDocument::isSupported(&docStream);
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-lmspub-0.1", "-I#{include}/libmspub-0.1",
                    "-L#{lib}", "-L#{Formula["librevenge"].lib}"
    system "./test"
  end
end
