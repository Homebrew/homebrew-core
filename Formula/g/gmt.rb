class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.6.0/gmt-6.6.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.6.0-src.tar.xz"
  sha256 "18ac98b11b8fc924463ce5138385c02e9426780fba9ff63a991e2e8ecdbd1082"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "4973062a7cc8be77b13b447f18d4a144383fa108c8767c5242fcc7793fd0ea62"
    sha256 arm64_sequoia: "141a5484e250b3fd7abb38eb056d0f3825b8a108c9f80e7ed3ab2a2bfbb9e88f"
    sha256 arm64_sonoma:  "b94932ff613d2b16e61075f8161c1ff713b07de3913a543790b73e76ae9ca7ed"
    sha256 sonoma:        "8d1ba4ecdf6a22f23505de0057bc7494401e8cd5788877010849f3d5a8eadc2d"
    sha256 arm64_linux:   "4bd317b770e13de964ce17cd535bebf7695386374fa943668d81d8b19ed64596"
    sha256 x86_64_linux:  "2c1bef8d1f9457ce7970ddd802dcb2c22cac1f9bfd2f4d3cfc363fbebd02f0eb"
  end

  depends_on "cmake" => :build

  depends_on "fftw"
  depends_on "gdal"
  depends_on "geos"
  depends_on "netcdf"
  depends_on "openblas"
  depends_on "pcre2"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "gshhg" do
    url "https://github.com/GenericMappingTools/gshhg-gmt/releases/download/2.3.7/gshhg-gmt-2.3.7.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gshhg-gmt-2.3.7.tar.gz"
    sha256 "9bb1a956fca0718c083bef842e625797535a00ce81f175df08b042c2a92cfe7f"
  end

  resource "dcw" do
    url "https://github.com/GenericMappingTools/dcw-gmt/releases/download/2.2.0/dcw-gmt-2.2.0.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-2.2.0.tar.gz"
    sha256 "f2a8a7b7365bdd17269aa1d412966a871528eefa9b2a7409815832a702ff7dcb"
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
    cmd = "#{bin}/gmt pscoast -R0/360/-70/70 -Jm1.2e-2i -Ba60f30/a30f15 -Dc -G240 -W1/0 -P"
    refute_predicate shell_output(cmd), :empty?
  end
end
