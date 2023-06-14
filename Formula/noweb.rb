class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  url "https://github.com/nrnrnr/noweb/archive/refs/tags/v2_12.tar.gz"
  sha256 "34e3903bce9771345ff392b1998f7877389b66c71b3292834e8aaf448837a7f0"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0068cf8061ae3a7cb18121fd2ebfdc4acf8b7637a53ba827b8510b3dc0bdf714"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1300e280c5bf6bffb9ea37a6840265d7645db9aae1a39fa1a423c1649bd606a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "203d5c7e72a0b556c08745473c80b516b842d9a70f345fb29d9e12ef2c056d32"
    sha256 cellar: :any_skip_relocation, ventura:        "bc6bb8e8e542cf8f0dd2630b8f79cf5f478a17fe422c8b05a2d2c209d445f859"
    sha256 cellar: :any_skip_relocation, monterey:       "65bc66014cc8a65cf32b9fa09167330a166cee389f9bda2e9cd02eb27982082b"
    sha256 cellar: :any_skip_relocation, big_sur:        "56341492c694961e3f86baa4bc2ffe3dd175d59b2a6417e345ddd545877da83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e23dc34b6972b5a2b771c1a73444efd8c0c6a035a96437057ba52124433ea8a3"
  end

  depends_on "icon"

  # add missing `lib/toascii`, remove in next release
  patch do
    url "https://github.com/nrnrnr/noweb/commit/7ebfd30f9fbeec9a2744c4dd483bd3d1068da352.patch?full_index=1"
    sha256 "8f33cacd62b39dd750f577ad496a93b6bfe38400bd79e92ddfcc791cabfb0f5f"
  end

  # remove pdcached ops, see discussions in https://github.com/nrnrnr/noweb/issues/31
  patch :DATA

  def texpath
    prefix/"tex/generic/noweb"
  end

  def install
    cd "src" do
      system "bash", "awkname", "awk"
      system "make", "LIBSRC=icon", "ICONC=icont", "CFLAGS=-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=1"

      bin.mkpath
      lib.mkpath
      man.mkpath
      texpath.mkpath

      system "make", "install", "BIN=#{bin}",
                                "LIB=#{lib}",
                                "MAN=#{man}",
                                "TEXINPUTS=#{texpath}"
      cd "icon" do
        system "make", "install", "BIN=#{bin}",
                                  "LIB=#{lib}",
                                  "MAN=#{man}",
                                  "TEXINPUTS=#{texpath}"
      end
    end
  end

  def caveats
    <<~EOS
      TeX support files are installed in the directory:

        #{texpath}

      You may need to add the directory to TEXINPUTS to run noweb properly.
    EOS
  end

  test do
    (testpath/"test.nw").write <<~EOS
      \section{Hello world}

      Today I awoke and decided to write
      some code, so I started to write Hello World in \textsf C.

      <<hello.c>>=
      /*
        <<license>>
      */
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        printf("Hello World!\n");
        return 0;
      }
      @
      \noindent \ldots then I did the same in PHP.

      <<hello.php>>=
      <?php
        /*
        <<license>>
        */
        echo "Hello world!\n";
      ?>
      @
      \section{License}
      Later the same day some lawyer reminded me about licenses.
      So, here it is:

      <<license>>=
      This work is placed in the public domain.
    EOS
    assert_match "this file was generated automatically by noweave",
                 pipe_output("#{bin}/htmltoc", shell_output("#{bin}/noweave -filter l2h -index -html test.nw"))
  end
end

__END__
diff --git a/src/icon/Makefile b/src/icon/Makefile
index 7d9b8db..dbda2eb 100644
--- a/src/icon/Makefile
+++ b/src/icon/Makefile
@@ -10,11 +10,11 @@ LIBEXECS=totex disambiguate noidx tohtml elide l2h docs2comments \
 	autodefs.promela autodefs.lrtl autodefs.asdl autodefs.mmix xchunks pipedocs
 LIBSPECIAL=autodefs.cee
 BINEXECS=noindex sl2h htmltoc
-EXECS=$(LIBEXECS) $(BINEXECS) $(LIBSPECIAL) pdcached
+EXECS=$(LIBEXECS) $(BINEXECS) $(LIBSPECIAL)
 SRCS=totex.icn disambiguate.icn noidx.icn texdefs.icn icondefs.icn \
         yaccdefs.icn noindex.icn smldefs.icn tohtml.icn cdefs.icn elide.icn \
 	l2h.icn sl2h.icn pascaldefs.icn promeladefs.icn lrtldefs.icn asdldefs.icn \
-	mmixdefs.icn htmltoc.icn xchunks.icn docs2comments.icn pipedocs.icn pdcached.icn
+	mmixdefs.icn htmltoc.icn xchunks.icn docs2comments.icn pipedocs.icn

 .SUFFIXES: .nw .icn .html .tex .dvi
 .nw.icn:
@@ -141,9 +141,6 @@ elide: elide.icn
 pipedocs: pipedocs.icn
 	$(ICONT) pipedocs.icn

-pdcached: pdcached.icn
-	$(ICONT) pdcached.icn
-
 disambiguate: disambiguate.icn
 	$(ICONT) disambiguate.icn
