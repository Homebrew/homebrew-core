class Freetype < Formula
  desc "Software library to render fonts"
  homepage "https://www.freetype.org/"
  url "https://downloads.sourceforge.net/project/freetype/freetype2/2.9.1/freetype-2.9.1.tar.bz2"
  mirror "https://download.savannah.gnu.org/releases/freetype/freetype-2.9.1.tar.bz2"
  sha256 "db8d87ea720ea9d5edc5388fc7a0497bb11ba9fe972245e0f7f4c7e8b1e1e84d"

  bottle do
    cellar :any
    sha256 "64d650278af1f74d43165f3943287b42109710e672d2756abaa492f0cc4d52b7" => :mojave
    sha256 "444ef60a543aca6ca26223f46182c914e26d2908f33fca41cb54bcf9a81084a3" => :high_sierra
    sha256 "4afc7a144563abc6f4e58ef45aa57da598051290e7568afbff028585717b30fa" => :sierra
    sha256 "8f8fbbe028986cebd4a49c399e4861fb85cb6173298ba957172cb1ed915682ab" => :el_capitan
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
