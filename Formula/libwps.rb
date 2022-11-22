class Libwps < Formula
  desc "Library to import files in MS Works format"
  homepage "https://libwps.sourceforge.io"
  url "https://downloads.sourceforge.net/project/libwps/libwps/libwps-0.4.13/libwps-0.4.13.tar.xz"
  sha256 "ce95afe6c030689779a2543a4834827666eee27c10d8a74860d8d172a956c40f"
  license any_of: ["LGPL-2.1-or-later", "MPL-2.0"]

  livecheck do
    url :stable
    regex(%r{url=.*?/libwps(?:/|[._-])v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "878881d9031c049f78df3536619291ca070b9ad4d7089f2d5ff30dd84b40d818"
    sha256 cellar: :any,                 arm64_monterey: "a3e3b275b2a784887d138aef481220987b5aaca55d3a294af76b31449ffd1432"
    sha256 cellar: :any,                 arm64_big_sur:  "d4fa9a17d34ded62debfbcb777f626d9475c0f4ca46e445b8f107fcecc317674"
    sha256 cellar: :any,                 ventura:        "0ab5faa114d3bb663568735813c47f819b0ab3bfaa1af50f4ac441a41dd0b5df"
    sha256 cellar: :any,                 monterey:       "c46b5ba67486fd37d7865eaffa1c6852855890cecc4a8e4fb7fbe32bb4649f5e"
    sha256 cellar: :any,                 big_sur:        "a09bab16bcc1b32e299fe156fa8ced1d046d737fd2759681c53878822c6f6e6e"
    sha256 cellar: :any,                 catalina:       "8b65c9279666c2cf24382e3c2044f9d4b24ab2e0e52e31c36f6cd2c6556f5da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "317a629812db88f63d354d9b48e416129100ffb497a181c5053d83b279f4c405"
  end

  depends_on "boost" => :build
  depends_on "pkg-config" => :build
  depends_on "librevenge"
  depends_on "libwpd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          # Installing Doxygen docs trips up make install
                          "--prefix=#{prefix}", "--without-docs"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libwps/libwps.h>
      int main() {
        return libwps::WPS_OK;
      }
    EOS
    system ENV.cc, "test.cpp", "-o", "test",
                  "-lrevenge-0.0",
                  "-I#{Formula["librevenge"].include}/librevenge-0.0",
                  "-L#{Formula["librevenge"].lib}",
                  "-lwpd-0.10",
                  "-I#{Formula["libwpd"].include}/libwpd-0.10",
                  "-L#{Formula["libwpd"].lib}",
                  "-lwps-0.4", "-I#{include}/libwps-0.4", "-L#{lib}"
    system "./test"
  end
end
