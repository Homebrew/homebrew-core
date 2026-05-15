class Libchardet < Formula
  desc "Mozilla's Universal Charset Detector C/C++ API"
  homepage "https://github.com/Joungkyun/libchardet"
  url "https://github.com/Joungkyun/libchardet/archive/refs/tags/1.0.6.tar.gz"
  sha256 "425f3fa9e7afa0ebc3f4e3572637fb87bd6541e2716ad2c18f175995eb2021f0"
  license any_of: ["MPL-1.1", "LGPL-2.1-only"]

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2050047b6703bdfa916ea84bb6378070d73e3220ec321eaed2213e80c1c3c0ef"
    sha256 cellar: :any,                 arm64_sequoia: "d27a3d9bcbe687d5fc342594f7827a11bdee56e0cc2df1fdfb9f9002d703b35a"
    sha256 cellar: :any,                 arm64_sonoma:  "ecdc88fdef41d786b3aab14fc0c5e7fbeacdf0722b36da20870b8a72ca9a84cc"
    sha256 cellar: :any,                 sonoma:        "dea14ebf59a697035a132ea184fd63f546faee8bb1363e7d4c2e2e6fcce2addd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfe329dc2540c27537f73a5b4a100430395357e8d845465a5bbf6783fcfcdda6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b265b1b47cad3b74174e44a0a46c11b8e99e01613bc35c93281962f318f89409"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :test

  def install
    system "autoreconf", "--install"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <assert.h>
      #include <chardet.h>
      #include <string.h>

      int main(void) {
        DetectObj *o;
        char *str = "안녕하세요";

        if ((o = detect_obj_init()) == NULL)
          return 1;

        switch (detect_r(str, strlen(str), &o)) {
          case CHARDET_NULL_OBJECT:
          case CHARDET_OUT_OF_MEMORY:
            return 1;

          default:
            assert(strcmp(o->encoding, "UTF-8") == 0);
            return 0;
        }
      }
    C
    flags = shell_output("#{Formula["pkgconf"].opt_bin}/pkgconf --cflags --libs chardet").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"

    assert_match version.to_s, (lib/"pkgconfig/chardet.pc").read
  end
end
