# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Applications that really shouldn't break on a compiler update are:
# - coccinelle
class OcamlAT4 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.5.tar.xz"
  sha256 "84a2d5450872876524b411ee875d06e4c23805d2a80bf0ff02db2e90ece76d8b"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }
  compatibility_version 1

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(4(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 arm64_golden_gate: "f89b39077cb0d6ddc603d1dce0aa5edef17713c57dca16ec245c1eb8309b3a5c"
    sha256 arm64_tahoe:       "6e9a59d8e3123cfa97be3eb3cc5ecb0c7ceb9236d4ef56678c1e3aa802fc48f0"
    sha256 arm64_sequoia:     "062a7bc2b47915d8c8b42f44285c25889992240fc462b1bd7c0db4b1c8b50289"
    sha256 arm64_linux:       "3197c91ff62e0ca714a5740c6455639db85100aaea4443ce2d47acc0c030c522"
    sha256 x86_64_linux:      "dd69b27aedb6f8cc833a2dbe601bc98c5839e6e1706ff8f49bf406c27e001bc7"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  keg_only :versioned_formula

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
    type :unofficial
  end

  deny_network_access!

  def install
    ENV.deparallelize # Builds are not parallel-safe, esp. with many cores

    # the ./configure in this package is NOT a GNU autoconf script!
    args = %W[
      --prefix=#{prefix}
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
  end
end
