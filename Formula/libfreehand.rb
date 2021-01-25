class Libfreehand < Formula
  desc "Interpret and import Aldus/Macromedia/Adobe FreeHand documents"
  homepage "https://wiki.documentfoundation.org/DLP/Libraries/libfreehand"
  url "https://dev-www.libreoffice.org/src/libfreehand/libfreehand-0.1.2.tar.xz"
  sha256 "0e422d1564a6dbf22a9af598535425271e583514c0f7ba7d9091676420de34ac"
  revision 5

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libfreehand[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "736e40282e91275e85e6586f9601bebf05a7111e484776a3a1cf8df1e266b329" => :big_sur
    sha256 "1cd27b1d82fe6261a9def131e7a09143b35fe7547cbf539b720fc9d8bdc257b6" => :arm64_big_sur
    sha256 "337aeb3f1454487fc132f9d67e3662dc6c3f0ba40a38a9a9c58d9f0b9bfc1955" => :catalina
    sha256 "b2e7566024327688b13ce6ba4a2bc93108d61d46923b0e6f59a6bc577ccc4eb9" => :mojave
    sha256 "fed031e8bfce818f39ea578792a3ed1f1b74c9f86192f37b372e1c4fc493bc90" => :high_sierra
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "icu4c"
  depends_on "librevenge"
  depends_on "little-cms2"

  # remove with version >=0.1.3
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/7bb2149f314dd174f242a76d4dde8d95d20cbae0/libfreehand/0.1.2.patch"
    sha256 "abfa28461b313ccf3c59ce35d0a89d0d76c60dd2a14028b8fea66e411983160e"
  end

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
      #include <libfreehand/libfreehand.h>
      int main() {
        libfreehand::FreeHandDocument::isSupported(0);
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test",
                    "-I#{Formula["librevenge"].include}/librevenge-0.0",
                    "-I#{include}/libfreehand-0.1",
                    "-L#{Formula["librevenge"].lib}",
                    "-L#{lib}",
                    "-lrevenge-0.0",
                    "-lfreehand-0.1"
    system "./test"
  end
end
