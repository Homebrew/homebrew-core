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
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  stable do
    url "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.0.tar.xz"
    sha256 "36abd8cca53ff593d5e7cd8b98eee2f1f36bd49aaf6ff26dc4c4dd21d861ac2b"

    # Remove use of -flat_namespace. Upstreamed at
    # https://github.com/ocaml/ocaml/pull/10723
    # We embed a patch here so we don't have to regenerate configure.
    patch :DATA
  end

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fea680c0c2345edadc91fa0b9102ab2b1223a0f4312370a8fc4f917164f98e51"
    sha256 cellar: :any,                 arm64_monterey: "4627e987e1517d78cfd6f40aa84a7f8c29b1d20ae845d345038fc7b548148413"
    sha256 cellar: :any,                 arm64_big_sur:  "dd4cddcad1dd890d90d2db3cd4119ec0dc8b30e10053ca480812e16a90dff342"
    sha256 cellar: :any,                 ventura:        "a0a61f07a68cce8bbc534d8b3f87059390c1082bd0d0d050fa28c3b05075d239"
    sha256 cellar: :any,                 monterey:       "f744606227e8187baacabccec4baf57aca0f4309eb3bf93623a6789861369dab"
    sha256 cellar: :any,                 big_sur:        "bfff444bfd1a9f4c441087537e602964e19f00adad4a8b15b5e0aad522b0c1b3"
    sha256 cellar: :any,                 catalina:       "130c3b5d8c8de8cfbdafb57d48abf75a98e560c2ed4ae4bbc6f4a388145fe401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "493cc9bbb57be2722ebf5203aa95fc93ec24af04cfadf474cbccba125dfbd215"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

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
--- a/configure
+++ b/configure
@@ -14087,7 +14087,7 @@ if test x"$enable_shared" != "xno"; then :
   case $host in #(
   *-apple-darwin*) :
     mksharedlib="$CC -shared \
-                   -flat_namespace -undefined suppress -Wl,-no_compact_unwind \
+                   -undefined dynamic_lookup -Wl,-no_compact_unwind \
                    \$(LDFLAGS)"
       supports_shared_libraries=true ;; #(
   *-*-mingw32) :
