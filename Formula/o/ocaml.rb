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
  url "https://caml.inria.fr/pub/distrib/ocaml-5.5/ocaml-5.5.0.tar.xz"
  sha256 "fcc6ae665d1ec51d52510eaac7834a86a9806bf5a258bb7cca78733fccf015ba"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  compatibility_version 3
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256               arm64_tahoe:   "0d48c3078a778fa1de69bfedb7f7696001812add764554d64ead0e8d69206ad9"
    sha256               arm64_sequoia: "f52b904227f30bc0e67d333f15cd3e6d85e8620c8313ec6d5c435607e9aeb01c"
    sha256               arm64_sonoma:  "2204aec877a5b2f408bb9b405f34f5d026692f25fc3aad8b0a3df4a5c6a25aa3"
    sha256 cellar: :any, sonoma:        "c244bd048371c9cccdf514d2aae303094afeac614fce66f626e8b1957d13a7aa"
    sha256               arm64_linux:   "8727fddf919b9fc6d179ac761d8c24173345d6398901424c23fbdd431733488e"
    sha256               x86_64_linux:  "2c5dbf3005114fde4cfc7da70edd3f8ef79ae47f10a8cac617582a10b87f406c"
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
    output = pipe_output("#{bin}/ocaml 2>&1", "let x = 1 ;;")
    assert_match "val x : int = 1", output
    assert_match HOMEBREW_PREFIX.to_s, shell_output("#{bin}/ocamlc -where")
  end
end
