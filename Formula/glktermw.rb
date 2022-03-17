class Glktermw < Formula
  desc "Terminal-window Glk library with Unicode support"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/glktermw-104.tar.gz"
  version "1.0.4"
  sha256 "5968630b45e2fd53de48424559e3579db0537c460f4dc2631f258e1c116eb4ea"

  livecheck do
    url :homepage
    regex(/href=.*?glktermw[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?GlkTerm library v?(\d+(?:\.\d+)+)/im)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "78f059cc1bcee84516edb414bf2e837c249da02ca26894cdf38961d7d4b54c23"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c24eb437d3ffab00f829aec8fa2bec0846d97bd6cf34d8801235746aca61760c"
    sha256 cellar: :any_skip_relocation, monterey:       "d9504855781898144107ee963ecb9b7d2e9d5d0cc0f0d413657a52412a45dab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d68c298b6f2c6a8b4275207809d3e075a3d8a0f4545660c3474803073385781e"
    sha256 cellar: :any_skip_relocation, catalina:       "6959c1eebd57b190196abeee87a79bceffe67dfb1454c78d0068a576648fc4aa"
    sha256 cellar: :any_skip_relocation, mojave:         "cbb9467a9639470772bb010a05c79b396ab12bad33726f2fe6cb60dc29bda9b2"
    sha256 cellar: :any_skip_relocation, high_sierra:    "c8ecb98e15edfdb02c5aed42590291e45c0dae29640a209428f1382991a23a2a"
    sha256 cellar: :any_skip_relocation, sierra:         "8f62b5b2b920573742886d31a7c579b174bb60fad1bfeabae346f8893dc440cf"
    sha256 cellar: :any_skip_relocation, el_capitan:     "5b302ada83cd6185c262277c3836d9e071a050a677fd41d86cab31aa0e8257d0"
    sha256 cellar: :any_skip_relocation, yosemite:       "9e1cce9e7bbc7d1bb1ea781bcd49c8cd1a3a933ca00637bf5c637a5dfa7c5ccc"
  end

  keg_only "conflicts with other Glk libraries"

  def install
    inreplace "gtoption.h", "/* #define LOCAL_NCURSESW */", "#define LOCAL_NCURSESW"
    inreplace "Makefile", "-lncursesw", "-lncurses"

    system "make"

    lib.install "libglktermw.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glktermw"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglktermw", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
