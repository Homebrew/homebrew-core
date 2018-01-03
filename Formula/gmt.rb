class Gmt < Formula
  desc "Tools for processing and displaying xy and xyz datasets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-5.4.3-src.tar.xz"
  mirror "http://gd.tuwien.ac.at/pub/gmt/gmt-5.4.3-src.tar.xz"
  mirror "http://ftp.iris.washington.edu/pub/gmt/gmt-5.4.3-src.tar.xz"
  mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gmt-5.4.3-src.tar.xz"
  sha256 "ed00e380c3dc94a3aef4b7aeaaac0f3681df703dc614e8a15a1864e20b3fa2c8"

  bottle do
    sha256 "4b04dea31bebdcfd82673de995e037f852397258a90852622aee8a917aa3a03d" => :high_sierra
    sha256 "fbd37a8573c3935b9404db3fea2260c654f787740755ddba3d88afde3553271c" => :sierra
    sha256 "d05657c555e8e1f3dab2bd57de31a016dd3a5d9e6059c3b1fd123081e0d584ef" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "http://gd.tuwien.ac.at/pub/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "http://ftp.iris.washington.edu/pub/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "http://gd.tuwien.ac.at/pub/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "http://ftp.iris.washington.edu/pub/gmt/dcw-gmt-1.1.2.tar.gz"
    mirror "ftp://ftp.star.nesdis.noaa.gov/pub/sod/lsa/gmt/dcw-gmt-1.1.2.tar.gz"
    sha256 "f719054f8d657e7b10b5182d4c15bc7f38ef7483ed05cdaa9f94ab1a0008bfb6"
  end

  def install
    (buildpath/"gshhg").install resource("gshhg")
    (buildpath/"dcw").install resource("dcw")

    args = std_cmake_args.concat %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DGMT_DOCDIR=#{share}/doc/gmt
      -DGMT_MANDIR=#{man}
      -DGSHHG_ROOT=#{buildpath}/gshhg
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{buildpath}/dcw
      -DCOPY_DCW:BOOL=TRUE
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DPCRE_ROOT=#{Formula["pcre"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=TRUE
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DLICENSE_RESTRICTED:BOOL=FALSE
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end
