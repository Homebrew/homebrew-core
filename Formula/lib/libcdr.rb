class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 6

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f9050c5671437ef41f32f01e36337d77359436c7913fe2c1eafd50c24a8e31a7"
    sha256 cellar: :any,                 arm64_ventura:  "d37e72ea423ca2086e3f87ec773c49b0351694f893f1772591c4abc2d6bf157d"
    sha256 cellar: :any,                 arm64_monterey: "e889940ab6cc809ad837aafa2db7a99bd3cc387d92862094ab95d6e137761217"
    sha256 cellar: :any,                 sonoma:         "ed24ca5c4b6e751c2a4b477fa8e42a97fe5479b435afc72b645971748bd1f909"
    sha256 cellar: :any,                 ventura:        "52d744f03a1dea741d4f29df0752d3bfc651a60bec17f88e3f56120d0950c250"
    sha256 cellar: :any,                 monterey:       "9c9b29e42893031a882597fe254fad73a068532bcfb11bd83fb72e580a2819c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeef15aa50abe575cfa2619864dac8112f58e7eaf577a6d27766dfb15157bac4"
  end

  depends_on "cppunit" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  def install
    ENV.cxx11
    # Needed for Boost 1.59.0 compatibility.
    ENV["LDFLAGS"] = "-lboost_system-mt"
    system "./configure", "--disable-werror",
                          "--without-docs",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libcdr/libcdr.h>
      int main() {
        libcdr::CDRDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                                "-I#{Formula["librevenge"].include}/librevenge-0.0",
                                "-I#{include}/libcdr-0.1",
                                "-L#{lib}", "-lcdr-0.1"
    system "./test"
  end
end
