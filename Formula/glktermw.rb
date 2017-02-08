class Glktermw < Formula
  desc "Terminal-window Glk library with Unicode support"
  homepage "http://www.eblong.com/zarf/glk/index.html"
  url "http://www.eblong.com/zarf/glk/glktermw-104.tar.gz"
  version "1.0.4"
  sha256 "5968630b45e2fd53de48424559e3579db0537c460f4dc2631f258e1c116eb4ea"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fb944dd33eb8943ffa988e20001bde6c76969d8dab98ec82dfa9b12586b5081" => :sierra
    sha256 "4cabfbfc3cf4f9946986424ca5741d3146c84e055d12418ef9c81f7795295f44" => :el_capitan
    sha256 "1c2dc8d72af8e15f7c8b38935c4bc7abeff3328143a5b0ad66da88e682d6e8dd" => :yosemite
  end

  keg_only "Conflicts with other Glk libraries"

  def install
    inreplace "gtoption.h", "/* #define LOCAL_NCURSESW */", "#define LOCAL_NCURSESW"
    inreplace "Makefile", "-lncursesw", "-lncurses"

    system "make"

    lib.install "libglktermw.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glktermw"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
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
