class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"
  revision 1

  bottle do
    sha256 "fa3818d518a214d9798a514e90c461d3a6be2c6fc0758c85ad4ad6b134a28851" => :catalina
    sha256 "76df021218eb1d338cb8ee2a18c04e1d120166991c94ba64055537beac0e68fb" => :mojave
    sha256 "45fb9e222b8c21729659821aa5565010df9c3f347fae4bc2f0e5fc01680a2c1a" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "guile@2"

  uses_from_macos "libxml2"

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
