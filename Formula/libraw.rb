class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.18.4.tar.gz"
  mirror "https://fossies.org/linux/privat/LibRaw-0.18.4.tar.gz"
  sha256 "eaf4931b46e65861e88bbe704ccf370381e94d63e9a898b889ded4e0cb3b0c97"

  bottle do
    cellar :any
    sha256 "7a444524abc75a6219a3080e475d3ce495afd2d7a44854390a9bd91bf1ae785e" => :sierra
    sha256 "186e97955a3a245bdb46a46b58d8b9d5eec0f1e6c7d6d37882fe2586460ba029" => :el_capitan
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
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.18.4.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL2-0.18.4.tar.gz"
    sha256 "8961b0a90d4b1a5d00a13d9ed2f23e8f2c651b4a68c0470e01ba7668cc98145f"
  end

  resource "gpl3" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.18.4.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL3-0.18.4.tar.gz"
    sha256 "9aa8ad60581b9c6a0ed81d96f897804cac832c7eeb087a38ca61fcd54838966c"
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
