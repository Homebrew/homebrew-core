class Autogen < Formula
  desc "Automated text file generator"
  homepage "https://autogen.sourceforge.io"
  url "https://ftp.gnu.org/gnu/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  mirror "https://ftpmirror.gnu.org/autogen/rel5.18.16/autogen-5.18.16.tar.xz"
  sha256 "f8a13466b48faa3ba99fe17a069e71c9ab006d9b1cfabe699f8c60a47d5bb49a"

  bottle do
    sha256 "bf05048f02504d4dd73f5204abcfd7b880dca3ef65ed6c1a11a2836fed1efd80" => :mojave
    sha256 "c9835af12e309b7992918e64fc766f59ca50ff3f4e846434d74141859d638cd8" => :high_sierra
    sha256 "c80dbb65f3afee35378aadaf766cd3d772d39256ec6d48b9864ecab018a931e9" => :sierra
    sha256 "ff8c66ca7d86c309e884dad0fcc49aadf65a830768a0551c5711cba2f6d6a046" => :el_capitan
  end

  depends_on "coreutils" => :build
  depends_on "pkg-config" => :build
  depends_on "guile"

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
