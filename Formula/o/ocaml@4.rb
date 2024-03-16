# OCaml does not preserve binary compatibility across compiler releases,
# so when updating it you should ensure that all dependent packages are
# also updated by incrementing their revisions.
#
# Applications that really shouldn't break on a compiler update are:
# - coccinelle
class OcamlAT4 < Formula
  desc "General purpose programming language in the ML family"
  homepage "https://ocaml.org/"
  url "https://caml.inria.fr/pub/distrib/ocaml-4.14/ocaml-4.14.2.tar.xz"
  sha256 "7819f68693e32946f93358df46a8ea6f517222681fcc6f7cb96214216cfec764"
  license "LGPL-2.1-only" => { with: "OCaml-LGPL-linking-exception" }

  livecheck do
    url "https://ocaml.org/releases"
    regex(%r{href=.*?/releases/v?(4(?:\.\d+)+)/?["']}i)
  end

  bottle do
    sha256 arm64_sonoma:   "015d672de32d28f039ec897291e4c36803bcf562f3904fffecc17dbcd9f0aba6"
    sha256 arm64_ventura:  "a9b005aeb68d7e7cba4ddf72a2bd4d9683329e95dda048a002afc0f9ef23534b"
    sha256 arm64_monterey: "71f5a84d9137a11012664e65d7282b57dc1eea163f5c4d8e14c02b1dbb5da58f"
    sha256 sonoma:         "18a84964e30800cb1ef70b1336c2ce0e5d8eec0b3b017f10e6699ba06346922e"
    sha256 ventura:        "d4513f0912c5e6eada78a425c8380b2c6fc06055c9ac2b0ad612d1105c3d01d0"
    sha256 monterey:       "7d10dfd426a35c0dfd07cd6cb5969c0b7d572176bd2d1d40b79e6e49b0500230"
    sha256 x86_64_linux:   "8412292973241a9951911a94cd1245f861a225a881ef08839815954ce4a276fd"
  end

  # The ocaml compilers embed prefix information in weird ways that the default
  # brew detection doesn't find, and so needs to be explicitly blocked.
  pour_bottle? only_if: :default_prefix

  keg_only :versioned_formula

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
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
