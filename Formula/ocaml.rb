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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.09/ocaml-4.09.0.tar.xz"
  sha256 "f2fb91dfe86bae00a33fc5ba51685e95a68564274f5277f787c31931b22a7fec"
  head "https://github.com/ocaml/ocaml.git", :branch => "trunk"

  bottle do
    cellar :any
    sha256 "d3661fa949c06ce4132df11fb82bca7f0a58b3ba555700e54fafc264b621af0b" => :catalina
    sha256 "39551915056e6652aa10579c926e43ff2a0d744202be2ba89dd4107f1d4346cf" => :mojave
    sha256 "4e96119913768af5be322c05efe1ddb5716d389bedfaa582fd8cb5eee1abfed1" => :high_sierra
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
