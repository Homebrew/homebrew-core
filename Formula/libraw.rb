class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.18.2.tar.gz"
  mirror "https://fossies.org/linux/privat/LibRaw-0.18.2.tar.gz"
  sha256 "ce366bb38c1144130737eb16e919038937b4dc1ab165179a225d5e847af2abc6"

  bottle do
    cellar :any
    sha256 "aab2850635262ead96b82e2a4ff4bfb6ace3407ecb1612b5b9924efdbc51fe92" => :sierra
    sha256 "fa117e74153ef507d15cbd1706054265dab743b662bc46ad6e9afe8d0a9ccb2b" => :el_capitan
    sha256 "1cdb2cbdebdd4a14079e30dbc7d994b8136c21a0bdb987a8c9f74f4f4c0a9b09" => :yosemite
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
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.18.2.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL2-0.18.2.tar.gz"
    sha256 "f467689182728240c6358c1b890e9fe4ee08667c74433f6bd6a4710e3ae2aab6"
  end

  resource "gpl3" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.18.2.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL3-0.18.2.tar.gz"
    sha256 "01080bc2448de87339f086229319c9e1cca97ac0621416feb537b96f0dba4a57"
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
