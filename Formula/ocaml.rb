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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.08/ocaml-4.08.1.tar.xz"
  sha256 "cd4f180453ffd7cc6028bb18954b3d7c3f715af13157df2f7c68bdfa07655ea3"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  bottle do
    cellar :any
    sha256 "32975ce17008941774b66953c57c8bff280276773ce4e39305b215d1ef487dae" => :mojave
    sha256 "91a69eb4be51d6a3afdb3b4c36d607a1384f355e3f468de345f996b9cb732e3e" => :high_sierra
    sha256 "c66d4a1ee91315cedccc507ac9a85229777ab13062666fb2aacaa44512feb9c6" => :sierra
  end

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --enable-debug-runtime
      --mandir=#{man}
      --disable-graph-lib
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
