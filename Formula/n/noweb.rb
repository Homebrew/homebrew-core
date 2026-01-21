class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  url "https://github.com/nrnrnr/noweb/archive/refs/tags/v2_13.tar.gz"
  sha256 "7b32657128c8e2cb1114cca55023c58fa46789dcffcbe3dabde2c8a82fe57802"
  license "BSD-2-Clause"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5b0ebc62d33b6e1452815e9257c313a3b886caa203124fdbc785001aa8f5e0d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "f18c4be4fa20125e8adc57369970446c02ceed59304f52ef1e595967db4842dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f4a47b231de7c9f6e04f77ecf8ea59edb7658da0fae7b10d9d3d6d7b80577aeb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a2984bbf74de88caf1026e1d940c45bd2288361b1f48458e04758b585e1d07a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be96a5565ef49b6639fefad120cc677a9235fe665196f6b9d1ac353627a6abfe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ef7e6d0cd7c63e47d4c82b1417e26cf8fb0be1fec0c27fd99e67af7d5dcd4813"
    sha256 cellar: :any_skip_relocation, sonoma:         "3f44a86284253361d5994fb42060b4f051569a98e4e6e0593dc9ed02fee1af63"
    sha256 cellar: :any_skip_relocation, ventura:        "ad26424a2647f8feb82d8735c6792b755bd56d7c720ffa64101fbd3061d4d94c"
    sha256 cellar: :any_skip_relocation, monterey:       "ab0cabc785cdc9c5d34cb9e41e518eac9411dc3c6fe249ba4ac82dcd830ba851"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c9575804e168b4ec6c8f28f6fd1748d509726a35704ee1ca7469257380617c5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "c2fb0ea050c3968ff76ff68f19043aeab5898c7c47d2310b779044ce2f6c709d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b0483e38e12bf0bcc968685af551d17a421ff7d27cf0433082fc08bd5135a0d"
  end

  depends_on "gnu-sed" => :build
  depends_on "icon"

  # remove pdcached ops, see discussions in https://github.com/nrnrnr/noweb/issues/31
  patch :DATA

  def texpath
    prefix/"tex/generic/noweb"
  end

  def install
    # use gnu-sed on macOS for fixing `illegal byte sequence` error
    ENV.prepend_path "PATH", Formula["gnu-sed"].libexec/"gnubin" if OS.mac?

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
index b8f39ee..db51615 100644
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
