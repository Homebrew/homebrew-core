class Cheapglk < Formula
  desc "Extremely minimal Glk library"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/cheapglk-107.tar.gz"
  version "1.0.7"
  sha256 "87b9a19d741c71a8d3bffbb0fd7833410672006d3815717c70860e1681043d4c"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?cheapglk[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?CheapGlk library v?(\d+(?:\.\d+)+)/im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22ed56d38b62431e69151ad10604e0e8831a5f4b88d2f0d7105bb71d00708cf3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5600c759374d421d057d4901d84f12c4a0526ef88c23d6d838b699eb409a6c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "796c71e7b1eb29c4bbf1702e4a10d2f8ec25dd66d987ad7a570a8cfb1841db06"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "baf814604181f0dcaf9105bd843e5dc6583bd13f1a4cefe21145d8c98218dff2"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a18e98d351775e2419fa5a15484bdcadad75fc7861518fd4069900c14117b8d"
    sha256 cellar: :any_skip_relocation, ventura:       "fe810d9b9aa201d3a740860c1433858f84965b6ce5ac5ca9b448c4f982e1d382"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "18c73a83fb777146fd406d1f6da79a8cf3eb530d271eecd761e0c881233cefde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70161bfc4d712eed8c06bc1542de58ac63726e196b5a2cf22ea449f8a627e089"
  end

  keg_only "it conflicts with other Glk libraries"

  def install
    system "make"

    lib.install "libcheapglk.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.cheapglk"
  end

  test do
    (testpath/"test.c").write <<~C
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
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcheapglk", "-o", "test"
    assert_match version.to_s, pipe_output("./test", "echo test", 0)
  end
end
