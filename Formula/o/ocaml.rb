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
  url "https://caml.inria.fr/pub/distrib/ocaml-5.4/ocaml-5.4.0.tar.xz"
  sha256 "dfaa8a2e11c799bc1765d8bef44911406ee5f4803027190382a939f88c912266"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256               arm64_tahoe:   "9e52a52b1b531cb999c24f7f7d524f840b4630a376c3888c5e91875d15cda6ce"
    sha256               arm64_sequoia: "0e269db9117ff10e44a62f85521a46f85da8c1dca79915795776f3a0f26ab5a5"
    sha256               arm64_sonoma:  "f67dbb07c32a737b605e9d35e65efcf05af7e6e1618faa586dad50769d5f9ba4"
    sha256 cellar: :any, sonoma:        "688925c23de05f913dd9ec435ae71281254892b7109e1feba690aba1567b764e"
    sha256               arm64_linux:   "475f722bfa5f1f4bf2eabe93829a425bf7ad167a624ad3705ca5ab62b5436477"
    sha256               x86_64_linux:  "9be36dc8f324cb8ef5267c9d80343860105a6f0d8c3e04394bb3f0233b3b40f1"
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
