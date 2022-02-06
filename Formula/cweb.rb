class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.7.tar.gz"
  sha256 "818c1a2966744548935f67e899ffa41605056fb06492d959af9fa276353f0dbf"
  # See disucssions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256                               arm64_monterey: "9704f875a0e8d7ef46b8527d8139fc8c138b22f8aac7ee641600f72525d10156"
    sha256                               arm64_big_sur:  "c246e418f40801578da11748f59a03f925689558a7047b3cd94e1d03b8a06f8f"
    sha256                               monterey:       "47824b2c718282406b70099e5718148a796b5b232c8fc9118a5c5c3a1f4b4351"
    sha256                               big_sur:        "a47f44ba2529d3dee094b8e70fd86e8454d6c18b48f0b3907318172e54d6c79e"
    sha256                               catalina:       "daaaa77893d5034a2edf44fdefe905b5714fd31435be5f6bf937fca412a4b878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d15c7cbde3e6f2372aebbb46d8438fa32dfeb680a65f01c83148e939ce735a"
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
