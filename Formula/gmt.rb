class Gmt < Formula
  desc "Tools for manipulating and plotting geographic and Cartesian data"
  homepage "https://www.generic-mapping-tools.org/"
  url "https://github.com/GenericMappingTools/gmt/releases/download/6.2.0/gmt-6.2.0-src.tar.xz"
  mirror "https://mirrors.ustc.edu.cn/gmt/gmt-6.2.0-src.tar.xz"
  sha256 "a01f0a14d48bbc0b14855670f366df3cb8238f0ccdfa26fe744968b4f1c14d54"
  license "LGPL-3.0-or-later"
  revision 1
  head "https://github.com/GenericMappingTools/gmt.git"

  bottle do
    sha256 arm64_big_sur: "c15fb077782eab44e3d1f83a83f9c3c5298f667f1f7abee15375ab620250ba97"
    sha256 big_sur:       "efed3cc448f128f1e6d76fca71bc143c5fb4f31fa208944046393efa1e10e992"
    sha256 catalina:      "19a9960e390ee80e9cf56ff48a808bdf0826696a44b7c023ed7cb042914d48cb"
    sha256 mojave:        "d50f231a9920f5a5930a0d00148113bb6c5ddfc72e21fc848ea05c48576467a0"
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
    url "https://github.com/GenericMappingTools/dcw-gmt/releases/download/2.0.0/dcw-gmt-2.0.0.tar.gz"
    mirror "https://mirrors.ustc.edu.cn/gmt/dcw-gmt-2.0.0.tar.gz"
    sha256 "d71d209c837a805fed0773c03fadbb26e8c90eb6b68e496ac4a1298c3246cc7a"
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
      -DPCRE_ROOT=#{Formula["pcre2"].opt_prefix}
      -DFLOCK:BOOL=TRUE
      -DGMT_INSTALL_MODULE_LINKS:BOOL=FALSE
      -DGMT_INSTALL_TRADITIONAL_FOLDERNAMES:BOOL=FALSE
      -DLICENSE_RESTRICTED:BOOL=FALSE
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
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
