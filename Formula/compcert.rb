class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v3.1.tar.gz"
  sha256 "9d0dd07f05a9a59b865041417dc61f16a664d85415f0271eb854412638e52e47"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "b55df951d4a59ea30767395f5e4f2a02b1524c302810229f86a4c3d7d160d3dd" => :high_sierra
    sha256 "f5249ad48243669d239f9f0783bfb94d19d4a7b3e1df8720cee719c46f345e58" => :sierra
    sha256 "e109e3e3e3f7a26bb1134eb7d69d8808e0c3d24955de8d4a85cfae245982979c" => :el_capitan
  end

  option "with-config-x86_64", "Build Compcert with ./configure 'x86_64'"

  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-num" => :build
  depends_on "opam" => :build

  def install
    ENV["OCAMLPARAM"] = "safe-string=0,_" # OCaml 4.06.0 compat

    ENV.permit_arch_flags

    # Compcert's configure script hard-codes gcc. On Lion and under, this
    # creates problems since Xcode's gcc does not support CFI,
    # but superenv will trick it into using clang which does. This
    # causes problems with the compcert compiler at runtime.
    inreplace "configure", "${toolprefix}gcc", "${toolprefix}#{ENV.cc}"

    ENV["OPAMYES"] = "1"
    ENV["OPAMROOT"] = buildpath/"opamroot"
    (buildpath/"opamroot").mkpath
    system "opam", "init", "--no-setup"
    system "opam", "config", "exec", "--", "opam", "install", "ocamlfind"
    system "opam", "config", "exec", "--", "opam", "install", "--fake", "num"
    system "opam", "config", "exec", "--", "opam", "install", "coq=8.6.1"

    args = ["-prefix", prefix]
    args << (build.with?("config-x86_64") ? "x86_64-macosx" : "ia32-macosx")
    system "opam", "config", "exec", "--", "./configure", *args
    system "opam", "config", "exec", "--", "make", "all"
    system "opam", "config", "exec", "--", "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
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
