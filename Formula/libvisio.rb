class Libvisio < Formula
  desc "Interpret and import Visio diagrams"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libvisio"
  url "https://dev-www.libreoffice.org/src/libvisio/libvisio-0.1.7.tar.xz"
  sha256 "8faf8df870cb27b09a787a1959d6c646faa44d0d8ab151883df408b7166bea4c"
  license "MPL-2.0"
  revision 8

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libvisio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e9c402292b9fbdf9ff47e39afbd1fe979648dd0b1ea930a151c6625a32711590"
    sha256 cellar: :any,                 arm64_monterey: "c0367e8d9d93e5958a61a5afdd3a637c9cf78165eb311116e27c99f27af9df3f"
    sha256 cellar: :any,                 arm64_big_sur:  "3a5903295d31adcea271eb795325b277e1c72caee3e5507a72e0c9105c0a207d"
    sha256 cellar: :any,                 ventura:        "a069a1f73e0935188c0eb65a8a54162463d631411103088e751a50005d4f2450"
    sha256 cellar: :any,                 monterey:       "0524e13f8e95af1ba8f030d932a126f9803fef489b2010e751a8b1480aaef8b3"
    sha256 cellar: :any,                 big_sur:        "8541e46ff41dd1d7cec5a8807d136edcd4a7dbd4efdc419d4e1d67c67701ea9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9c9445d29af37557973bc87987a09eff567e354f818727e928674cacc58f462"
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
