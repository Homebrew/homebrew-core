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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.10/ocaml-4.10.2.tar.xz"
  sha256 "96871461078282d5db022077d89bde25c85fb5e376612b44f8c37d4e84f000e3"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases/"
    regex(/href=.*?v?(\d+(?:\.\d+)+)\.html/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e063050517ec18694d395744b0f25db4347b9b39b805328dbd844ea73a4c406f"
    sha256 cellar: :any, big_sur:       "ba026fe9338863ab3a79ca2c998f001eb38c913af36486db07e84e2c7e136e79"
    sha256 cellar: :any, catalina:      "886db1a44bd60ac5275b56cd0acbf162d0b1836e2261a475035c40482ffb9788"
    sha256 cellar: :any, mojave:        "5c4cce204b2ef4eea7c1f59df4216e9be9068e077d0ff92746af05035f485285"
  end

  pour_bottle? do
    # The ocaml compilers embed prefix information in weird ways that the default
    # brew detection doesn't find, and so needs to be explicitly blacklisted.
    reason "The bottle needs to be installed into #{Homebrew::DEFAULT_PREFIX}."
    satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX }
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
