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
  url "https://caml.inria.fr/pub/distrib/ocaml-5.3/ocaml-5.3.0.tar.xz"
  sha256 "b0229336d9ebe0af905954bcd1ae5b293306bbcb08c01ead03500d9e5bc90164"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256               arm64_tahoe:   "53a3cca9bc93ec216ab963c7c4d02687434eedb90e9a7095e937babebf19f867"
    sha256               arm64_sequoia: "0979996448821ab111b2d1c618fcc2eac7605952e7731644123c8b9ae8e58da3"
    sha256               arm64_sonoma:  "ad596105ed2af2dc5f71f9db062427cdec3279c759a9e1f87820f54abbfde1a3"
    sha256               arm64_ventura: "614155cd3a84d3a21eb07d0ff026af5a3a344415b2a9483a070cf240b4b52ca5"
    sha256 cellar: :any, sonoma:        "08108b354deba5aac573ac53978a5d87d8a6b4121fd1d4482f67193fb8ad36c4"
    sha256 cellar: :any, ventura:       "dfa34e54b50981b7e6288dc831760bd0a9f3edd689d83648d932f361f779eb8c"
    sha256               arm64_linux:   "f1b50cbba8c11afc58a1240356c65025173cb6ade98a750b9a5eec6dbceefa32"
    sha256               x86_64_linux:  "4f29d7cd761b2ca7d7936c09750d0b9234feecc772d8b0edb3337f3d79b9c9a4"
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
