class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.6.1.tar.gz"
  sha256 "9a6558bce53e668e8474bf51990060237a521e27603629b7eb4c5f6788be8155"
  # See disucssions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256                               arm64_monterey: "96d6c49635c84a71ab541ec86f129efa0c4d2c3105690c5befec7ec7b451db81"
    sha256                               arm64_big_sur:  "0cfcf2f1eec235df8140f7969a1c1dc56041b05eb68a5cb793d867a8f9ef92ca"
    sha256                               monterey:       "6f965774f5ca11a1abcb53c4cb358cb3f0135fa6f75b1c1aaa42ede800fb86a1"
    sha256                               big_sur:        "6ebaf4e8d111cca2abd1242c511956ab0997ecc197ec06dca97c5466ccbd37af"
    sha256                               catalina:       "64b79680965bda045e7802626956435eab5408724a447d4db99319c2c9102b25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe725559ca9b58e7c14295c9833b65393277e39bfbd71ce3b1578b4914d6a773"
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
