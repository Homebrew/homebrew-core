class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.19.5.tar.gz"
  sha256 "40a262d7cc71702711a0faec106118ee004f86c86cc228281d12d16da03e02f5"

  bottle do
    cellar :any
    sha256 "2f0df8063fd5262b66f192f0ba4340857a5f29495c7c707397fa32abf130680b" => :mojave
    sha256 "29b9cf247b5c7ec15c86ad53cb8a50996ac30a5ea4ac7974b0ac10156cbb5eea" => :high_sierra
    sha256 "f869addc811f76dd7e2cab674517537c8a564095e20f3f3aebd4a6880033e30c" => :sierra
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
