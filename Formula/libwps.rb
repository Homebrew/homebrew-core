class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.6/libwps-0.4.6.tar.xz"
  sha256 "e48a7c2fd20048a0a8eaf69bad972575f8b9f06e7497c787463f127d332fccd0"

  bottle do
    cellar :any
    sha256 "bc2f7b7cd3b38e38c6f6ed0423406340f33c4719e4c4833a0f2af8e0df0d58a2" => :sierra
    sha256 "955cec0a064444c0c6db350b7c3a55b72b9382a98dae5060e25d78b928267fbb" => :el_capitan
    sha256 "b747ff7cf50572bfe44fa363f8e9a987d8a5c27f07315a6ca15c0e6903e75d82" => :yosemite
    sha256 "f41d5d0f77a02ed7f903a1761a5aabe7847f8dd4e6bf19c9aacd54924d7abcc6" => :mavericks
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
    (testpath/"test.cpp").write <<-EOS.undent
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
