class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/refs/tags/cweb-4.12.tar.gz"
  sha256 "d2fb0f8bc315fb36dfc300a1593fee43c58df45120371dc30b5a0762b26fda72"
  # See discussions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 arm64_sequoia:  "68f8d3e1048ec6680b38801ded3588a6c40f88cd383b41220fb79865e1b91351"
    sha256 arm64_sonoma:   "568fb4d1e8521f6540d1bf1bd82ee1e9ebec4c03e058e89bac128efca38338a0"
    sha256 arm64_ventura:  "9c9c107b2d27d5b05d4a3fa7402cf8a97d4293707a02cccdb95f53df13caf5b3"
    sha256 arm64_monterey: "dfe83fa420835c38f25b96d2efe1e9e8ccb74608b0d0feca628fea11e0b8d2f8"
    sha256 sonoma:         "bf115b06ff2d03b2335ebae9c2b06d347dec403c7e2b5923ad486ead8cea2132"
    sha256 ventura:        "af2575b5bc8153f6d59514810263db60efd3ddd4c0fdc41e20092b36169aaf97"
    sha256 monterey:       "2b00ffd639e8f9106c7675d7beb17b26b1cd2ee8cd40de96df7e28e9e3924fcf"
    sha256 x86_64_linux:   "7a80f9fbc0f0397d8911d2a8dac4b213f6f53b2ca6c92a128c9260979980f5a8"
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
