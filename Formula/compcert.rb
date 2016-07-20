class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-2.7.1.tgz"
  sha256 "446199fb66c1e6e47eb464f2549d847298f3d7dcce9be6718da2a75c5dd00bee"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f7b9269576dc2d5bbdbe8b84c099da8e6047c751baf7f576d65d5ddc6bf612f" => :el_capitan
    sha256 "1c088641e995b6c15ec7f3205c1e6c3179d6e5e3337ffadb7e8f859934597098" => :yosemite
    sha256 "fdbc8b9bfb1d849a88d7ce0ad0c83a65464df98898dedb3d15f842ecdec6d8b3" => :mavericks
  end

  depends_on "coq" => :build
  depends_on "ocaml" => :build
  depends_on "menhir" => :build

  def install
    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since Xcode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace "configure", "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"

    system "./configure", "-prefix", prefix, "ia32-macosx"
    system "make", "all"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int printf(const char *fmt, ...);
      int main(int argc, char** argv) {
        printf("Hello, world!\\n");
        return 0;
      }
    EOS
    system bin/"ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
