class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.6.0/gmt-6.6.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.6.0-src.tar.xz"
  sha256 "18ac98b11b8fc924463ce5138385c02e9426780fba9ff63a991e2e8ecdbd1082"
  license "LGPL-3.0-or-later"
  revision 2
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 arm64_tahoe:   "0b8146614b014a2b1fa9545e81e25526117f4283bdd0c1fcf9617ab155bdb2fc"
    sha256 arm64_sequoia: "60fcbcd6fc98937a5dc68bcc6d944eef355668c82a36c5791433493183f9fa52"
    sha256 arm64_sonoma:  "33e7eabb17005fbbb8bcb37c3c6b3253a7001abd115f585152ea62ebeadf8c4d"
    sha256 sonoma:        "bddcd00c06947e457e68ac2a342960481bb7aa6cf4f9094c769898af96e3b5b9"
    sha256 arm64_linux:   "ac4b6389876270ac42ea5592cf8b24bbfd7688db6fc4e86880e7316aba336ce7"
    sha256 x86_64_linux:  "0ff278d952d35a5abf7c30e7d686a727d2a60ff801d531909f00a349b2430321"
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
