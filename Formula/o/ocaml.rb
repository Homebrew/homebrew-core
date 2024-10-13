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
  url "https://caml.inria.fr/pub/distrib/ocaml-5.2/ocaml-5.2.0.tar.xz"
  sha256 "2f4bf479f51479f9bf8c7f1694a6ea7336bbf774f4ad6da6b59d1ad4939dd8a7"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia:  "460a511a4f8e2e1665467b86f8bd747eff3aefda4558fe2ee735a856a2a4f3a3"
    sha256 cellar: :any, arm64_sonoma:   "20ca740622792bad16589a5752f4523252b40fff85caa870efacfb690148cbe0"
    sha256 cellar: :any, arm64_ventura:  "b96a94c043ab7a2f5fc9fc6796c29c3159882082a926937fa7bd86b0eaea22ae"
    sha256 cellar: :any, arm64_monterey: "7948db8ae4947a4b98bb1b7c4c3afbd1daa28711100af560a5498d5af1a34995"
    sha256 cellar: :any, sonoma:         "6158cd2388cda60ca09cd8af1de8668bb1075fa94d442b1d393111e7d80b5665"
    sha256 cellar: :any, ventura:        "ebc7f049ce591904a11c7e8aa7af06117f53dd2ea0757678489f8b22e6d73515"
    sha256 cellar: :any, monterey:       "8383843a0d7419a7b4886ec111f37f289e0fdb470346fe4e8eea50213b0f1a2a"
    sha256               x86_64_linux:   "43cc50f40740c82ff6f0d86be7621c8c84331c0622e4db1978cd5752e4a56de4"
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
