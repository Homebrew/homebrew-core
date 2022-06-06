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
    sha256                               arm64_monterey: "c139670c8b6ade4da2cf8906b6037d1b0393590de4f46ee1c4955bd2cc6fdf4b"
    sha256                               arm64_big_sur:  "e219b2e41104e310fbb8dc29cdc2cc8fc400afbdd9108f81d4bb4399c7146d6d"
    sha256                               monterey:       "63496dbd9e5336985eb8aaf376de9755d019ce508e80d4d7cdee36ba5cb673ee"
    sha256                               big_sur:        "1be64e3c19b5fb593d1fdc5d675f3b7afa4ebbdd3b460a9ea124fd1f12051009"
    sha256                               catalina:       "eb124cf0bfcc105a8baf7996c90438b652b4d04447c4610d92f574ee8882f294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afc1e144ed1fc2e39eba2f0c8b504a891761bd743917754a8340e97497bb856c"
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
