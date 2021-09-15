class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://cs.stanford.edu/pub/cweb/cweb-3.64c.tar.gz"
  mirror "https://www.ctan.org/tex-archive/web/c_cpp/cweb/cweb-3.64c.tar.gz"
  sha256 "efbd6fbeca9b3e75629b69e9565ac6a0e4067f55bda6a0a3b7b6f9449d9ed81f"

  bottle do
    sha256 arm64_big_sur: "9a1237298f33f69283f923525eb5668911226d48043024bbbd44d337ad1bcdbe"
    sha256 big_sur:       "2ee6617cf9da76e1e7cafbd49ed6e53fee15339c82df053eab55a398fb96f50b"
    sha256 catalina:      "e100640669a1d066177514aae1c813f7c18b530c4cae5744d0431d850933648c"
    sha256 mojave:        "410376faad622cd11745ca94c877135c1b4837ccdc8c7cab43bf12b4b849a3b9"
    sha256 x86_64_linux:  "62cac91ee39b5981ac30e4797a75b76572b4ae04c539796d120f4fbe36fc9716"
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
