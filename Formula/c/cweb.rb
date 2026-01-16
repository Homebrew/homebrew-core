class Cweb < Formula
  desc "Literate documentation system for C, C++, and Java"
  homepage "https://cs.stanford.edu/~knuth/cweb.html"
  url "https://github.com/ascherer/cweb/archive/refs/tags/cweb-4.12.2.tar.gz"
  sha256 "519ac1c03610eea18956ed62d2996dc5a629f0c3af91f38cf4621d5deab749fd"
  # See discussions in this thread, https://github.com/ascherer/cweb/issues/29
  license :cannot_represent

  livecheck do
    url :stable
    regex(/^cweb[._-]v?(\d+(?:\.\d+)+[a-z]?)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "c4403e23d80b3754ac094fd08d07b191d100d6bfdf8f3f9dbbb9ee7dbebfa984"
    sha256 arm64_sequoia: "d3d86635f9c5d0fd3990b130c780fd9b2a91d21222ec7668dbb47db1aedd82d6"
    sha256 arm64_sonoma:  "8446ab44aec9607410a76075d9df7c63248a47dd1b5ff4d7eb16450dc48a1e0c"
    sha256 arm64_ventura: "54586e839f7763712907f8552ec891853658ea488122d6683927afb9c64adf97"
    sha256 sonoma:        "1fa6f4ec70dd19e629766b8878d44fb2fc8cf31bfbcd5dd47099855902bb45c1"
    sha256 ventura:       "7f10cc21dc5400577161bee0ba422d268045fd28217e8d6c7f53da392b47211f"
    sha256 arm64_linux:   "be157573864df0fa318a5fd47f27989ab95b0d50ecdee9f545afa6b5b7b63989"
    sha256 x86_64_linux:  "b62b4d08b2391b41b90db3eabd9cec94c6bc3317aefa6b3659d9bbb61f6239b6"
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
