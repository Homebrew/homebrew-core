class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-3.0.1.tgz"
  sha256 "09c7dc18c681231c6e83a963b283b66a9352a9611c9695f4b0c4b7df8c90f935"

  bottle do
    cellar :any_skip_relocation
    sha256 "57afe3b1c9d98bb4d74e38012c3653479cd7ac9072410cc8ec168582543ca534" => :sierra
    sha256 "751d20e855b3e356c34294f0c4fa40d0c8aa068632aac1d52dc2a33a74e7638a" => :el_capitan
    sha256 "aa1f679c5442e7de7b52c8fa7a79dbabad8f046921b85eac657248046c756389" => :yosemite
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
    system "opam", "install", "coq=8.6"

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
