class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 5

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6141888d52c7b3936088755ed90952ad1991f0994b5f7390b2611cdfd92e8031"
    sha256 cellar: :any,                 arm64_monterey: "3e81b65399b22fb51dd5f2a519fd5b5cfafaa9a2d42b57c0d2d2194c5223c611"
    sha256 cellar: :any,                 arm64_big_sur:  "b6a97482a83ea524eb47c9995661e907c23f569ed1d5166f83143ef3f3d6841c"
    sha256 cellar: :any,                 ventura:        "867cb6c4edf171df1224bd9a6740e96f78e4116f18f253d499c3c85e1247ec34"
    sha256 cellar: :any,                 monterey:       "ab27a9457704979bb0e33c59d03649725f2c421dfac3c13a54034a8bc007430e"
    sha256 cellar: :any,                 big_sur:        "a363205ee91eff85e566a8d162353d1f7201b468300a438d7ccc2937d49b117c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa8dbae78687968b16b4425783b258ede49b11daa75a0ac6107d577cef142cf"
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
