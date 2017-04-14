class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~uno/cweb.html"
  url "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64b.tar.gz"
  mirror "ftp://ftp.cs.stanford.edu/pub/cweb/cweb-3.64b.tar.gz"
  sha256 "038b0bf4d8297f0a98051ca2b4664abbf9d72b0b67963a2c7700d2f11cd25595"

  bottle do
    rebuild 1
    sha256 "3db70e017d77302764e3a1cd2bdd91162cc09a51d79b575980b3cfabd85963e2" => :sierra
    sha256 "2bc79b1783f9701b3f097ed1889686fbaf32dca3b3705f4130a251d004ee3683" => :el_capitan
    sha256 "a70e1ba0613457638f5d41ef9aab280bfa4a98420f216ffec96ec4f313f3a825" => :yosemite
    sha256 "6cca8e442e3722b5467677cd2a80a56375cb6ed513c8adfc1dee33b348db1bb9" => :mavericks
    sha256 "8d678b6d7b67027135ebc455bfe003065b98f27180f2f4117ee21e0aeca788ab" => :mountain_lion
  end

  def install
    ENV.deparallelize

    macrosdir = share/"texmf/tex/generic"
    cwebinputs = lib/"cweb"

    # make install doesn't use `mkdir -p` so this is needed
    [bin, man1, macrosdir, elisp, cwebinputs].each(&:mkpath)

    system "make", "install",
      "DESTDIR=#{bin}/",
      "MANDIR=#{man1}",
      "MANEXT=1",
      "MACROSDIR=#{macrosdir}",
      "EMACSDIR=#{elisp}",
      "CWEBINPUTS=#{cwebinputs}"
  end

  test do
    (testpath/"test.w").write <<-EOS.undent
      @* Hello World
      This is a minimal program written in CWEB.

      @c
      #include <stdio.h>
      void main() {
          printf("Hello world!");
      }
    EOS
    system bin/"ctangle", "test.w"
    system ENV.cc, "test.c", "-o", "hello"
    assert_equal "Hello world!", pipe_output("./hello")
  end
end
