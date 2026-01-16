class Glktermw < Formula
  desc "Terminal-window Glk library with Unicode support"
  homepage "https://www.eblong.com/zarf/glk/"
  url "https://www.eblong.com/zarf/glk/glktermw-104.tar.gz"
  version "1.0.4"
  sha256 "5968630b45e2fd53de48424559e3579db0537c460f4dc2631f258e1c116eb4ea"
  license "Glulxe"

  livecheck do
    url :homepage
    regex(/href=.*?glktermw[._-]v?(?:\d+(?:\.\d+)*)\.t[^>]+?>\s*?GlkTerm library v?(\d+(?:\.\d+)+)/im)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4fa3de55e34832b4cd122d80784210b5d85389306182944ebc6e1a63b5b54262"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "17bd37271cd72f41cd159557efb3ba1f89aa75a9428e40ca0300653ada1b9b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d1f3adfa6df5aa1c23142d10a090993069a42ee4238f41814b220e2ed2c2fa11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35a03fd6081b2bab477c9a75969119d92225a284f1178c043db3edd74d40d881"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2aa0665da245b2b3d6e701aa45407b8a3ab9eb23c32381362caac287245ddbdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "291e5c7e7be0a93d71fb909fe40473a604e9990319bf86dc3d05b5a1787437ea"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bb6f11abb30ca3c63f5f77a4aa3b9b73f008bb01d5ac7b93593fa1da22ad5a0"
    sha256 cellar: :any_skip_relocation, ventura:        "1fe4217ba733bafb231019e146f8ec74ca9aa57fe09c94614dcbd3942c4bd9e3"
    sha256 cellar: :any_skip_relocation, monterey:       "699e360251f685b222039f3847dbe00a3106db24e10fd306f6bc03d9cdb026b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "52731e29ed29632ef8e5e1bc069022498be1270ac2af0b47cd906313c643ee71"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d1ba5b6b77eec49662678b249c1ab830d1b6d2b0d8b51b605d68e0d639a0201b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3391048ffb327060e3cf8e18e253ac1a44de556fbef1c453ee0186c92b3b079"
  end

  keg_only "it conflicts with other Glk libraries"

  uses_from_macos "ncurses"

  def install
    inreplace "gtoption.h", "/* #define LOCAL_NCURSESW */", "#define LOCAL_NCURSESW"
    inreplace "Makefile", "-lncursesw", "-lncurses"

    system "make"

    lib.install "libglktermw.a"
    include.install "glk.h", "glkstart.h", "gi_blorb.h", "gi_dispa.h", "Make.glktermw"
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
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lglktermw", "-lncurses", "-o", "test"
    system "echo test | ./test"
  end
end
