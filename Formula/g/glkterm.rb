class Glkterm < Formula
  desc "Terminal-window Glk library"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/glkterm-104.tar.gz"
  version "1.0.4"
  sha256 "473d6ef74defdacade2ef0c3f26644383e8f73b4f1b348e37a9bb669a94d927e"
  license "Glulxe"

  livecheck do
    url :homepage
    regex(/href=.*?glkterm[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?GlkTerm library v?(\d+(?:\.\d+)+)/im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "43e67c7a7245b3260330d9d23807520aff007e05341b510dbea4818cd387cb45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6c2738ad6a679729b197e17a7ed259e5e4440ba7076d9d496ee9dc8e107b634a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01c72d9afa8307ad6e859d85d1bd33768446ec7c80d684534a51e44a7e8eab1a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a16c7170ae9eecce9419bbcb844b97ffd38cf62eba26c92f2d8bd4f1e5b1e88c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce4ee770d5cb1136fae90036ffc18d14e8a910b61b5d17fa72e42c46df4a0333"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cf37e7f7186d632c124831695e9563f8ae5c9112541816456077f66ec4391d22"
    sha256 cellar: :any_skip_relocation, sonoma:         "a5380c91720e91700637e02c69743fb42f0a294171457f285408954b71b843e6"
    sha256 cellar: :any_skip_relocation, ventura:        "634360102e7a03bf06bd75c090d336ffdbcd07a3f0abbc177585b92bfe519dff"
    sha256 cellar: :any_skip_relocation, monterey:       "d21e3c42268a40f68edfc13989a47b007a1a60b5b87652eb9752b047924d9283"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a7b4d3779676cef021e21d226260a2dca07c04e350ce1a8c0efa85e6b52f97d"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "0e2e5f9c4afe534db5780f0797e9a6bd65726ed8fceca5441f6c4bc30c5460fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f57f1075e4afed829d717f987b4511626a5871e3532a98698862da6ee42989dc"
  end

  keg_only "it conflicts with other Glk libraries"

  uses_from_macos "ncurses"

  def install
    system "make"

    lib.install "libglkterm.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glkterm"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglkterm", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
