class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/cweb-4.5.tar.gz"
  sha256 "5afa2bad211b60e7a3e33cf72b1ea0873b66427d24c17ec12e211b20bd1ad4aa"

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]*?)$/i)
  end

  bottle do
    sha256                               arm64_monterey: "04ed26efc24fef95e690016410da0e987c64c86bbb44d7be14f57ffb51176be3"
    sha256                               arm64_big_sur:  "90e531e4c475de1c1630fe17b0a41856abbe0aaff3f6edebdbc94deccc4b8bff"
    sha256                               monterey:       "6353ada6affe616e9d5cfd57c860158cd238d40ae08a0f6906a2f9bd88595b47"
    sha256                               big_sur:        "d289cbfd452407b42ed39ce37127e7c7d5187752ad8b286d5c06692460336bf3"
    sha256                               catalina:       "65606687d8bfe11b2a441613123fa2fac30f9362e822f13695c1f168bc01b62f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d164644aba2adcb257e9316d4627b94239ecfc90cc477e8715ca6284ac416363"
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
