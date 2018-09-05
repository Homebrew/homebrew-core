class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://cs.stanford.edu/pub/cweb/cweb-3.64b.tar.gz"
  mirror "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64b.tar.gz"
  sha256 "038b0bf4d8297f0a98051ca2b4664abbf9d72b0b67963a2c7700d2f11cd25595"

  bottle do
    sha256 "77291255506b068cd1856498a048708baf94d29a60267fe5ab221e46cd1a383f" => :mojave
    sha256 "e6888449565ebd6620ebc6851dbef48765a0654b3e5d429cfffb617ca33e2479" => :high_sierra
    sha256 "377a987173b8274ab97de6d8978816372d6f380a0fe4c9e0b09cfcd7d27ab66e" => :sierra
    sha256 "86ff3ceca459e8f087644249378a19a7f53f4ebbd5c74ddfbbe6ea795003a1a2" => :el_capitan
    sha256 "27c017af8f2e004888240d99a14b29ea9ac8d1fa5339d228b6a79ecda8031e4e" => :yosemite
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
    (testpath/"test.w").write <<~EOS
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
