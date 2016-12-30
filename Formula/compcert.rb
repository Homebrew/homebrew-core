class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "http://compcert.inria.fr/release/compcert-2.7.1.tgz"
  sha256 "446199fb66c1e6e47eb464f2549d847298f3d7dcce9be6718da2a75c5dd00bee"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8eb897fde9bbb8c3180f702f2140f6301f404ce46adcb3008fb2f1aa15559716" => :sierra
    sha256 "2e3d7fd8752d28a19427d1f194d664afee935652f2643a76ed8cb2aee0ad8785" => :el_capitan
    sha256 "9659ca41c9ebe8ec673e47b140d8a78ec68610e77e9be34b322d7c8c058c881c" => :yosemite
    sha256 "0194247311a58c8bb09107bc42b9971566c1a64dbb5457dc841b703ed884c7f8" => :mavericks
  end

  depends_on "menhir" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build

  # remove for > 2.7.1; allow Coq version 8.5pl3
  patch do
    url "https://github.com/AbsInt/CompCert/commit/a8f87aa.patch"
    sha256 "fb1b35503ae106a28b276521579fcf862772615414dca3ae3fabc4ed736ab5de"
  end

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
    system "opam", "config", "exec", "--",
           "./configure", "-prefix", prefix, "ia32-macosx"
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
