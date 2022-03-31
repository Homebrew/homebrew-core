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
    sha256 cellar: :any,                 arm64_monterey: "ef390f0021a584396d8f168de0666d9f4d2dec560b7f7b58f60ca93d3b795fad"
    sha256 cellar: :any,                 arm64_big_sur:  "7621db36f0e51ae0bb9094d56ae5462fbf249969aff225555c1e5845fe7477c1"
    sha256 cellar: :any,                 monterey:       "e1320cb3ec023546f9d436a65b7a1421027fbe7ec87a1ecb158b6c78fe6098e3"
    sha256 cellar: :any,                 big_sur:        "5cbd30acd1a8447bd66a3d3933b3f7cb9836d2c9cd49a6bd7f64b2225ef1fc4b"
    sha256 cellar: :any,                 catalina:       "e5f8d1d7a2ed7c60cce95358f33503301280e147beed7fbed0fd1c2c06d26fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc2ddc421163f9ee9cbb7743921b26daf6d49c44938d5eb264db1ecbdfe0f835"
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
