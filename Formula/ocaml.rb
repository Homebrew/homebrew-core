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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.12/ocaml-4.12.0.tar.xz"
  sha256 "39ee9db8dc1e3eb65473dd81a71fabab7cc253dbd7b85e9f9b5b28271319bec3"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases/"
    regex(/href=.*?v?(\d+(?:\.\d+)+)\.html/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "23d4a0ea99bad00b29387d05eef233fb1ce44a71e9031644f984850820f7b1fc"
    sha256 cellar: :any,                 big_sur:       "98ee5c246e559e6d494ce7e2927a8a4c11ff3c47c26d7a2da19053ba97aa6158"
    sha256 cellar: :any,                 catalina:      "f1f72000415627bc8ea540dffc7fd29c2d7ebc41c70e76b03a994c7e6e746284"
    sha256 cellar: :any,                 mojave:        "9badb226c3d92ae196c9a2922c73075eaa45ee90f3c9b06180e29706e95f2f0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dee41488645db27099a5cc8c7b59798f1371ea775ad13e3c326e362c690bf0e9"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

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
    output = shell_output("echo 'let x = 1 ;;' | #{bin}/ocaml 2>&1")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
