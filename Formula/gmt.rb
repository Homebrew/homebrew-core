class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.4.0/gmt-6.4.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.4.0-src.tar.xz"
  sha256 "b46effe59cf96f50c6ef6b031863310d819e63b2ed1aa873f94d70c619490672"
  license "LGPL-3.0-or-later"
  revision 3
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "164d3605adbf28720cc6adc8d48bcf972d27e5b680321ac88ad6cf4b1bc5099f"
    sha256 arm64_monterey: "ca232788312596bf7e84f03ef42be854f54bc3837e2331617acafcc03bf3fba6"
    sha256 arm64_big_sur:  "6b83d49c7b577f85da0365d4b413ec9d397e09178b83e9d15992e1af71b54995"
    sha256 ventura:        "47ee9841c780614e59cbb47c0f78211a622b46bc5748c241f3df94022b82c302"
    sha256 monterey:       "5a90873c6aa079ec6bc4ab9ff8aad6be41102df8add7523604974d59000b6226"
    sha256 big_sur:        "13cefce12bc37b31da158300bbc4abcf63cbe7bedd66947439757def3b18abe2"
    sha256 catalina:       "4718189f7136c6edca862db0a5ab95799c336085007a27549704eaf1443c847c"
    sha256 x86_64_linux:   "484c095a04521622dba488f8ba0d4b72102ba6e71ddae302f195d4c914a5b80d"
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre2"

  resource "gshhg" do
    url "https://github.com/GenericMappingTools/gshhg-gmt/releases/download/2.3.7/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "https://github.com/GenericMappingTools/dcw-gmt/releases/download/2.1.1/dcw-gmt-2.1.1.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-2.1.1.tar.gz"
    sha256 "d4e208dca88fbf42cba1bb440fbd96ea2f932185c86001f327ed0c7b65d27af1"
  end

  def install
    (buildpath/"gshhg").install resource("gshhg")
    (buildpath/"dcw").install resource("dcw")

    # GMT_DOCDIR and GMT_MANDIR must be relative paths
    args = %W[
      -DGMT_DOCDIR=share/doc/gmt
      -DGMT_MANDIR=share/man
      -DGSHHG_ROOT=#{buildpath}/gshhg
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{buildpath}/dcw
      -DCOPY_DCW:BOOL=TRUE
      -DPCRE_ROOT=FALSE
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DPCRE2_ROOT=#{Formula["pcre2"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=FALSE
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DLICENSE_RESTRICTED:BOOL=FALSE
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    inreplace bin/"gmt-config", Superenv.shims_path/ENV.cc, DevelopmentTools.locate(ENV.cc)
  end

  def caveats
    <<~EOS
      GMT needs Ghostscript for the 'psconvert' command to convert PostScript files
      to other formats. To use 'psconvert', please 'brew install ghostscript'.

      GMT needs FFmpeg for the 'movie' command to make movies in MP4 or WebM format.
      If you need this feature, please 'brew install ffmpeg'.

      GMT needs GraphicsMagick for the 'movie' command to make animated GIFs.
      If you need this feature, please 'brew install graphicsmagick'.
    EOS
  end

  test do
    system "#{bin}/gmt pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P > test.ps"
    assert_predicate testpath/"test.ps", :exist?
  end
end
