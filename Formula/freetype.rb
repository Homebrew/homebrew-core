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
    sha256 cellar: :any,                 arm64_big_sur: "0d3385d0d11a5d0198c09bfb77ba854766a3345067023d2fdc9b486ead52c392"
    sha256 cellar: :any,                 big_sur:       "01b464b98584ba5777d8fc4605121c7a46e713a2f58d729197b82afef1b5f2b9"
    sha256 cellar: :any,                 catalina:      "b4e7683ae202c49280024faac4ac7437e690cb5dd83edb806fac368bc2b7de35"
    sha256 cellar: :any,                 mojave:        "81c65539bcc98d171fdff7a6e80cdddd7dc4bc9ed34e739c4361ab66f3391991"
    sha256 cellar: :any,                 high_sierra:   "666892404720bcd855d866976e1cb9beecc3151ca595c3dd115a0daa6bb6c7e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f34a59b344d9f0334e05b6ddb5b8e7420c3922a6f42daf770614622bba93dc4a"
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
