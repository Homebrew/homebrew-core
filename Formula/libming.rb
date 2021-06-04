class Libming < Formula
  desc "C library for generating Macromedia Flash files"
  homepage "http://www.libming.org"
  url "https://github.com/libming/libming/archive/ming-0_4_8.tar.gz"
  sha256 "2a44cc8b7f6506adaa990027397b6e0f60ba0e3c1fe8c9514be5eb8e22b2375c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d6ca20b38c61c2b2aa00a1b21fa33cac79ef9c5afe287a498a6a10d06f397c74"
    sha256 cellar: :any, big_sur:       "75412c5e2ac1e0a72f1e7a3e48529f0faf519496c5c2f5fa23e585e6d546063e"
    sha256 cellar: :any, catalina:      "f553beadeca1638d0deb61cf643279ba0f62a16c46f62e8140cab8f1ff86db04"
    sha256 cellar: :any, mojave:        "fe9765ddd0524f6491e45ef8ac0a186a0a477996cbca3fa7d92f199f72a348cf"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "libpng"
  depends_on :macos # Due to Python 2
  depends_on "perl"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-perl",
                          "--enable-python"
    system "make", "DEBUG=", "install"
  end

  test do
    (testpath/"test.c").write <<~'EOS'
      #include <ming.h>
      int main() {
        Ming_setScale(40.0);
        printf("scale %f\n", Ming_getScale());
        return Ming_init() != 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-lming", "-I#{include}"
    assert_match "scale 40.0", shell_output("./test")
  end
end
