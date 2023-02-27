class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.13.0/freetype-2.13.0.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.13.0.tar.xz"
  sha256 "5ee23abd047636c24b2d43c6625dcafc66661d1aca64dec9e0d05df29592624c"
  license "FTL"
  revision 1

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "65ed8248089c18ea551ef9b5fb3c73169474fc65265e8a2add4a26b3aa148786"
    sha256 cellar: :any,                 arm64_monterey: "d033f56061ca56a706a77ba559236035f945c308bf0eb4fb566df5d03f22ab84"
    sha256 cellar: :any,                 arm64_big_sur:  "4c58a078509f7dae12f54f7e6a37c187f01841147c8c8e742e3efb005c39e65d"
    sha256 cellar: :any,                 ventura:        "bd4a977cbe23bafdf3fe0a03a48030b0d2358494ba3ed3d996b2d3e4b0782c7c"
    sha256 cellar: :any,                 monterey:       "01062aba71dad8de5e56a6f312fe589838f456b0741bf451a468423e0dea7978"
    sha256 cellar: :any,                 big_sur:        "deb64487830d468d5a2d9b4fd840ed383cf283d496e37e2c3b9b6897dea99733"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cc9ca454d4115c028b018f5aa7098b09099dea807fa4a5d5b928acc8d5c965c"
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    # This file will be installed to bindir, so we want to avoid embedding the
    # absolute path to the pkg-config shim.
    inreplace "builds/unix/freetype-config.in", "%PKG_CONFIG%", "pkg-config"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-freetype-config",
                          "--without-harfbuzz"
    system "make"
    system "make", "install"

    inreplace [bin/"freetype-config", lib/"pkgconfig/freetype2.pc"],
      prefix, opt_prefix
  end

  test do
    system bin/"freetype-config", "--cflags", "--libs", "--ftversion",
                                  "--exec-prefix", "--prefix"
  end
end
