class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 12

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "6beeba33de3a77318d2072e29a9526aec45f8402c9ebe4b9cdb2706b47318283"
    sha256 cellar: :any,                 arm64_big_sur:  "2885a8e55e3a5f7d888c0a75a5ccc2955dd9917246531c760e5195bfc09de281"
    sha256 cellar: :any,                 monterey:       "10616dfa83cd78355352afa80411c49054c0bd7b19eabcf51328c13d0d4124dd"
    sha256 cellar: :any,                 big_sur:        "946974c09dc55804597ef309307ec7f5075fc2f9b94ad3325d0a9214eaa39876"
    sha256 cellar: :any,                 catalina:       "1611d6040a54bde36839db3ba89610e375c240265d8ac757a75c5785f0ffafab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ce7135a4964fbb0de251ee2a6ebc7b3cbf8a8412e02eea1281c69b17f38939a"
  end

  depends_on "boost" => :build
  depends_on "libwpg" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "libwpd"

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
