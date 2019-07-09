class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.19.3.tar.gz"
  sha256 "fd96d6188b8539e0724c89cfa9de392eb28ea71db117ef0661846d76cdc24177"

  bottle do
    cellar :any
    sha256 "0abbb192dbe6464e84b81009ecf957748ea4cb00a721eb0157d08c2325c67a43" => :mojave
    sha256 "a35af2fb6335b0a6d2ec6a99b112e6677df436f9cd074894ea4a1c26ac27b16b" => :high_sierra
    sha256 "16dd714a8cc2609f4edd4bc881a2d8e7b37379df5867b365ae4d8a02b120bbcd" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "libomp"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "ac_cv_prog_c_openmp=-Xpreprocessor -fopenmp",
                          "ac_cv_prog_cxx_openmp=-Xpreprocessor -fopenmp",
                          "LDFLAGS=-lomp"
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
