class Libwpg < Formula
  desc "Library for reading and parsing Word Perfect Graphics format"
  homepage "https://libwpg.sourceforge.io/"
  url "https://dev-www.libreoffice.org/src/libwpg-0.3.3.tar.xz"
  sha256 "99b3f7f8832385748582ab8130fbb9e5607bd5179bebf9751ac1d51a53099d1c"

  livecheck do
    url "https://dev-www.libreoffice.org/src/"
    regex(/href=["']?libwpg[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c3af8552a541c1a4469c0ef1a0bf146f2edafd3ffad7ad1ac85ac4316681ef72"
    sha256 cellar: :any,                 arm64_monterey: "8971569270bc1f9c9c66466218f9731cd8d97cbf871e5e56ce056409a578e230"
    sha256 cellar: :any,                 arm64_big_sur:  "ca515f644385d91d4edc74382409d82c802b13c098ef1b353aa44440eca1a8ad"
    sha256 cellar: :any,                 ventura:        "714c3f40bf6035b8ce29533b2f06becf3e008dd49fdaadfdf3939eed5149f4d0"
    sha256 cellar: :any,                 monterey:       "44a1c05814cf24e80fddec9e750ec59c57b822189847a6ef8bcebeb4bb840a89"
    sha256 cellar: :any,                 big_sur:        "d550bf02dfa09143d6b6578a541327b2cd59334c46765652162ed98b63e63e83"
    sha256 cellar: :any,                 catalina:       "d12ae12e729a2d2e327f07fe927e02dd15151a987b7cab0a19ca94ee15f8cfde"
    sha256 cellar: :any,                 mojave:         "162171b22e6df4f4f4169634fc6872d40bea9a17a9c49e01dd737e9d74b1d445"
    sha256 cellar: :any,                 high_sierra:    "dd0c4dc2a9369d7d6b97f930dd63e6f4ddd9d12d0372c12e13d2a22cf6a0cd06"
    sha256 cellar: :any,                 sierra:         "cf9ab0d990b3fccb101312999f6d0ea5980990edd279ae994cf3c7f9c33a7d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "345a763b72ab642cacae4e4ad5baf4d8f428b066b0dcc34c88da249d8d3426c7"
  end

  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwpg/libwpg.h>
      int main() {
        return libwpg::WPG_AUTODETECT;
      }
    EOS
    system ENV.cc, "test.cpp",
                   "-I#{Formula["librevenge"].opt_include}/librevenge-0.0",
                   "-I#{include}/libwpg-0.3",
                   "-L#{Formula["librevenge"].opt_lib}",
                   "-L#{lib}",
                   "-lwpg-0.3", "-lrevenge-0.0",
                   "-o", "test"
    system "./test"
  end
end
