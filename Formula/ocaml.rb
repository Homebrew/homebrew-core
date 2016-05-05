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
  head "http://caml.inria.fr/svn/ocaml/trunk", :using => :svn

  stable do
    url "http://caml.inria.fr/pub/distrib/ocaml-4.03/ocaml-4.03.0.tar.gz"
    sha256 "7fdf280cc6c0a2de4fc9891d0bf4633ea417046ece619f011fd44540fcfc8da2"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "72fca832d91bda2ed37a72b11207c511f1b3291357ab508e5974431da1602bd7" => :el_capitan
    sha256 "8b0f9c7ce7b8a710c00f3363709dfa7cee46d2c8d18af6a88affb348eb6a0adb" => :yosemite
    sha256 "afa78cad62971725b4eab39e9d15bc49b7ae224f42c2a27e2bfbe6fad7b292a9" => :mavericks
    sha256 "a0fcad6dc20417725ff9fefb0468ead98a6faa0bb4a99a63351171e4b0dc22b1" => :mountain_lion
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
    assert_match "val x : int = 1", shell_output("echo 'let x = 1 ;;' | ocaml 2>&1")
    assert_match HOMEBREW_PREFIX.to_s, shell_output("ocamlc -where")
  end
end
