class Glkterm < Formula
  desc "Terminal-window Glk library"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/glkterm-104.tar.gz"
  version "1.0.4"
  sha256 "473d6ef74defdacade2ef0c3f26644383e8f73b4f1b348e37a9bb669a94d927e"

  livecheck do
    url :homepage
    regex(/href=.*?glkterm[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?GlkTerm library v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c6a484e614b2100efbb81a9724035e7dd974a0e4c15cba7b846cf11ee543e09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dfa6c028a6b6c70b258e19faa4f274c5c993ee55d8fa21e7574aa1df32e6cd2c"
    sha256 cellar: :any_skip_relocation, monterey:       "e47a9f144d3113fc05b42020d4ebf5d49afd666c73ee7b0cee980083e577f8c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "a82e9471f88cd16b842beb87305959fcdec9fbc083cb7e4b6b213cb7f7c9f701"
    sha256 cellar: :any_skip_relocation, catalina:       "c337df9d5b7c6343fe21abf1f17143d51d4e61e747b1c6da7d31ad557653a7a0"
    sha256 cellar: :any_skip_relocation, mojave:         "34bba71e2063d751f179adf09caa65b6815b94b0f5c64436f20f3117e038e128"
    sha256 cellar: :any_skip_relocation, high_sierra:    "1e7d75d921b11cd91354b2f8acf8a63416709b7875146d095bcf1ce02cc6fdad"
    sha256 cellar: :any_skip_relocation, sierra:         "b4c65e282b8cf6fce1e32e4e168aef241d6c38f2090448c68ad3ca7157e1d473"
    sha256 cellar: :any_skip_relocation, el_capitan:     "b9db7677c23716a7f8a57ce45d309487a36cc41c1388e2c7990b49c17e2f0bb7"
    sha256 cellar: :any_skip_relocation, yosemite:       "61b75bf1232fb3aacc5966ea13e88fe339da7ffd7c9882bab549456dd816a30a"
  end

  keg_only "conflicts with other Glk libraries"

  def install
    system "make"

    lib.install "libglkterm.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glkterm"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglkterm", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
