class Libmspub < Formula
  desc "Interpret and import Microsoft Publisher content"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libmspub"
  url "https://dev-www.libreoffice.org/src/libmspub/libmspub-0.1.4.tar.xz"
  sha256 "ef36c1a1aabb2ba3b0bedaaafe717bf4480be2ba8de6f3894be5fd3702b013ba"
  license "MPL-2.0"
  revision 9

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libmspub[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "45cb1724c6090578335d7ee48cfe590ab469620264ecf16f6f4a7710624c211f"
    sha256 cellar: :any, big_sur:       "580e4da606a71e3fbeae8323b827ce2c0a524e901c904629017c6f0851644282"
    sha256 cellar: :any, catalina:      "a14affcde354ef2e23a209d12e92b883f39bb43c362906e12d788adf66b79bb6"
    sha256 cellar: :any, mojave:        "6d4e9078899e4fb53ef5d08662b752dda10960b4afee8b0bc32bd4ae392f1770"
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
