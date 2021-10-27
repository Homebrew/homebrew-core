class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"
  revision 1

  livecheck do
    url :stable
    regex(%r{href=.*?rel(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 arm64_monterey: "dc64368c53d0eb66c1b093ccbba95d0fddaf2e9fc3053cee87a945309c0641af"
    sha256 arm64_big_sur:  "5058d3eb0e5520f98914d8d3cc37d941ff260e36d7ccb2733b2b0dd8d7026ad8"
    sha256 monterey:       "b6478645478663fad015e53f5ce2aa2b6dda32a40fedeb2b8c3b1e0a29a6ddab"
    sha256 big_sur:        "f648b54769e2022a5801ba90716855fee7c1266b906b8f768934bde0063c05ea"
    sha256 catalina:       "fa3818d518a214d9798a514e90c461d3a6be2c6fc0758c85ad4ad6b134a28851"
    sha256 mojave:         "76df021218eb1d338cb8ee2a18c04e1d120166991c94ba64055537beac0e68fb"
    sha256 high_sierra:    "45fb9e222b8c21729659821aa5565010df9c3f347fae4bc2f0e5fc01680a2c1a"
    sha256 x86_64_linux:   "459c36573772600aab0085300e551ecbbe224a8b036bc10c15d48db1719a5a52"
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "guile@2"

  uses_from_macos "libxml2"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Uses GNU-specific mktemp syntax: https://sourceforge.net/p/autogen/bugs/189/
    inreplace %w[agen5/mk-stamps.sh build-aux/run-ag.sh config/mk-shdefs.in], "mktemp", "gmktemp"
    # Upstream bug regarding "stat" struct: https://sourceforge.net/p/autogen/bugs/187/
    system "./configure", "ac_cv_func_utimensat=no",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"

    # make and install must be separate steps for this formula
    system "make"
    system "make", "install"
  end

  test do
    system bin/"autogen", "-v"
  end
end
