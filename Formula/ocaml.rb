# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp5
# - lablgtk
#
# Applications that really shouldn't break on a compiler update are:
# - coq
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  # Remove `coq` from `flat_namespace_allowlist` at version bump.
  url "https://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.0.tar.xz"
  sha256 "39ee9db8dc1e3eb65473dd81a71fabab7cc253dbd7b85e9f9b5b28271319bec3"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases/"
    regex(/href=.*?v?(\d+(?:\.\d+)+)\.html/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "adef805a6bc9cee04a0fa19ad4b32df4c593deffc735b68868e19f1132330aed"
    sha256 cellar: :any,                 arm64_big_sur:  "83124ec43f2fa8164999c65068618311151792f1ab426cb7991ff59c514a7918"
    sha256 cellar: :any,                 monterey:       "29003a3851245246fe8a53087baa5bf1e5d58cef2d2ef6c7be9c22bb3d735c5e"
    sha256 cellar: :any,                 big_sur:        "e61a0e13d18b0478e02c368644786f33ec79aa38ad8b737b520ddb991d37efdd"
    sha256 cellar: :any,                 catalina:       "8c7667334e0d425c4f75366e29217402680afa4aa2f271574e64eb128db96d83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83fb8a37f5de730873eba6ecf6190297648fa3d1001370b6f63bf9c3fc29d3a6"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  # Remove use of -flat_namespace. Upstreamed at
  # https://github.com/ocaml/ocaml/pull/10723
  # We embed a patch here so we don't have to regenerate configure.
  patch :p0, :DATA

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{HOMEBREW_PREFIX}
      --enable-debug-runtime
      --mandir=#{man}
    ]
    system "./configure", *args
    system "make", "world.opt"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    output = pipe_output("#{bin}/ocaml 2>&1", "let x = 1 ;;")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end

__END__
--- configure.orig	2021-10-24 09:34:12.145636659 +0800
+++ configure	2021-10-24 09:34:30.504944693 +0800
@@ -13644,7 +13644,7 @@
 if test x"$enable_shared" != "xno"; then :
   case $host in #(
   *-apple-darwin*) :
-    mksharedlib="$CC -shared -flat_namespace -undefined suppress \
+    mksharedlib="$CC -shared -undefined dynamic_lookup \
                    -Wl,-no_compact_unwind"
       shared_libraries_supported=true ;; #(
   *-*-mingw32) :
