class Glktermw < Formula
  desc "Terminal-window Glk library with Unicode support"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/glktermw-104.tar.gz"
  version "1.0.4"
  sha256 "5968630b45e2fd53de48424559e3579db0537c460f4dc2631f258e1c116eb4ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "6959c1eebd57b190196abeee87a79bceffe67dfb1454c78d0068a576648fc4aa" => :catalina
    sha256 "cbb9467a9639470772bb010a05c79b396ab12bad33726f2fe6cb60dc29bda9b2" => :mojave
    sha256 "c8ecb98e15edfdb02c5aed42590291e45c0dae29640a209428f1382991a23a2a" => :high_sierra
    sha256 "8f62b5b2b920573742886d31a7c579b174bb60fad1bfeabae346f8893dc440cf" => :sierra
    sha256 "5b302ada83cd6185c262277c3836d9e071a050a677fd41d86cab31aa0e8257d0" => :el_capitan
    sha256 "9e1cce9e7bbc7d1bb1ea781bcd49c8cd1a3a933ca00637bf5c637a5dfa7c5ccc" => :yosemite
  end

  keg_only "conflicts with other Glk libraries"

  def install
    inreplace "gtoption.h", "/* #define LOCAL_NCURSESW */", "#define LOCAL_NCURSESW"
    inreplace "Makefile", "-lncursesw", "-lncurses"

    system "make"

    lib.install "libglktermw.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glktermw"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "glk.h"
      #include "glkstart.h"

      glkunix_argumentlist_t glkunix_arguments[] = {
          { NULL, glkunix_arg_End, NULL }
      };

      int glkunix_startup_code(glkunix_startup_t *data)
      {
          return TRUE;
      }

      void glk_main()
      {
          glk_exit();
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglktermw", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
