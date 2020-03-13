class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.0.0/gmt-6.0.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.0.0-src.tar.xz"
  mirror "https://fossies.org/linux/misc/GMT/gmt-6.0.0-src.tar.xz"
  sha256 "8b91af18775a90968cdf369b659c289ded5b6cb2719c8c58294499ba2799b650"
  revision 4
  head "https://github.com/GenericMappingTools/gmt.git"

  bottle do
    sha256 "5ccf532a1260e3e92076544bc9482265f916e24a7ffc248265c71c61ffd286ea" => :catalina
    sha256 "6b151e0b74403ed1be064bb6b797cfaa55041e654a6cf35156575b9643b1a26c" => :mojave
    sha256 "6ed13ba35599043fb4fbcd7fac1074a5534a938136f09ea9d513c7e835df8295" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "fftw"
  depends_on "gdal"
  depends_on "netcdf"
  depends_on "pcre"

  resource "gshhg" do
    url "https://github.com/GenericMappingTools/gshhg-gmt/releases/download/2.3.7/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "https://github.com/GenericMappingTools/dcw-gmt/releases/download/1.1.4/dcw-gmt-1.1.4.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-1.1.4.tar.gz"
    mirror "https://fossies.org/linux/misc/GMT/dcw-gmt-1.1.4.tar.gz"
    sha256 "8d47402abcd7f54a0f711365cd022e4eaea7da324edac83611ca035ea443aad3"
  end

  unless build.head?
    # The following two patches fix a problem in detecting locally installed
    # html pages (https://github.com/GenericMappingTools/gmt/issues/1960).
    # They must be removed when GMT 6.0.1 is released.
    patch do
      url "https://github.com/GenericMappingTools/gmt/commit/b65dc6eb.diff?full_index=1"
      sha256 "459dee38eef6b0c960a3d3a992ac715e82693c4c2cd34afd99965faf07cce2f8"
    end

    patch do
      url "https://github.com/GenericMappingTools/gmt/commit/daf64655.diff?full_index=1"
      sha256 "f2b5b0d5c4d6f568f453365f857c09429f2e29f9e72b220ca17a81128db75d37"
    end
  end

  def install
    (buildpath/"gshhg").install resource("gshhg")
    (buildpath/"dcw").install resource("dcw")

    # GMT_DOCDIR and GMT_MANDIR must be relative paths
    args = std_cmake_args.concat %W[
      -DCMAKE_INSTALL_PREFIX=#{prefix}
      -DGMT_DOCDIR=share/doc/gmt
      -DGMT_MANDIR=share/man
      -DGSHHG_ROOT=#{buildpath}/gshhg
      -DCOPY_GSHHG:BOOL=TRUE
      -DDCW_ROOT=#{buildpath}/dcw
      -DCOPY_DCW:BOOL=TRUE
      -DFFTW3_ROOT=#{Formula["fftw"].opt_prefix}
      -DGDAL_ROOT=#{Formula["gdal"].opt_prefix}
      -DNETCDF_ROOT=#{Formula["netcdf"].opt_prefix}
      -DPCRE_ROOT=#{Formula["pcre"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=FALSE
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
