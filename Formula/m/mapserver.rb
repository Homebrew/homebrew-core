class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.6.2.tar.gz"
  sha256 "e10d71c3ced22b8b0858a98434d55a532f4359d193a32e4b353411814976ca22"
  license "MIT"
  revision 1

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "47271761c91be89673f8aa280edc8bca18feee166d637d0b11943ec432f85fba"
    sha256 cellar: :any,                 arm64_sequoia: "4450d025940859a501f6eae8bde57d9e4cf29ee104020529298b203ea20e5b2c"
    sha256 cellar: :any,                 arm64_sonoma:  "ba893b80535ea5d1fe146786610ab95cc1ec9c531c1882cfd67c5b95818e9b05"
    sha256 cellar: :any,                 sonoma:        "989eb06424e04c3ff0cfb76e1db029c8b548ddd229adf0548bff724a0a242678"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03454e598571e847a51622bb0cff2aff1422b073036ddf5232715133a44b3ef4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4410c2ef44460499e2b9de899eb19ffad7576a81ee484a906aa838ce55d50b97"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "pcre2"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.14"

  uses_from_macos "curl"

  def python3
    "python3.14"
  end

  def install
    if OS.mac?
      mapscript_rpath = rpath(source: prefix/Language::Python.site_packages(python3)/"mapscript")
      # Install within our sandbox and add missing RPATH due to _mapscript.so not using CMake install()
      inreplace "src/mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}",
                                                       "-Wl,-undefined,dynamic_lookup,-rpath,#{mapscript_rpath}"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DWITH_CLIENT_WFS=ON",
                    "-DWITH_CLIENT_WMS=ON",
                    "-DWITH_CURL=ON",
                    "-DWITH_FCGI=ON",
                    "-DWITH_FRIBIDI=OFF",
                    "-DWITH_GDAL=ON",
                    "-DWITH_GEOS=ON",
                    "-DWITH_HARFBUZZ=OFF",
                    "-DWITH_KML=ON",
                    "-DWITH_OGR=ON",
                    "-DWITH_POSTGIS=ON",
                    "-DWITH_PYTHON=ON",
                    "-DWITH_SOS=ON",
                    "-DWITH_WFS=ON",
                    "-DPython_EXECUTABLE=#{which(python3)}",
                    "-DPHP_EXTENSION_DIR=#{lib}/php/extensions",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./build/src/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end
