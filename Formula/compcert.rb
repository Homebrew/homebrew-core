class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-3.0.tgz"
  sha256 "f5e42c528849fffa840a4c820ad4cc6257a7e518f3b3b0fe54c06fa60270dd0d"

  bottle do
    cellar :any_skip_relocation
    sha256 "b250bb227cc2c4b186a13d0140ab2a9a56c640f714c8ab65ac74ae00bded3ddf" => :sierra
    sha256 "05979ef2cd32f7dd1e860e32a7dbc4338f193a358326dbf0720c4fe992849ce1" => :el_capitan
    sha256 "d1b1c7c3ea3edf4e9f40b9c30d3d3bc4786e927dd8659928c697c0eb673c33c7" => :yosemite
  end

  option "with-config-x86_64", "Build Compcert with ./configure 'x86_64'"

  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build

  def install
    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since Xcode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace "configure", "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"

    ENV["OPAMYES"] = "1"
    ENV["OPAMROOT"] = Pathname.pwd/"opamroot"
    (Pathname.pwd/"opamroot").mkpath
    system "opam", "init", "--no-setup"
    system "opam", "install", "coq=8.5.3"

    if build.with? "config-x86_64"
      system "opam", "config", "exec", "--",
             "./configure", "-prefix", prefix, "x86_64-macosx"
    else
      system "opam", "config", "exec", "--",
             "./configure", "-prefix", prefix, "ia32-macosx"
    end

    system "opam", "config", "exec", "--",
           "make", "all"
    system "opam", "config", "exec", "--",
           "make", "install"
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
