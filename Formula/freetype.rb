class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.12.0/freetype-2.12.0.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.12.0.tar.xz"
  sha256 "ef5c336aacc1a079ff9262d6308d6c2a066dd4d2a905301c4adda9b354399033"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "be3cb9b02246eba786391282c6a9a2f522ef6675eda2aaef77ba72cbce7e4567"
    sha256 cellar: :any,                 arm64_big_sur:  "171677a9c53044381b2a1d9e1060e6153617e72ddaed4867b95f1982850a9e5b"
    sha256 cellar: :any,                 monterey:       "3424dbc7bc95ec38890c3ff7b6bd3c6a1ed6e56a9a42814951076f4485516547"
    sha256 cellar: :any,                 big_sur:        "e43fe6566bbb42a76cb09e3bb5a0efa201a6a25555ae4c057d856e20fb6d540e"
    sha256 cellar: :any,                 catalina:       "c16bc37cc0d9840f87b7f89eb54f6c3e79f3757d8eb1acc371dd5af5d5cdbb7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b9bf649c16033dc4fcea694384136f8ee13fe2f924b4a443b02fd7bab0ff368b"
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
