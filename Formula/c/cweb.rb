class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.10.tar.gz"
  sha256 "9c5e5639ce90977a8a679d5bc30deaba10f5954afb4175e77fb5436883974de1"
  # See discussions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e10d8402b8bccb4be441330471901b041e17ef55c06efd6d519f547004213a74"
    sha256 arm64_monterey: "aba87e8e1d3a4fc68af199a0d48d7e373c675a74fcad8b1c91193a0e477db7b3"
    sha256 arm64_big_sur:  "f956307d32bf08c74e34129be48d2b47f820738b6a4bdefec58eefb77a6d5945"
    sha256 ventura:        "5a8358bd8b5220afb2868cd87815115d8b991c46bfec8f57082d8ec82a47582d"
    sha256 monterey:       "074b44f5d65ba414a9b9b095d6e028553ae06c00341d3b5f5979196c703454be"
    sha256 big_sur:        "b3eaf50616b0af852bc5217063fa92b447ae9a40115fbe97e5b7245f0efebd55"
    sha256 x86_64_linux:   "fedc9a7b36fdda5d4533be3ed1a7293aff256ca0785db085519131593dba1d76"
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
