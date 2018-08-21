class Cheapglk < Formula
  desc "Extremely minimal Glk library"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/cheapglk-106.tar.gz"
  version "1.0.6"
  sha256 "2753562a173b4d03ae2671df2d3c32ab7682efd08b876e7e7624ebdc8bf1510b"

  bottle do
    cellar :any_skip_relocation
    sha256 "d57b00a86e3d1c76f43d8f034c1dfe77d23da3d34637449040fdedd21f6a4a63" => :mojave
    sha256 "47c6f59d902a306b30c6255f65fd7626e32d5c39800fd80daeada852e95994f2" => :high_sierra
    sha256 "d76d29db8ea0201fcef949e02cbddb1c06311dece796a263192ffef487a3aa2c" => :sierra
    sha256 "497a5399738c026d318d3213b764f20fb80ccea94181919fad2e80eb75086055" => :el_capitan
    sha256 "8351c9dec39fd8e860e50a8e693e1c648def81c3ddcbdd3a856f656d585b0082" => :yosemite
  end

  keg_only "it conflicts with other Glk libraries"

  def install
    system "make"

    lib.install "libcheapglk.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.cheapglk"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheapglk", "-o", "test"
    assert_match version.to_s, pipe_output("./test", "echo test", 0)
  end
end
