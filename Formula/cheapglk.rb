class Cheapglk < Formula
  desc "Extremely minimal Glk library"
  homepage "http://www.eblong.com/zarf/glk/index.html"
  url "http://www.eblong.com/zarf/glk/cheapglk-106.tar.gz"
  version "1.0.6"
  sha256 "2753562a173b4d03ae2671df2d3c32ab7682efd08b876e7e7624ebdc8bf1510b"

  bottle do
    cellar :any_skip_relocation
    sha256 "def8cf0f954279c503b3b67c456721af6ccd9657f87df37fecd4459a0a44918d" => :sierra
    sha256 "e58d40a1c283dbb45ef9d672361849e807d104d627a93626cdb06e66105f1d4a" => :el_capitan
    sha256 "93d9f95fbdef5fc3c51b3ecbd69fedea47bbaaf9a89e3a3f8275b9c801bba2e3" => :yosemite
  end

  keg_only "it conflicts with other Glk libraries"

  def install
    system "make"

    lib.install "libcheapglk.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.cheapglk"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheapglk", "-o", "test"
    assert_match version.to_s, pipe_output("./test", "echo test", 0)
  end
end
