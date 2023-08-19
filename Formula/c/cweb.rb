class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.9.tar.gz"
  sha256 "188b3b040d2a7f894a5f8e15318c2ab89ab9a655c0c04fd3d695228762bb242c"
  # See discussions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "36c0351fceeaf16817ae1e24b5d278adbfdf0c38eaa2eaa0e5351903eae45a3d"
    sha256 arm64_monterey: "7658636689958f07459e2a794c209a515fb53f1506a34ea656e0184b62b4922c"
    sha256 arm64_big_sur:  "e25c683f1528604fe7a40d1410bf3aab866b513436448f2e429236262b21b92a"
    sha256 ventura:        "442eed90d0ecdaa608ef5f9d9aa960fe9e00fbc792f122ba976cf45851194fe6"
    sha256 monterey:       "7c337de7f6638eb5abf678cf6d980dfa931f24bbfef09dfd9bd9483412270b97"
    sha256 big_sur:        "f205b80c0dfd692cf4dedb527a05a990d91d044d5e0842af2e33cc247680ebc6"
    sha256 x86_64_linux:   "1eec70fcac5e824b855a43ec127764723fc551befb44cc608d4f44bd42cea74a"
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
