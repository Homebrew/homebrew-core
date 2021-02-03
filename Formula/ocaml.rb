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
  url "https://caml.inria.fr/pub/distrib/ocaml-4.10/ocaml-4.10.0.tar.xz"
  sha256 "30734db17b609fdd1609c39a05912325c299023968a2c783e5955dd5163dfeb7"
  license "LGPL-2.1"
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases/"
    regex(/href=.*?v?(\d+(?:\.\d+)+)\.html/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:     "e6258cd7012b9c0d8e961eb661cc11bc42c388d2153a9f8b9f0a37cf4e63a0f7"
    sha256 cellar: :any, catalina:    "0870fc3042b3725fb2c6f131c4d6f78aec9f19d553e054ba4890773ef69e45a7"
    sha256 cellar: :any, mojave:      "b43a7247e3d3848d5f20d2432d4996e41049e79c738762f1026f4376ec7e80d3"
    sha256 cellar: :any, high_sierra: "a534347814298cc8e66e321384f16eac85f2a59aaa2f536e542fb4870386bc2b"
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
