class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.14.1/freetype-2.14.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.14.1.tar.xz"
  sha256 "32427e8c471ac095853212a37aef816c60b42052d4d9e48230bab3bdf2936ccc"
  license "FTL"

  livecheck do
    url :stable
    regex(/url=.*?freetype[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c49a5a2d0bab792738c9d59c7c02f5621ece28cfc86d7146daea8574229e0b1"
    sha256 cellar: :any,                 arm64_sequoia: "fee385426a9952d3908ea5e16ab58d2c163552e830f599ff77803d754ae387de"
    sha256 cellar: :any,                 arm64_sonoma:  "a289cd53c3e2dd805c3522d60e88eea064ce450bec502f995fc265aa2463245c"
    sha256 cellar: :any,                 arm64_ventura: "57018a229192c98001aaa3d1130c4e0418f31c0a971b6b077c913a686d9a5031"
    sha256 cellar: :any,                 sonoma:        "62b0d3d117cd464d5c0a543a70b904cb70b5ad5acbbbc895145198e6a59f5add"
    sha256 cellar: :any,                 ventura:       "87429574943de1331309e288b9e109ffc0b2eb2319b893df3fe29b3fddce2267"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bc4db14d9c513a8d1060bf77bff0a294f4d985b3f6b434d326a9f6f282f0d74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cf8c29c64099d537903e4c1eae1ddcd361bac5c9d28440806506d0e94728f57"
  end

  depends_on "pkgconf" => :build
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
