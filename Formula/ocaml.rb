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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.06/ocaml-4.06.1.tar.xz"
  sha256 "6f07e0364fb8da008d51264c820b30648f6a4bfd9a9b83709ed634adddf377d8"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  bottle do
    cellar :any
    sha256 "377756d07b0253fd30eb0d5761d7a0e53d4305daa742122dbcbe70a378277f5c" => :high_sierra
    sha256 "e62b761a4e814661d3ec110d3e3da378316ad57416d9d01bdc2dbd445d92e2b6" => :sierra
    sha256 "0422ddaa6ee523fc6c9b30ad239118ae4de011b64bcb9687b917b586b7794595" => :el_capitan
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
