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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.07/ocaml-4.07.0.tar.xz"
  sha256 "f45bf720aadf5c6408400d5179b92ea7130b7e55e501a1768c2d136ef69f9f0f"
  revision 1
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  bottle do
    cellar :any
    sha256 "e570566296d4ebb49297d267aa01d46ef36cfcf2c4b88e57ac6eb8e1a2832423" => :mojave
    sha256 "e662192a30ee7cc037f3665fa68680a35b00a4760c49fb12ccce01d61aa5a977" => :high_sierra
    sha256 "ae0a24f0e8d52b1253d84703060bff3e1a3db657d882459936cde97c3834a357" => :sierra
    sha256 "35d04c6e3b52a99b08e21ab0002992df2dd014a6ab53e857165893438591bf99" => :el_capitan
  end

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into /usr/local."
    satisfy { HOMEBREW_PREFIX.to_s == "/usr/local" }
  end

  option "with-x11", "Install with the Graphics module"
  option "with-flambda", "Install with flambda support"

  depends_on :x11 => :optional

  # Doesn't apply cleanly so cherry-picked the necessary part of:
  # https://github.com/ocaml/ocaml/commit/3e265f97ecd4252b911d4a328ad16026b4afdb26
  # Fixes: https://caml.inria.fr/mantis/view.php?id=7824
  patch :DATA

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

__END__
diff --git a/typing/ctype.ml b/typing/ctype.ml
index f24e46d15a2f77b685800e9d8096b083ae58087a..9f21bf2913164effb3acdf227904c5df3c28a370 100644
--- a/typing/ctype.ml
+++ b/typing/ctype.ml
@@ -4132,6 +4132,8 @@ and subtype_row env trace row1 row2 cstrs =
   let row1 = row_repr row1 and row2 = row_repr row2 in
   let r1, r2, pairs =
     merge_row_fields row1.row_fields row2.row_fields in
+  let r1 = if row2.row_closed then filter_row_fields false r1 else r1 in
+  let r2 = if row1.row_closed then filter_row_fields false r2 else r2 in
   let more1 = repr row1.row_more
   and more2 = repr row2.row_more in
   match more1.desc, more2.desc with
