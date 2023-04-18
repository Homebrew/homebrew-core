class Libcdr < Formula
  desc "C++ library to parse the file format of CorelDRAW documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libcdr"
  url "https://dev-www.libreoffice.org/src/libcdr/libcdr-0.1.7.tar.xz"
  sha256 "5666249d613466b9aa1e987ea4109c04365866e9277d80f6cd9663e86b8ecdd4"
  license "MPL-2.0"
  revision 4

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libcdr[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b0d7e609ceda67e4c8df6fc2fc61bcd47b8a874a805d8fdca10525ee022c41b5"
    sha256 cellar: :any,                 arm64_monterey: "dbe18c90f1987ac364bd541650a29dcaba04e220550ad0e3b185b70994cb7fca"
    sha256 cellar: :any,                 arm64_big_sur:  "4ecd9ad95970ab523ad97f724573b90534943707483dbb90af9df2f767914411"
    sha256 cellar: :any,                 ventura:        "1976a8e4860ced6f1212c5f38de970b76fc6b55bb5aab760ad5fd34848f0b755"
    sha256 cellar: :any,                 monterey:       "263089b625f484be81c8038238e6ca6478eeec4b611d591796bebe4dd575128c"
    sha256 cellar: :any,                 big_sur:        "068d2f5b409b998461d9ffbc1a26fab58eb4862dd63180273af6ced1c26cebe2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ccf6e946f06db3d774196ab65816d460dba2f3a241050c9886fd2e0b5f3d72b"
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
