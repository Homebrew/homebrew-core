class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.19.2.tar.gz"
  sha256 "400d47969292291d297873a06fb0535ccce70728117463927ddd9452aa849644"

  bottle do
    cellar :any
    sha256 "28a8d643501d0ba5d5b91e081a78e4f39038116de99598787e8c9af5f3394cb3" => :mojave
    sha256 "3304c2735f53a0967fd6ca446365d12e455119fe331b36af666b6b64bbcafa08" => :high_sierra
    sha256 "b8fd178ff8f28172a77b109daa7b8e71f564291fe9725f0e096988ec258f742f" => :sierra
    sha256 "aa91b68a3f4aa66cca36c0348e2167339319ee1628ab0369031473b4a4cfe043" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libomp"
  depends_on "jasper"
  depends_on "jpeg"
  depends_on "little-cms2"

  resource "librawtestfile" do
    url "https://www.rawsamples.ch/raws/nikon/d1/RAW_NIKON_D1.NEF"
    sha256 "7886d8b0e1257897faa7404b98fe1086ee2d95606531b6285aed83a0939b768f"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "ac_cv_prog_c_openmp=-Xpreprocessor\\ -fopenmp",
                          "ac_cv_prog_cxx_openmp=-Xpreprocessor\\ -fopenmp",
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
