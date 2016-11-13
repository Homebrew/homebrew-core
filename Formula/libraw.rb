class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "http://www.libraw.org/"
  url "http://www.libraw.org/data/LibRaw-0.17.2.tar.gz"
  mirror "https://fossies.org/linux/privat/LibRaw-0.17.2.tar.gz"
  mirror "https://distfiles.macports.org/libraw/LibRaw-0.17.2.tar.gz"
  sha256 "92b0c42c7666eca9307e5e1f97d6fefc196cf0b7ee089e22880259a76fafd15c"

  bottle do
    cellar :any
    sha256 "5aa5edf18067808c49d9558e09561e46471b6379a2585d6a679d3eed5a3c017a" => :sierra
    sha256 "69f893329b5740b50b5c9c1f06dc56ad5626d1d8ffb44cb1d2c6f8bf823e3dc7" => :el_capitan
    sha256 "431a9035a872fc91a52eccb1a4d382223065ac0bbfbd2d8b3b2ec5bef5d5de78" => :yosemite
    sha256 "664d0bc81586f6a1e68b441fbd5e2754f9ebf915630fb3ccb7142c054514f3f6" => :mavericks
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
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL2-0.17.2.tar.gz"
    mirror "https://distfiles.macports.org/libraw/LibRaw-demosaic-pack-GPL2-0.17.2.tar.gz"
    sha256 "a2e5e9cc04fa8f3e94070110dce8a06aa3b0b2f573ed99c5fc3e327d15f014b7"
  end

  resource "gpl3" do
    url "http://www.libraw.org/data/LibRaw-demosaic-pack-GPL3-0.17.2.tar.gz"
    mirror "https://distfiles.macports.org/libraw/LibRaw-demosaic-pack-GPL3-0.17.2.tar.gz"
    sha256 "b00cd0f54851bd3c8a66be4cacbf049e4508f1bac8ff85cb4528d8979739ed36"
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
