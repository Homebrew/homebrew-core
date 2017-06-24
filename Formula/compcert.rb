class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-3.0.1.tgz"
  sha256 "09c7dc18c681231c6e83a963b283b66a9352a9611c9695f4b0c4b7df8c90f935"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "7349f901864850d9dac7f70409d234fe0748a6cb1394229386c38a0be627464f" => :sierra
    sha256 "4cb2b5afa636df760398eeefb4cd136a2e2ff59919b9893b92401aa646145a18" => :el_capitan
    sha256 "d311acd5219f517b5069e1569bae9cc4263357d1a5055b6d405eeabfc8ba1e17" => :yosemite
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
