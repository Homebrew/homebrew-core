class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.8.1.tar.gz"
  sha256 "3d1468408aaf2853bc8fbbc64b0f06e9be9c3c89638d78da907bf6f4656d52ce"
  # See disucssions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256                               arm64_ventura:  "8af953f8a3f31d2c2b6cf155de4610ba7f7a4ad61e0b59bdf9a7ec190e4cd86e"
    sha256                               arm64_monterey: "5de3449dadd66c5759b4aa073884336c9c935b3a4481d4355303b050897c3948"
    sha256                               arm64_big_sur:  "1ae7da8bf50cadb46c67c6e3ece21e992942f354dba9e9ba4dd940b4150db086"
    sha256                               ventura:        "b897a987d49e52c0f3746dd301400df7b39588cac36a1c0d2fa3557e0e40f2b7"
    sha256                               monterey:       "3f29dcb1e90489af30f71b1d2080f1da44aa54523c03955a3d8390867d8fbb10"
    sha256                               big_sur:        "5b04f2fc775e7997bd22d4fdff71bdd5d4e8776de60f7c7a79b68280b3b9df09"
    sha256                               catalina:       "abb227be400bc74150619772ced22aa90bb2c1721b1ceca347f83259d6da6904"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a01ccf4b26f6d1afb455970164dec856d58a0c523653726e873ca4db412ce08"
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
