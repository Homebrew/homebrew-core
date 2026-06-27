# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Applications that really shouldn't break on a compiler update are:
# - coccinelle
class OcamlAT4 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.4.tar.xz"
  sha256 "531df6280ecf3d3029ed4404858d37c122470a04c9a4104e6b48ee4f762f175c"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(4(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 arm64_tahoe:   "cc9600dc6d0595e10ed18ac67c03518dce597ede42b2cb45c848fb412e6bec21"
    sha256 arm64_sequoia: "165d3e8dd8a68b44a1a65f51201166ab0c37c9941c3a0a4087cb4da595c52118"
    sha256 arm64_sonoma:  "702a39a41b6587f1f5ed678866c8006e7e30c0094b5281cbabc098c220f4cfef"
    sha256 sonoma:        "a4bb1f4e38b2caddcf49e6fa16ece91e5870871bb426a6a62e0b6dd99335ac66"
    sha256 arm64_linux:   "9b18a8a82f54d73496427a73b959829c6bcb0c26cfafccbcf4d7151a55413dbf"
    sha256 x86_64_linux:  "8dd150854fb5d24f34deb8b7676ea76a5e2135d1447b8bffe4a4723ecc57756e"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  keg_only :versioned_formula

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    file "Patches/libtool/configure-big_sur.diff"
  end

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
