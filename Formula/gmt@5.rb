class GmtAT5 < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org"
  url "ftp://ftp.soest.hawaii.edu/gmt/gmt-5.4.5-src.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-5.4.5-src.tar.xz"
  mirror "https://fossies.org/linux/misc/GMT/gmt-5.4.5-src.tar.xz"
  sha256 "225629c7869e204d5f9f1a384c4ada43e243f83e1ed28bdca4f7c2896bf39ef6"

  bottle do
    sha256 "31b9d3f242e271459ccf542c37408a4f35ff294f5d2949330a2f8922e26f7ea4" => :catalina
    sha256 "88a338eebedde949c06723fa7a8bf462cd9d759c97ba2000b4069e3840dc19c4" => :mojave
    sha256 "51f8e1cd6a64d50a92d953d79f268907a93b89fe2357aa3326bd3b7af1073107" => :high_sierra
  end

  keg_only :versioned_formula

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre"

  resource "gshhg" do
    url "ftp://ftp.soest.hawaii.edu/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "ftp://ftp.soest.hawaii.edu/gmt/dcw-gmt-1.1.4.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-1.1.4.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/dcw-gmt-1.1.4.tar.gz"
    sha256 "8d47402abcd7f54a0f711365cd022e4eaea7da324edac83611ca035ea443aad3"
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

  def caveats; <<~EOS
    GMT needs Ghostscript for the 'psconvert' command to convert PostScript files
    to other formats. To use 'psconvert', please 'brew install ghostscript'.
  EOS
  end

  test do
    system "#{bin}/pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end
