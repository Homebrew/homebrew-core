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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.04/ocaml-4.04.2.tar.xz"
  sha256 "d158ed3e9446b300554baeaaa8cca2e9491420b505a9878940205074e2970f2e"
  head "https://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "83eb66e6d8edefac54ef0c6d35463c2da5d6913de6ca9ba1b4285e1b9989a489" => :sierra
    sha256 "e609fa7017393ce93f11020190563c104a7cfc9f7d498214a538ba53ef9ece28" => :el_capitan
    sha256 "6993d8c8c3a60a871b851ec38d7957a7c6a4588b681d6c142cad07d133d3f6d2" => :yosemite
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
