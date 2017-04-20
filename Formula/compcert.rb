class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-3.0.1.tgz"
  sha256 "09c7dc18c681231c6e83a963b283b66a9352a9611c9695f4b0c4b7df8c90f935"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "1b5a827dcf7d127a989f7475bd7d0c923aa0361d163d84769238131957eab29c" => :sierra
    sha256 "0cb660af3446b5cca31680d87d323ae9d30950d6dd94f3c12ac3a67948de42c4" => :el_capitan
    sha256 "9d026755e06b16382ba088383240da2e8d5d217440ce8ab7d3afbf011c2db425" => :yosemite
  end

  option "with-config-x86_64", "Build Compcert with ./configure 'x86_64'"

  depends_on "coq" => :build
  depends_on "menhir" => :build
  depends_on "ocaml" => :build

  def install
    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since Xcode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace "configure", "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"

    args = ["-prefix", prefix]
    args << (build.with?("config-x86_64") ? "x86_64-macosx" : "ia32-macosx")
    system "./configure", *args
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
