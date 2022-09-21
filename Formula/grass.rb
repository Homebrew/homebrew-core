class Grass < Formula
  include Language::Python::Virtualenv

  desc "Free and open source Geographic Information System (GIS)"
  homepage "https://grass.osgeo.org"
  url "https://github.com/OSGeo/grass/archive/refs/tags/8.2.0.tar.gz"
  sha256 "621c3304a563be19c0220ae28f931a5e9ba74a53218c5556cd3f7fbfcca33a80"
  license "GPL-2.0-or-later"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gcc" => :build
  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "ffmpeg"
  depends_on "fftw"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "geos"
  depends_on "bzip2"
  depends_on "lbzip2"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "mesa"
  depends_on "mesalib-glw"
  depends_on "mysql"
  depends_on "netcdf"
  depends_on "numpy"
  depends_on "openblas"
  depends_on "pdal"
  depends_on "pillow"
  depends_on "postgresql@14"
  depends_on "proj"
  depends_on "python@3.10"
  depends_on "r"
  depends_on "readline"
  depends_on "six"
  depends_on "unixodbc"
  depends_on "wxpython"
  depends_on "wxwidgets"
  depends_on :xcode
  depends_on "zstd"
  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-matplotlib" do
    url "https://files.pythonhosted.org/packages/02/81/e8276ec6ca005b3b2bfaaad0ea47dbb3a0e389ec8ab87d08e3ccbe4b2742/matplotlib-3.5.3.tar.gz"
    sha256 "339cac48b80ddbc8bfd05daae0a3a73414651a8596904c2a881cfd1edb65f26c"
  end

  resource "python-ply" do
    url "https://files.pythonhosted.org/packages/e5/69/882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4da/ply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "python-termcolor" do
    url "https://files.pythonhosted.org/packages/b8/99/18ae745be732ad1cdb0cab8b63848fe6f3ba813e1324c6a689182e527083/termcolor2-0.0.3.tar.gz"
    sha256 "63ad2eaf1801c919cbeca60a62c099b330338740c8cc4422717b236f3c8f98a7"
  end

  def install
    flags = [
      "--with-cxx",
      "--enable-shared",
      "--enable-largefile",
      "--with-nls",
      "--with-includes=#{HOMEBREW_PREFIX}/include",
      "--with-libs=#{HOMEBREW_PREFIX}/LIB",
      "--with-tcltk",
      "--with-netcdf=#{Formula["netcdf"].opt_bin}/nc-config",
      "--with-zstd",
      "--with-zstd-includes=#{Formula["zstd"].opt_include}",
      "--with-zstd-libs=#{Formula["zstd"].opt_lib}",
      "--with-readline",
      "--with-readline-includes=#{Formula["readline"].opt_include}",
      "--with-readline-libs=#{Formula["readline"].opt_lib}",
      "--with-blas",
      "--with-blas-includes=#{Formula["openblas"].opt_include}",
      "--with-blas-libs=#{Formula["openblas"].opt_lib}",
      "--with-geos=#{Formula["geos"].opt_bin}/geos-config",
      "--with-geos-includes=#{Formula["geos"].opt_include}",
      "--with-geos-libs=#{Formula["geos"].opt_lib}",
      "--with-odbc",
      "--with-odbc-includes=#{Formula["unixodbc"].opt_include}",
      "--with-odbc-libs=#{Formula["unixodbc"].opt_lib}",
      "--with-gdal=#{Formula["gdal"].opt_bin}/gdal-config",
      "--with-zlib-includes=#{Formula["zlib"].opt_include}",
      "--with-zlib-libs=#{Formula["zlib"].opt_lib}",
      "--with-bzlib",
      "--with-bzlib-includes=#{Formula["bzip2"].opt_include}",
      "--with-bzlib-libs=#{Formula["bzip2"].opt_lib}",
      "--with-cairo",
      "--with-cairo-includes=#{Formula["cairo"].opt_include}/cairo",
      "--with-cairo-libs=#{Formula["cairo"].opt_lib}",
      "--with-cairo-ldflags=-lfontconfig",
      "--with-freetype",
      "--with-freetype-includes=#{Formula["freetype"].opt_include}/freetype2",
      "--with-freetype-libs=#{Formula["freetype"].opt_lib}",
      "--with-proj-includes=#{Formula["proj"].opt_include}",
      "--with-proj-libs=#{Formula["proj"].opt_lib}",
      "--with-proj-share=#{Formula["proj"].opt_share}/proj",
      "--with-tiff",
      "--with-pdal=#{Formula["pdal"].opt_bin}/pdal-config",
      "--with-tiff-includes=#{Formula["libtiff"].opt_include}",
      "--with-tiff-libs=#{Formula["libtiff"].opt_lib}",
      "--with-png",
      "--with-png-includes=#{Formula["libpng"].opt_include}",
      "--with-png-libs=#{Formula["libpng"].opt_lib}",
      "--with-regex",
      "--with-fftw",
      "--with-fftw-includes=#{Formula["fftw"].opt_include}",
      "--with-fftw-libs=#{Formula["fftw"].opt_lib}",
      "--with-sqlite",
      "--with-sqlite-includes=#{Formula["sqlite"].opt_include}",
      "--with-sqlite-libs=#{Formula["sqlite"].opt_lib}",
      "--with-mysql",
      "--with-mysql-includes=#{Formula["mysql"].opt_include}/mysql",
      "--with-mysql-libs=#{Formula["mysql"].opt_lib}",
      "--with-postgres",
      "--with-postgres-includes=#{Formula["postgresql"].opt_include}",
      "--with-postgres-libs=#{Formula["postgresql"].opt_lib}",
      "--with-opengl=macosx",
      "--with-opencl",
      "--with-openmp",
      "--with-openmp-includes=#{Formula["gcc"].opt_include}",
      "--with-openmp-libs=#{Formula["gcc"].opt_lib}/gcc/current",
      "--enable-macosx-app",
    ]

    flags << "--with-pthread"
    flags << "--with-pthread-includes=#{Formula["boost"].opt_include}/boost/thread"
    flags << "--with-pthread-libs=#{Formula["boost"].opt_lib}"

    sdk_frameworkspath = "#{MacOS.sdk_path}/System/Library/Frameworks"

    flags << "--with-macosx-sdk=#{MacOS.sdk_path}"
    flags << "--with-opengl-includes=#{sdk_frameworkspath}/OpenGL.framework/Headers"
    flags << "--with-opengl-framework=#{sdk_frameworkspath}/OpenGL.framework"
    flags << "--with-opencl-includes=#{sdk_frameworkspath}/OpenCL.framework/Versions/Current/Headers"
    flags << "--with-opencl-libs=#{sdk_frameworkspath}/OpenCL.framework/Versions/Current/Headers"

    system "./configure", "--prefix=#{prefix}", *flags
    inreplace "macosx/Makefile", "/Library", "~/Library"
    system "make"
    system "make", "install"
  end

  test do
    grass_bin = "#{prefix}/GRASS-#{version.major_minor}.app/Contents/MacOS/GRASS"
    system grass_bin, "--version"
    system grass_bin, "-c", "epsg:4326", "grass_testdir", "-e"
    assert_predicate testpath/"grass_testdir", :exist?
  end
end
