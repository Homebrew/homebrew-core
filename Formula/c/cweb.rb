class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/refs/tags/cweb-4.11.tar.gz"
  sha256 "527699448053028080b186e8e05fd14930f61504c8a5689d14d968662607f29d"
  # See discussions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "d213a29ad99358f7ba68cd0cf7d95ab48b758c398e9aac7572fe641736258b3d"
    sha256 arm64_ventura:  "2d59c66d0877477a101160edc3d64e1b1ffa7e02717a1cf612ab656bc768bc77"
    sha256 arm64_monterey: "532a14cf4276331ad6add3823946a5c3f3af9dc7f617a23a7c66cbddb0e6e86f"
    sha256 sonoma:         "48c8f1de158417565c63e050ab37f1f09cf26f2690aa8d0a43400d887f8d1325"
    sha256 ventura:        "4d219712b16560331e1eefab5b693c474e05a22bd45596c59af528e2903f077e"
    sha256 monterey:       "5a29b8892e2634305d75489510495a5c54620bb550772b484921c6231c2ee91f"
    sha256 x86_64_linux:   "256585dfdbc02977daab1a33f25bccfe486f5fcd1a47107db08743bb3b655900"
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
