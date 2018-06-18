class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.18.12.tar.gz"
  sha256 "57754d75a857e16ba1c2a429e4b5b4d79160a59eadaec715351fc9c8448653d4"

  bottle do
    cellar :any
    sha256 "85f56dde43eccb47cd19882c3b763e7025e3d855c523ac9bf18d2e321bd8893c" => :high_sierra
    sha256 "32901febfbdd36674c1ade6d098071f3543f2593144331c4e56b0fc232b673ab" => :sierra
    sha256 "b98d8939eb4f77bd29b39258d795b039c5fe214867ec8970cb663a318c2efba6" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF",
      :using => :nounzip
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  resource "gpl2" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.18.8.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL2-0.18.8.tar.gz"
    sha256 "0b24bcf7bbb5d13fde58bb071f94dc9354be09bc44b2bba0698493065e99f8da"
  end

  resource "gpl3" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.18.8.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL3-0.18.8.tar.gz"
    sha256 "ffd6916cd66c8101e4e6b589799f256c897748d2fd2486aa34c3705146dbc701"
  end

  def install
    %w[gpl2 gpl3].each { |f| (buildpath/f).install resource(f) }
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-demosaic-pack-gpl2=#{buildpath}/gpl2",
                          "--enable-demosaic-pack-gpl3=#{buildpath}/gpl3"
    system "make"
    system "make", "install"
    doc.install Dir["doc/*"]
    prefix.install "samples"
  end

  test do
    resource("librawtestfile").stage do
      filename = "RAW_NIKON_D1.NEF"
      system "#{bin}/raw-identify", "-u", filename
      system "#{bin}/simple_dcraw", "-v", "-T", filename
    end
  end
end
