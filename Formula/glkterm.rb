class Glkterm < Formula
  desc "Terminal-window Glk library"
  homepage "http://www.eblong.com/zarf/glk/index.html"
  url "http://www.eblong.com/zarf/glk/glkterm-104.tar.gz"
  version "1.0.4"
  sha256 "473d6ef74defdacade2ef0c3f26644383e8f73b4f1b348e37a9bb669a94d927e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b4c65e282b8cf6fce1e32e4e168aef241d6c38f2090448c68ad3ca7157e1d473" => :sierra
    sha256 "b9db7677c23716a7f8a57ce45d309487a36cc41c1388e2c7990b49c17e2f0bb7" => :el_capitan
    sha256 "61b75bf1232fb3aacc5966ea13e88fe339da7ffd7c9882bab549456dd816a30a" => :yosemite
  end

  keg_only "conflicts with other Glk libraries"

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
