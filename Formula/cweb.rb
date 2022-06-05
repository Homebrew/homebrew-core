class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.8.tar.gz"
  sha256 "893ae278c486b6780ebc5863a10d45147ee9d41de294f7a2ce7795351ac92a0d"
  # See disucssions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256                               arm64_monterey: "28f524c3bbfec46b2355c1d9b3e36a98328f8cad660701d56dbb5f3cf1821335"
    sha256                               arm64_big_sur:  "377bc14d53a26a4e616f26a986bd166d7f90d758a0d8d4538531e45ab73f0d0b"
    sha256                               monterey:       "e6e4cf31d37aa586f3a90385906d22273d9794066ec28173127ca9b92a5bc689"
    sha256                               big_sur:        "ce59e1f7637a11231d2cd97f8afe94300b7a40c62dc0f0973bcd998b6b7a47ec"
    sha256                               catalina:       "abcd2cef08f5ef924511e30cefb320142caae28a12f2662b172e9aea523f1cf2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7042cc26a2f486fee7f7a485870b689c06a54840c9194b1630433b7e18b19eca"
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
