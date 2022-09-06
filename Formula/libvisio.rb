class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  license "MPL-2.0"
  revision 6

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b6914749c1bda7f6796c1f2908dda35f564860830cfc202ed9bb9f1652ce3562"
    sha256 cellar: :any,                 arm64_big_sur:  "ee945d14878160dba16e983ede8c3fefbc5c82b028d340851d5c8b2ce486e0b9"
    sha256 cellar: :any,                 monterey:       "9db99dc5397773cd0628ed1ce6c183eea4c0deab7aee30f483eb96941cfa2a24"
    sha256 cellar: :any,                 big_sur:        "2153b5bd416812b4d5448e5f38554dd93d4baf82cf21672abb24215669f21e5f"
    sha256 cellar: :any,                 catalina:       "99d2f84618430bdc6a7876512a65a365da8cdeb94aa6198193b2eb933aeb8556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "728b3e6817c2d78dd463de90ebdbde10d5e8a468357b7d6b66759444da0286ab"
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"

  uses_from_macos "gperf" => :build
  uses_from_macos "libxml2"

  def install
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
    system "./configure", "--without-docs",
                          "-disable-dependency-tracking",
                          "--enable-static=no",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <librevenge-stream/librevenge-stream.h>
      #include <libvisio/VisioDocument.h>
      int main() {
        librevenge::RVNGStringStream docStream(0, 0);
        libvisio::VisioDocument::isSupported(&docStream);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-lrevenge-stream-0.0",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-L#{Formula["librevenge"].lib}",
                    "-lvisio-0.1", "-I#{include}/libvisio-0.1", "-L#{lib}"
    system "./test"
  end
end
