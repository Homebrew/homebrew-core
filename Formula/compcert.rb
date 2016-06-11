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
  url "https://github.com/AbsInt/CompCert/archive/v2.6.tar.gz"
  sha256 "a1f21365c41c2462fce52a4a25e1c7e4b7fea7a0cd60b6bae1d31f2edeeb4d17"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "823686809063af67b896557d7a7c4cbbe8fe30b41132b34531608211848bcdd0" => :el_capitan
    sha256 "db93c4266c2272e960bb3d60e4bada1f90b714a3546e604b9d23c44ee8d0e726" => :yosemite
    sha256 "533d0c317afd18a3b4e06135e74ae170ef0eb772e7465b2f5d930e640709c409" => :mavericks
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
