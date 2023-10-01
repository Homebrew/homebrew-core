class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.13.2/freetype-2.13.2.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.13.2.tar.xz"
  sha256 "12991c4e55c506dd7f9b765933e62fd2be2e06d421505d7950a132e4f1bb484d"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "8966d44484907e98ea2b0fa4b3708627285d0eae3ca0eeb5d3f158cc0437e3f7"
    sha256 cellar: :any,                 arm64_ventura:  "cfafda736bbfdd0b89b0e278d31253139f5b33762fdee1f6aae7da27edb22c65"
    sha256 cellar: :any,                 arm64_monterey: "44789663febc92d337e87ad94ca1ba7ae643748ceeea25f6beb3c11c9d80fa9f"
    sha256 cellar: :any,                 arm64_big_sur:  "22f5d7b4377c712581793d54bcec7b85c9f6edafdc4a7a50241318f3ddcc6a24"
    sha256 cellar: :any,                 sonoma:         "a8813d5f4045ff8e30755a708eb0da84188b47b04d279c860ffdda3188112444"
    sha256 cellar: :any,                 ventura:        "352a82fcc4a51411403697f53703a4f46c92219963344ed66f499688fc036a2c"
    sha256 cellar: :any,                 monterey:       "ecd47039beaf32c82cb68cc38a7ea07951dd5ff3ac2c5fd22a33bf987462047c"
    sha256 cellar: :any,                 big_sur:        "1a049a8b0ce1d6cca6429bd4274895d053990c916e8ce937aa212821d5802d6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f4f7449ac197844846126b6e002f7faf10b5da5b333f203e3a0a8573b970835"
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
