class Glkterm < Formula
  desc "Terminal-window Glk library"
  homepage "http://www.eblong.com/zarf/glk/index.html"
  url "http://www.eblong.com/zarf/glk/glkterm-104.tar.gz"
  version "1.0.4"
  sha256 "473d6ef74defdacade2ef0c3f26644383e8f73b4f1b348e37a9bb669a94d927e"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a72c3f8490cd55598d1160533e951e5b188b319a2dccbf0cb6ee8a8b12dd4b0" => :sierra
    sha256 "e1f42b6bef2421cf3c42e52f79b8e6153301b7c8d65fbaf4fe284b691705899c" => :el_capitan
    sha256 "3fe7df7e54d96dcd88cc57674ae570b34af41b6a0511439a28c3036bc9e80580" => :yosemite
  end

  keg_only "Conflicts with other Glk libraries"

  def install
    system "make"

    lib.install "libglkterm.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glkterm"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglkterm", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
