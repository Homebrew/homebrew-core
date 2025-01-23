class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/refs/tags/cweb-4.12.1.tar.gz"
  sha256 "c6e08d726b1b587187a70d45cf49dd990dfe70053059064fea0999e3f4fa976f"
  # See discussions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 arm64_sequoia: "f7dc4b0a260556f278058526ff6259dd28522b1f00454d9e1790a8aaff41b7f2"
    sha256 arm64_sonoma:  "a50c45f276cc546df324a406ddd8a2d89edb8a676c7b7e8bca29ee4dbb3e5d84"
    sha256 arm64_ventura: "d9ac7cb438103378e55375f9ac40e1032dd0195d3a5e4a66549ec8856390d034"
    sha256 sonoma:        "75d0b7f16f41c5cf906aa45c0ffbb6c86415efd715604d2ac8ac9cda4c8507cb"
    sha256 ventura:       "e97d62ac332b3ae7ed53bf20c6e05605fb0409f1e8621a88821a6482322bd62b"
    sha256 x86_64_linux:  "7a59e26b5b3569d2459442cab528f68b0a83f66db2daf4592d65cffa04298ad2"
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
