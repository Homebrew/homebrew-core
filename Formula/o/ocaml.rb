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
  url "https://caml.inria.fr/pub/distrib/ocaml-5.5/ocaml-5.5.1.tar.xz"
  sha256 "cd0a97bdbfc99f00f53f4ee48491964c73627afb09ed8e4de230ba4488a3d6b9"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  compatibility_version 4
  head "https://github.com/ocaml/ocaml.git", branch: "trunk"

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(\d+(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 arm64_golden_gate: "95adb6440d66e2da94536ea4e820c4bfc18670cbef5e39ed1da430e26efef2aa"
    sha256 arm64_tahoe:       "5331b7eaf0ea569bf7807fd69c2f155f0a70f30e0544166d4f903bab57d0f5c5"
    sha256 arm64_sequoia:     "ff8bff28f3edc0973363b2bcef67399747bd17d913a0409fe9cfd34b97e8bfe7"
    sha256 arm64_linux:       "9a3dc5d0f4dee1393f0500b78b1f21ecc7af0d6d5ec60c466211519673f2bd74"
    sha256 x86_64_linux:      "bb7764e69bf78bd310d1148d979fb6f99097ed73c1c40e379269ef903d5c0b03"
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
