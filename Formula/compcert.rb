class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Compcert < Formula
  desc "Formally verified C compiler"
  homepage "http://compcert.inria.fr"
  url "https://github.com/AbsInt/CompCert/archive/v2.7.tar.gz"
  sha256 "025aff18f7fa18ce06ac99a18c9b2fa3146ce13f56bd1fc62f3032a8adbe3794"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f7b9269576dc2d5bbdbe8b84c099da8e6047c751baf7f576d65d5ddc6bf612f" => :el_capitan
    sha256 "1c088641e995b6c15ec7f3205c1e6c3179d6e5e3337ffadb7e8f859934597098" => :yosemite
    sha256 "fdbc8b9bfb1d849a88d7ce0ad0c83a65464df98898dedb3d15f842ecdec6d8b3" => :mavericks
  end

  depends_on "ocaml" => :build
  depends_on "menhir" => :build
  depends_on "camlp5" => :build # needed for building Coq 8.4
  depends_on Camlp5TransitionalModeRequirement # same requirement as in Coq formula

  # Should be removed as soon as CompCert gets Coq 8.5 support
  resource "coq84" do
    url "https://coq.inria.fr/distrib/V8.4pl6/files/coq-8.4pl6.tar.gz"
    sha256 "a540a231a9970a49353ca039f3544616ff86a208966ab1c593779ae13c91ebd6"
  end

  def install
    resource("coq84").stage do
      system "./configure", "-prefix", buildpath/"coq84",
                            "-camlp5dir", Formula["camlp5"].opt_lib/"ocaml/camlp5",
                            "-coqide", "no",
                            "-with-doc", "no",
                            # Prevent warning 31 (module is linked twice in the
                            # same executable) from being a fatal error, which
                            # would otherwise be the default as of ocaml 4.03.0;
                            # note that "-custom" is the default value of
                            # coqrunbyteflags, and is necessary, so don't just
                            # overwrite it with "-warn-error -a"
                            "-coqrunbyteflags", "-warn-error -a -custom"

      system "make", "VERBOSE=1", "world"
      ENV.deparallelize { system "make", "install" }
    end

    ENV.prepend_path "PATH", buildpath/"coq84/bin"
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
    system "#{bin}/ccomp", "test.c", "-o", "test"
    system "./test"
  end
end
