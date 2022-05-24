class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 11

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d60cfbaeaa186d7c12f52e8e87061e003dc1d2d787936b74d626e58aebda28b4"
    sha256 cellar: :any,                 arm64_big_sur:  "b71ae096f6e3c708e1dd259998c918f047bf0c584f46b154c9b128cb2fd398de"
    sha256 cellar: :any,                 monterey:       "5ec35402768596402e87df3c1ec3f5a2959eea5fa64c96748e2fb82ba9ee9137"
    sha256 cellar: :any,                 big_sur:        "07380fc76e573cabf43926740e27dd943f0b8efd2c66537befd750f63429907e"
    sha256 cellar: :any,                 catalina:       "6d5024ba3736210442d3be7d48ec1c266363d90f0a2f5eb789c46fdf2720bb59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e34106510e2efca8e914ec52a1acc8d9d2d7c9cd536fcbe72627885c7dcfd1a"
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
