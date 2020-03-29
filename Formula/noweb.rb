class Noweb < Formula
  desc "WEB-like literate-programming tool"
  homepage "https://www.cs.tufts.edu/~nr/noweb/"
  # new canonical url (for newer versions): http://mirrors.ctan.org/web/noweb.zip
  url "https://deb.debian.org/debian/pool/main/n/noweb/noweb_2.11b.orig.tar.gz"
  sha256 "c913f26c1edb37e331c747619835b4cade000b54e459bb08f4d38899ab690d82"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2867f2275c206dfb42d8ac22aca69b6ad0e8f9474c36d19b6f5cb4758797caf4" => :catalina
    sha256 "461f350d77b97afcd8ed73c61fee9392e0d4f9f0345f93e8f637e36371bf925e" => :mojave
    sha256 "0d09a290942eccbbabb3a7f15c098299a88df2dd3090c9d4a4d755c5430f4b68" => :high_sierra
  end

  depends_on "icon"

  def texpath
    prefix/"tex/generic/noweb"
  end

  def install
    cd "src" do
      system "bash", "awkname", "awk"
      system "make LIBSRC=icon ICONC=icont CFLAGS='-U_POSIX_C_SOURCE -D_POSIX_C_SOURCE=1'"

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
