class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.18.5.tar.gz"
  mirror "https://fossies.org/linux/privat/LibRaw-0.18.5.tar.gz"
  sha256 "fa2a7d14d9dfaf6b368f958a76d79266b3f58c2bc367bebab56e11baa94da178"

  bottle do
    cellar :any
    sha256 "e2c66181e35ae77228106c309d6a62d7093499196aad16e3eef8fb226f981c7d" => :high_sierra
    sha256 "08454b1762f382279b0c1fddfb7ddfd4731237737e71518750c285575e5ef4d9" => :sierra
    sha256 "1e4b77a1787c53ae5f9c0d25bc545b34e69b47e85ca53fb8da92785bd744db01" => :el_capitan
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
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.18.5.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL2-0.18.5.tar.gz"
    sha256 "2ae7923868c3e927eee72cf2e4d91384560b7cfe76a386ecf319c069d343c674"
  end

  resource "gpl3" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.18.5.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL3-0.18.5.tar.gz"
    sha256 "b0ec998c4884cedd86a0627481a18144f0024a35c7a6fa5ae836182c16975c2b"
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
