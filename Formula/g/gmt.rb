class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.4.0/gmt-6.4.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.4.0-src.tar.xz"
  sha256 "b46effe59cf96f50c6ef6b031863310d819e63b2ed1aa873f94d70c619490672"
  license "LGPL-3.0-or-later"
  revision 8
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "940750a21ca2f619bec475428be560fc084e838d90a608bb36ce7e83913e2e42"
    sha256 arm64_ventura:  "2c478f7eaad97757d8dec773ffd8abbf86e1a7c410e8f514703e866cb5998e4b"
    sha256 arm64_monterey: "9c69a27b194966e39f0d25e14ac9fafc059caa27bff91a92455787fe6d493fa9"
    sha256 arm64_big_sur:  "7699a26d303482d94f1220dac0c18dc6a6f3045975eaa048e70c5e5d0329ab1a"
    sha256 sonoma:         "5a14b6abb50fa7a0ff1047b0612aab2e9728710de6e2f1ade195cfc1be74ed50"
    sha256 ventura:        "93871a2ca6f312ef311195182fd54982f2a6edf47fd0fa6cb0335bde7207c7d8"
    sha256 monterey:       "b6d654d94f1d3474a0d587781ee543faa77163cd25f9886b2402bfb6d0feb7f5"
    sha256 big_sur:        "6701d695e81094b3bb188449b0c7df3bc8e9e845dccdb301b3b92d7bfa8c06be"
    sha256 x86_64_linux:   "905d89efbaa1db34f900fee2532f48cca5c42d33375f0a837462033412e4a947"
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
    url "https://github.com/GenericMappingTools/dcw-gmt/releases/download/2.1.2/dcw-gmt-2.1.2.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-2.1.2.tar.gz"
    sha256 "4bb840d075c8ba3e14aeb41cf17c24236bff787566314f9ff758ab9977745d99"
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
