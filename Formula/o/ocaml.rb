# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Specific packages to pay attention to include:
# - camlp5
#
# Applications that really shouldn't break on a compiler update are:
# - coccinelle
# - unison
class Ocaml < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-5.5/ocaml-5.5.2.tar.xz"
  sha256 "5503e1baad8b625da35f1fe71d47558014fa36253ae5f1a22cc3a18fab041e0d"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  compatibility_version 5
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 arm64_golden_gate: "70d202877721d3441f384974a537bfb4b9291ee23e0a8ed3fb7a00257ee824ac"
    sha256 arm64_tahoe:       "2d6b73c411a5a5658f846cd549f909f73a07a9b14afd37be56a9dd20bf552dce"
    sha256 arm64_sequoia:     "f7b18f86268ea9883f0ac60683ff31cdb71dcdfcde82712e452c3fcd6eb0b7ec"
    sha256 arm64_linux:       "8d5275c343fc5db6fe871d89d327e7d5cc428045fb551667278dc1502fb2f285"
    sha256 x86_64_linux:      "d5fc5d78c1399ff84f64d921a5e64bfa3ebb0879094a556f36874b97d8e2eb73"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  deny_network_access!

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
