class Libggz < Formula
  desc "The libggz library wraps many common low-level functions"
  homepage "http://dev.ggzgamingzone.org/libraries/libggz/"
  url "https://mirrors.dotsrc.org/ggzgamingzone/ggz/0.0.14.1/libggz-0.0.14.1.tar.gz"
  mirror "https://mirrorservice.org/sites/ftp.netbsd.org/pub/pkgsrc/distfiles/libggz-0.0.14.1.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/libggz/libggz-0.0.14.1.tar.gz"
  sha256 "54301052a327f2ff3f2d684c5b1d7920e8601e13f4f8d5f1d170e5a7c9585e85"

  bottle do
    cellar :any
    sha256 "efddc954be758a5560c63326ce4d3b2a126974221ad796587bf2a0bdfae7dd3a" => :mojave
    sha256 "9a749d02e1f492d53f1398998c78b47b8b6eeb6907a4fb4ed1d27833b37653c2" => :high_sierra
    sha256 "cb95d1deb75b87bc4d9a814e838b7ffff205d1251c998708a52dfc932ce73ebc" => :sierra
    sha256 "1fc7a664f9d4376fd21aad2e75f7a3990cf8994cb0b4947362ddcb7732e5bda0" => :el_capitan
    sha256 "6408ac1f15a3cfa780197456ffed4f4e152fc3b7c0eb5dc8938b17ab280f7d11" => :yosemite
  end

  depends_on "gettext"
  # Libggz of this version is unable to build with gnutls-30 and later.
  depends_on "libgcrypt"

  def install
    ENV.append "CPPFLAS", "-I#{Formula["gettext"].opt_prefix}/include"
    ENV.append "LDFLAGS", "-L#{Formula["gettext"].opt_prefix}/lib"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gcrypt"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <string.h>

      #include <ggz.h>

      int main(void)
      {
        int errs = 0;
        char *teststr, *instr, *outstr;

        teststr = "&quot; >< &&amp";
        instr = teststr;
        outstr = ggz_xml_escape(instr);
        instr = ggz_xml_unescape(outstr);
        if(strcmp(instr, teststr)) {
          errs++;
        }
        ggz_free(instr);
        ggz_free(outstr);
        ggz_memory_check();

        return errs;
      }
    EOS
    system ENV.cc, "test.c", ENV.cppflags, "-L/usr/lib", "-L#{lib}", "-lggz", "-o", "test"
    system "./test"
  end
end
