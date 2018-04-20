class Gmt < Formula
  desc "Tools for processing and displaying xy and xyz datasets"
  homepage "https://gmt.soest.hawaii.edu/"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-5.4.3-src.tar.xz"
  mirror "https://fossies.org/linux/misc/GMT/gmt-5.4.3-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-5.4.3-src.tar.xz"
  sha256 "ed00e380c3dc94a3aef4b7aeaaac0f3681df703dc614e8a15a1864e20b3fa2c8"
  revision 3

  bottle do
    sha256 "1a3ec4dd62997f9b9dd58eb93bcfb06d85053afb67ba1a025d4ee83c14165a00" => :high_sierra
    sha256 "2c62a92e2fc0d68f7aed44d1e727b95d3191025ecad757fa033cecfe5f09d1ca" => :sierra
    sha256 "59edd37d3f0d29a3fbc73dddef12fab7bfd9d8cee5a44205f57701ba71c523ab" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-1.1.3.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-1.1.3.tar.gz"
    sha256 "1395e772c3f2d2900c78260ad4a9df2fecd9216e362ad141762f7499bfeb4f23"
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
