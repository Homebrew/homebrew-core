class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.10.4/freetype-2.10.4.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.4.tar.xz"
  sha256 "86a854d8905b19698bbc8f23b860bc104246ce4854dcea8e3b0fb21284f75784"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "5de27c6884ecd2174ee5e2e794d7b43c92339c22d08122d020c065a26ba59c5e" => :catalina
    sha256 "488e592f0a2be222d26d5affc99c9d4047aa98e36c50af9e5f2179a83ba718ef" => :mojave
    sha256 "5ade1e7eddcc11940262dd86c1e0ceec5b66c8a427e4eeccc5f1b95b0efb5187" => :high_sierra
  end

  depends_on "libpng"

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
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
