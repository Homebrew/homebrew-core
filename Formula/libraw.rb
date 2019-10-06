class Libraw < Formula
  desc "Library for reading RAW files from digital photo cameras"
  homepage "https://www.libraw.org/"
  url "https://www.libraw.org/data/LibRaw-0.19.5.tar.gz"
  sha256 "40a262d7cc71702711a0faec106118ee004f86c86cc228281d12d16da03e02f5"

  bottle do
    cellar :any
    sha256 "0a6a6a01ee33d8a8ca2d97eba728958078173b51a3513c1ea4220c448869fb6a" => :catalina
    sha256 "7c962099ebd8959acee2921993e26120928604ff6809a1f7a372b95a00d2c130" => :mojave
    sha256 "f2e39a3e5811e1798fe84bc3122b9450eed0dfd861e586aaf9a76f13451942dd" => :high_sierra
    sha256 "684fb608b113365f690fad65636d45ae2f46469b10930363e45193ea9b4286ed" => :sierra
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
