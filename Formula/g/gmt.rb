class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.5.0/gmt-6.5.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.5.0-src.tar.xz"
  sha256 "4022adb44033f9c1d5a4d275b69506449e4d486efe2218313f3ff7a6c6c3141e"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  bottle do
    sha256 arm64_sonoma:   "e3b1717337b57a9e65a5d4bcfa618773e3ce884bc9bf2a8829be8bc765820b95"
    sha256 arm64_ventura:  "ecd0d44325856b3212e60c51bd061935594ea5d5079958037e744bccad306be8"
    sha256 arm64_monterey: "aeb5ba6d661148c53e235fdabb8ae740d46843ed87d95134ad2f725d29e9c617"
    sha256 sonoma:         "be0b2a8dbf84a6158f0380081d08e648868c1253117b1010b431402cdf4813f1"
    sha256 ventura:        "5cc67841a0f2665219c20d100fe50520f30d5959d338c34ec4c6ecb89755c0ff"
    sha256 monterey:       "7e800eb22861b0be50a3630eeb5f24354467fe6e05aafc373bf71d079b3a94a3"
    sha256 x86_64_linux:   "99009476dd6ef2a4adb7df593e3ee833f41627f7da646536c3b6207b903a351f"
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
