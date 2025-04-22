class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  license "LGPL-3.0-or-later"
  revision 4
  head "https://github.com/GenericMappingTools/gmt.git", branch: "master"

  stable do
    url "https://github.com/GenericMappingTools/gmt/releases/download/6.5.0/gmt-6.5.0-src.tar.xz"
    mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.5.0-src.tar.xz"
    sha256 "4022adb44033f9c1d5a4d275b69506449e4d486efe2218313f3ff7a6c6c3141e"

    # Backport update to minimum CMake version
    # https://github.com/GenericMappingTools/gmt/commit/e8d68a575c0427f66b82f28a63ba87cdbd91aca7
    patch :DATA
  end

  bottle do
    sha256 arm64_sequoia: "1b462c2bcbc6e95ce082b68729b36d2b8949045918256d7031c49908e1a7c75f"
    sha256 arm64_sonoma:  "1d3a2dafaff73abfd68a892b3ca938682e4e4dfbdc80084d47541cdb7207f122"
    sha256 arm64_ventura: "3c6954e97839d63256dcb0247a83a9dbe2521a7860e1a32c7bff7418a917872a"
    sha256 sonoma:        "83fcc1c4401e4c9577a1b776fca7bec6fd22835bc5d41e4190d18872b9961bfe"
    sha256 ventura:       "adcb429977f1fcc83e2296cd1d2aea653c718025114e99fde2108848b844fd64"
    sha256 arm64_linux:   "d8d9ae98c3def5ba170544c7197b90c199447dabd2002f1010f9a43e1dd9b39d"
    sha256 x86_64_linux:  "780e03a2e26081390f07a272817bc4bad9a398ad0ee982734144ac81569e9574"
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
