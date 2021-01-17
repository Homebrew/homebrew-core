class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://cs.stanford.edu/pub/cweb/cweb-3.64c.tar.gz"
  mirror "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64c.tar.gz"
  sha256 "efbd6fbeca9b3e75629b69e9565ac6a0e4067f55bda6a0a3b7b6f9449d9ed81f"

  bottle do
    sha256 "2f85582d6fc749f9341029f816b40ee3cf9950413c17009beeb38f6343e50e00" => :big_sur
    sha256 "a6a3f34240c03c9d98ef32c800528a78acf835ea89b24630628bad53e4bdcac2" => :arm64_big_sur
    sha256 "3fdde2a4883a27e1ed296a89458821c848bcbac7daa7df5ab33160131f0e38e8" => :catalina
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
