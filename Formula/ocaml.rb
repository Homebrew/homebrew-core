# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp4
# - opam
#
# Applications that really shouldn't break on a compiler update are:
# - mldonkey
# - coq
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.04/ocaml-4.04.0.tar.xz"
  sha256 "64ed6dad2316d5dff7440cea89f0f0abe07ce508b9104d1bfadf3782e79856b4"
  head "https://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "b7448dcd0685f7e129ace58707f821f53a89fb436edba86d20e86a203c2deb5e" => :sierra
    sha256 "cba95bfb38d7f4466830906b67e69f63463ae90fdf28ef05abbf6234760c8d9a" => :el_capitan
    sha256 "fe05592478358e1ffab4f83c03ad6567865978e52341544131c66da1e9917a02" => :yosemite
  end

  devel do
    url "https://github.com/ocaml/ocaml/archive/4.05.0+beta3.tar.gz"
    version "4.05.0+beta3"
    sha256 "3d82d5b32310d1c010981c12508e0ff63fb71b0c89457bcac813b7c291d4b61c"
  end

  option "with-x11", "Install with the Graphics module"
  option "with-flambda", "Install with flambda support"

  depends_on :x11 => :optional

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = ["-prefix", HOMEBREW_PREFIX.to_s, "-with-debug-runtime", "-mandir", man]
    args << "-no-graph" if build.without? "x11"
    args << "-flambda" if build.with? "flambda"
    system "./configure", *args

    system "make", "world.opt"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
