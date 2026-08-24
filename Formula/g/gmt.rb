class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/archive/refs/tags/6.7.0.tar.gz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.7.0-src.tar.xz"
  sha256 "1a0c2ce2d1d8d19eecbff806876c37f986f442435031da56ea57d31de6579126"
  license "LGPL-3.0-or-later"
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "8426d92d217b614cb0fd5066c486fc93191fb2cf675bd038e001c040a9284f54"
    sha256 arm64_sequoia: "3e935e5a493a00f309aecbea1fd3f3221350b29dfb254be5f96d76c87838bae6"
    sha256 arm64_sonoma:  "3e3e036dd4c5240ae42368fd3e7f9cc6dd15ddbd2224e4be586558185636e5e0"
    sha256 sonoma:        "28fab84c6fab03639ae90774f12b054daa953570d3422dd929853238c5bcbade"
    sha256 arm64_linux:   "5584f987ee3454a4579c697642e7246bb8c1a2e529f2b62dab59f22c1a493311"
    sha256 x86_64_linux:  "52d1c66b978f82152ebf68fc61d692f50ef7d16dd7779f0d0eb6d2f92f5044dc"
  end

  depends_on "cmake" => :build

  depends_on "fftw"
  depends_on "gdal"
  depends_on "geos"
  depends_on "netcdf"
  depends_on "openblas"
  depends_on "pcre2"

  uses_from_macos "curl"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
      -DFFTW3_ROOT=#{formula_opt_prefix("fftw")}
      -DGDAL_ROOT=#{formula_opt_prefix("gdal")}
      -DNETCDF_ROOT=#{formula_opt_prefix("netcdf")}
      -DPCRE2_ROOT=#{formula_opt_prefix("pcre2")}
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
