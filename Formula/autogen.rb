class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"

  bottle do
    sha256 "e103302688bc9f7e4493c8827133f3341ab701740249196ddbfc2f2cf4fc1246" => :catalina
    sha256 "693b555483cf3f1e67516e45b31ad7718f041c97349ef655e28d55b1918b4e3f" => :mojave
    sha256 "7b79a5aa968c4d95660efb7a30bfb2c747dde2eefb1cf95efdc9fea7847b9151" => :high_sierra
    sha256 "19891a89ee7465e2690d34494e2ee41afee0dfda661a0c1c7407d283438e911e" => :sierra
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"
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
