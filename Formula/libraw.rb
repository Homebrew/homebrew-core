class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.18.7.tar.gz"
  mirror "https://fossies.org/linux/privat/LibRaw-0.18.7.tar.gz"
  sha256 "87e347c261a8e87935d9a23afd750d27676b99f540e8552314d40db0ea315771"

  bottle do
    cellar :any
    sha256 "bebd6c0694c67593ce45490cb4ffd61d58c818c5b4ae6b31d8ea916762d84cb0" => :high_sierra
    sha256 "1a65f30134041eceb80423b1f19ecbb2fb740e1f5c033510caf84a962bf53f84" => :sierra
    sha256 "0e205ba21559b62baa00ec438dd177186a3bbc9cab420ad5f960ff9d6721f130" => :el_capitan
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
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.18.7.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL2-0.18.7.tar.gz"
    sha256 "4264c6fb586dade28a3a05e46d2b189938700117cb91ec19c7f826b9c7b6b08a"
  end

  resource "gpl3" do
    url "https://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.18.7.tar.gz"
    mirror "https://ftp.osuosl.org/pub/gentoo/distfiles/LibRaw-demosaic-pack-GPL3-0.18.7.tar.gz"
    sha256 "dca6166456d73bf57be1102a6c46308da2f1969073f5af936c7dc85c33803de0"
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
