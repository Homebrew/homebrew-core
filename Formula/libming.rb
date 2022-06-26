class Libming < Formula
  desc "C library for generating Macromedia Flash files"
  homepage "https://github.com/libming/libming"
  url "https://github.com/libming/libming/archive/ming-0_4_8.tar.gz"
  sha256 "2a44cc8b7f6506adaa990027397b6e0f60ba0e3c1fe8c9514be5eb8e22b2375c"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d1aa289f7e7d2c72c56e6c0567af9d93d963e00b19dadceb44b0d7432b5912a5"
    sha256 cellar: :any,                 arm64_big_sur:  "d6ca20b38c61c2b2aa00a1b21fa33cac79ef9c5afe287a498a6a10d06f397c74"
    sha256 cellar: :any,                 monterey:       "7d8ab999c92e925f028f1f1580a8fcd8ba96a70630f11ecfb51c8012f3e529d7"
    sha256 cellar: :any,                 big_sur:        "75412c5e2ac1e0a72f1e7a3e48529f0faf519496c5c2f5fa23e585e6d546063e"
    sha256 cellar: :any,                 catalina:       "f553beadeca1638d0deb61cf643279ba0f62a16c46f62e8140cab8f1ff86db04"
    sha256 cellar: :any,                 mojave:         "fe9765ddd0524f6491e45ef8ac0a186a0a477996cbca3fa7d92f199f72a348cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "931f5db9f3d83f2997855245bfec7ba545877e79cfaa6d8ff32a9b0067b1f44b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "freetype"
  depends_on "giflib"
  depends_on "libpng"
  depends_on "perl"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    ENV.deparallelize if OS.linux?
    system "autoreconf", "-fiv"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-perl"
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
