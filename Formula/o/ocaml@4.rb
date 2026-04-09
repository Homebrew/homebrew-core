# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Applications that really shouldn't break on a compiler update are:
# - coccinelle
class OcamlAT4 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.3.tar.xz"
  sha256 "a5d583b8fbab9ea7bf6cf972ef9c38e7fedacbff6db7a34e3105115d343eb069"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(4(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 arm64_tahoe:   "ed89ebc0df114efbff9e61422150bea046920ff25fe869437e7dedd156c7d2ff"
    sha256 arm64_sequoia: "b072da183ffa7871244b81bb38a90b40b3ad454d3b00ae4778f93a297e467eff"
    sha256 arm64_sonoma:  "ecd5e126c817fc53a545cbdfb304acae5660d432f281c9e432a59403a81686dc"
    sha256 sonoma:        "e0b74e8a66297d2cf97ed44df50ef8278e97b4f17943b349c67863c1d829ce19"
    sha256 arm64_linux:   "f9eb45c7cf503266d07f5a06d2a76bbe57170aac527c22114d28ff8aa8525a67"
    sha256 x86_64_linux:  "fe5876a3ee1afa08d1910efb79609527b88006f55d050ac086ba1f8e47515579"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  keg_only :versioned_formula

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
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
