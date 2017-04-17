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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.04/ocaml-4.04.1.tar.xz"
  sha256 "222cc494b4eea45011234f2cc6620045ec4d4b539985086381a9a9db289bc285"
  head "https://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6810d92aec79c61720173c17357452683262d9cda66493756f64e44cee514d9a" => :sierra
    sha256 "97fcc838ece9d80698c0bff19c9640cbde0ea3d393cf2677fd39819a1f05b046" => :el_capitan
    sha256 "4fab89ed28a639a356b87041a6b3fd59d6b1a4dd260038d495457d2f0a7b0092" => :yosemite
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
