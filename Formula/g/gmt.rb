class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  license "LGPL-3.0-or-later"
  revision 5
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  stable do
    url "https://github.com/GenericMappingTools/gmt/releases/download/6.5.0/gmt-6.5.0-src.tar.xz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.5.0-src.tar.xz"
    sha256 "4022adb44033f9c1d5a4d275b69506449e4d486efe2218313f3ff7a6c6c3141e"

    # Backport update to minimum CMake version
    # https://github.com/GenericMappingTools/gmt/commit/e8d68a575c0427f66b82f28a63ba87cdbd91aca7
    patch :DATA
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_sequoia: "5099eeaa5088b8f8d4e5b95f00f229c7c8d5829f38c0827ca9dc587be4085162"
    sha256 arm64_sonoma:  "92c4b8906c8e4f2c7c244190eeeaccdae01f61d4b9d76c8d3b14bfe1bd1b938a"
    sha256 arm64_ventura: "5e1dc95be0096547acc16f6342ea231b1b1d9ff64697083d4fc664c43bb24fc2"
    sha256 sonoma:        "085c08b1ed326b9f438a6293a9b9724cf7f2482cea78c237e59208e2823002d0"
    sha256 ventura:       "f990c4b48bf01ee82b0403477cf2c6955df4b3f53cd71812f7100a0b3569bbcb"
    sha256 arm64_linux:   "9a0b6ab41ce707202077a3f8f7765ff69d05290910afe718ddfa0085585d4f69"
    sha256 x86_64_linux:  "b6b304e7413353d55c129c54fccc25342a430eec8f533988270274cfebdf62e1"
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

__END__
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -46,7 +46,7 @@ if (${srcdir} STREQUAL ${bindir})
 endif (${srcdir} STREQUAL ${bindir})
 
 # Define minimum CMake version required
-cmake_minimum_required (VERSION 2.8.12)
+cmake_minimum_required (VERSION 3.16)
 message ("CMake version: ${CMAKE_VERSION}")
 
 # Use NEW behavior with newer CMake releases
