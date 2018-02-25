class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.18.8.tar.gz"
  mirror "https://fossies.org/linux/privat/LibRaw-0.18.8.tar.gz"
  sha256 "56aca4fd97038923d57d2d17d90aa11d827f1f3d3f1d97e9f5a0d52ff87420e2"

  bottle do
    cellar :any
    sha256 "78c084fc5afcd3ad27b4e3c2d204dccca0245bb7fe2ecb83e548da3029a72347" => :high_sierra
    sha256 "d05775198333d419870e088f3a2dfa80561de9679ab8c40feb82cee947894fc9" => :sierra
    sha256 "32ab54331d95ab449411a0cc92068885eaac78e5de0019c5e09cdad510671e0e" => :el_capitan
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
