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
  url "http://caml.inria.fr/pub/distrib/ocaml-4.03/ocaml-4.03.0.tar.gz"
  sha256 "7fdf280cc6c0a2de4fc9891d0bf4633ea417046ece619f011fd44540fcfc8da2"
  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4969f4d78ff6d3ac239af112594060846aba922d4f7eaa225395fc87a4ab58de" => :sierra
    sha256 "5a9ad99085350c0ac9a81bb9eb82543580c57069c2e1f6ca85efaf17ad2ab9f6" => :el_capitan
    sha256 "495a9536a4b6a3b5bb8d4988f5c2c50d2e961a8cd1bc3b133b5d4f90425bc828" => :yosemite
    sha256 "0d7ffe037bb862f141368110578f4c3aed01692ad5473bc222ea18d0cfcbac4a" => :mavericks
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
