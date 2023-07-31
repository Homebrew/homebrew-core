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
    url "https://caml.inria.fr/pub/distrib/ocaml-5.0/ocaml-5.0.0.tar.gz"
    sha256 "969e1f7939736d39f2af533cd12cc64b05f060dbed087d7b760ee2503bfe56de"
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
