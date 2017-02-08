class Cheapglk < Formula
  desc "Extremely minimal Glk library"
  homepage "http://www.eblong.com/zarf/glk/index.html"
  url "http://www.eblong.com/zarf/glk/cheapglk-104.tar.gz"
  version "1.0.4"
  sha256 "87f1c0a1f2df7b6dc9e34a48b026b0c7bc1752b9a320e5cda922df32ff40cb57"

  bottle do
    cellar :any_skip_relocation
    sha256 "148667db31db5635af17eafb3c564a3fcf498a8631dd5e42aaa09b11613725da" => :sierra
    sha256 "ebf0b9e232857c385f3fa7ddbda6c338c38d516405b65db4c044cc717723f3d0" => :el_capitan
    sha256 "0e82e6dfff4bf8964a29eaef3f8f9b0f1c8ee6a9f8dc3293060539bcbc4684c2" => :yosemite
  end

  keg_only "Conflicts with other Glk libraries"

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
    system "echo test | ./test"
  end
end
