class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.11.0/freetype-2.11.0.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.11.0.tar.xz"
  sha256 "8bee39bd3968c4804b70614a0a3ad597299ad0e824bc8aad5ce8aaf48067bde7"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "dab11f55546d96775ca3b8fb9aa9225c1fb3a2baa6b6dc9c03fe41066b82c6dc"
    sha256 cellar: :any,                 arm64_big_sur:  "e9bcfa10ec1ce289fd5fb38228918e83ec28c5aa8dd25d7b543a8db6c0da0e39"
    sha256 cellar: :any,                 monterey:       "1293f4b7e27bdbd72bce46ab6e365c7ddf02ef84b333810b7ace18e6f087c2e9"
    sha256 cellar: :any,                 big_sur:        "4e85cc5a025f1d8d9fedcb49775cfff4e1d2959bfda468445cecfc76c40edf17"
    sha256 cellar: :any,                 catalina:       "619ef51d198b0c4451e55d02f750c0f8f41614dcf7e108904c57e9eecca2fff1"
    sha256 cellar: :any,                 mojave:         "0ad6ce1ac305d4c8412f6c20ccdec2951fbf36eb2d971769d9a0910792001498"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "23cd32e04d63c7b1f2ac25da4e777d2813802c8cd9b527f50c595df722dd6d57"
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
