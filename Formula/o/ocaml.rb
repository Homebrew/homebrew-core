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
  url "https://caml.inria.fr/pub/distrib/ocaml-5.1/ocaml-5.1.0.tar.xz"
  sha256 "6ce8db393aafc264e5af731c68fbeb20920ab6ae84d5bf93511965b7423351ab"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c58b2daea7553f2276e006f833b49edf1d0e0ea4598552457db3f7d284f45ea8"
    sha256 cellar: :any,                 arm64_ventura:  "e74bcbd841101ac0f015593e03fb32e5f7c0d6893d187b3abb16306ea861360f"
    sha256 cellar: :any,                 arm64_monterey: "8561604e9a2b36814efc882cedbff0a8faee43b98e86bd26b4677955143184c7"
    sha256 cellar: :any,                 sonoma:         "d26232128990896f2af0d49ddbb53487184582000451ce342e099edc05729712"
    sha256 cellar: :any,                 ventura:        "c38c39b1cad05df2ae44e87e369b8278f71d3fc82224224a409cd9f47c885135"
    sha256 cellar: :any,                 monterey:       "1218880aab20da9ad579134974eb0c915c68965de9348345c611b909f29f0ee5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2e8fd353851e91aadd166cf0b7b737ddf19537917ca7ef6360df42042d73e9d"
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
