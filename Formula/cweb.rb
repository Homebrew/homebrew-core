class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.5.tar.gz"
  sha256 "5afa2bad211b60e7a3e33cf72b1ea0873b66427d24c17ec12e211b20bd1ad4aa"

  bottle do
    sha256 arm64_monterey: "bf4fa48bb4855f8424de024bfdafccfd3ed28fade1485a8526ee5e6cfb80b509"
    sha256 arm64_big_sur:  "9a1237298f33f69283f923525eb5668911226d48043024bbbd44d337ad1bcdbe"
    sha256 monterey:       "de7c0543066179c97ebb5316d6bcfa8d6ecb7ca00e62507fda2d160cb019ed71"
    sha256 big_sur:        "2ee6617cf9da76e1e7cafbd49ed6e53fee15339c82df053eab55a398fb96f50b"
    sha256 catalina:       "e100640669a1d066177514aae1c813f7c18b530c4cae5744d0431d850933648c"
    sha256 mojave:         "410376faad622cd11745ca94c877135c1b4837ccdc8c7cab43bf12b4b849a3b9"
    sha256 x86_64_linux:   "62cac91ee39b5981ac30e4797a75b76572b4ae04c539796d120f4fbe36fc9716"
  end

  conflicts_with "texlive", because: "both install `cweb` binaries"

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
