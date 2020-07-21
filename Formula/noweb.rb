class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  # new canonical url (for newer versions): http://mirrors.ctan.org/web/noweb.zip
  url "https://deb.debian.org/debian/pool/main/n/noweb/noweb_2.11b.orig.tar.gz"
  sha256 "c913f26c1edb37e331c747619835b4cade000b54e459bb08f4d38899ab690d82"
  license "Noweb"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "b52d3febc8494ae943db6f99e0734b61333f95d67994b6b609d4c5129d52f788" => :catalina
    sha256 "17439b95ee2d05eacf81c621aa76645e5bfd9a3c5b5ad61ffd98e1438bb69264" => :mojave
    sha256 "f3ca23f070a74c5e499232667ef64e73d68943d13f6344e70b74426feccca524" => :high_sierra
  end

  depends_on "icon"

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
                 shell_output("#{bin}/noweave -filter l2h -index -html test.nw | #{bin}/htmltoc")
  end
end
