class Cheapglk < Formula
  desc "Extremely minimal Glk library"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/cheapglk-106.tar.gz"
  version "1.0.6"
  sha256 "2753562a173b4d03ae2671df2d3c32ab7682efd08b876e7e7624ebdc8bf1510b"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?cheapglk[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?CheapGlk library v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "46c6748a4f62fe0b8f62a0f0a8ed01351b3057624bb0bf4a62edb51575e631dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f34227be66c2d76ee900dd6cfcbe1263bab3c706ef05b348314944711bc1de4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "73f43be61554255b8b1bb6f2e185b567eca2c868f0c65ddf8a53020fddd8e35a"
    sha256 cellar: :any_skip_relocation, ventura:        "b7c1ecbddaa051401144361b5231f77990f7862be8618de1d711493c32aac368"
    sha256 cellar: :any_skip_relocation, monterey:       "16e6658829ca0f23ea49cfcdbee978c19e61b9eb1adfa26b5ffae7bb9c07f688"
    sha256 cellar: :any_skip_relocation, big_sur:        "9b3b09b201d58788157377de21147fc1dab74635912c3592626e9575905d9061"
    sha256 cellar: :any_skip_relocation, catalina:       "91d3c4e89b0750585d52206bf25054eb2db72af798e0d4e1c33021177b92ae13"
    sha256 cellar: :any_skip_relocation, mojave:         "d57b00a86e3d1c76f43d8f034c1dfe77d23da3d34637449040fdedd21f6a4a63"
    sha256 cellar: :any_skip_relocation, high_sierra:    "47c6f59d902a306b30c6255f65fd7626e32d5c39800fd80daeada852e95994f2"
    sha256 cellar: :any_skip_relocation, sierra:         "d76d29db8ea0201fcef949e02cbddb1c06311dece796a263192ffef487a3aa2c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "497a5399738c026d318d3213b764f20fb80ccea94181919fad2e80eb75086055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af305413ea03f3b67064c61be1f26be3860370d87e774d4fc6c014ca66cdd380"
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
