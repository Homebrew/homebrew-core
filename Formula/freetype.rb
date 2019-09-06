class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.10.1/freetype-2.10.1.tar.xz"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.10.1.tar.xz"
  sha256 "16dbfa488a21fe827dc27eaf708f42f7aa3bb997d745d31a19781628c36ba26f"

  bottle do
    cellar :any
    sha256 "2f5716f987df6f45a9d66e5f9af935bbb4202fe0b9850b6b0660fd6555ba1be4" => :mojave
    sha256 "c367032a79a287a004e29023329c74e19887b80e05c495eec44182165ecd79e0" => :high_sierra
    sha256 "282171a01965ae9dfd2d7955459a7285ca3a85f16504133e5fa46c72f682c14f" => :sierra
  end

  depends_on "libpng"

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
