class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.18.9.tar.gz"
  sha256 "d2ef177032e6d804fc512b206d02c393fca26be43ecd136cc26926407273b24e"

  bottle do
    cellar :any
    sha256 "ccd4ebf23f666b13e3d3dcb95f18fda9f6b035cbb53263c168e8223a09f3e170" => :high_sierra
    sha256 "810088bc1b41ebfecc49f60c2b80d6565d78f23ed45d8aa9c00752081e1f5b73" => :sierra
    sha256 "1566500df3e77700fb6e1f33aa94e6b3fcb36a2ce1ef7a2da829b8b1241b6fb5" => :el_capitan
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
