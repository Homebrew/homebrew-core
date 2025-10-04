class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.4.1.tar.gz"
  sha256 "fe60bfdbab69437b5f97bb4ca41f2407e245c90edc2a727bf1d4428edb4a240f"
  license "MIT"

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b7ca5bcfd2e30732546a2e506b64f36932ca2130b4a3b1d506f95edfe1954ee"
    sha256 cellar: :any,                 arm64_sequoia: "fc2012d15b00099977a55ccd034ece8c5d0085845e74276e62a667e210ec152a"
    sha256 cellar: :any,                 arm64_sonoma:  "bc2601c719893173a15793208975a9d52d33da45ea7c41a8a303514f12a356b6"
    sha256 cellar: :any,                 sonoma:        "d35b2c710f7215962ba34e8340e389c5f2c15c5b1175402d3d80b9369b2b54b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "493bfdd9957029b996e411c7f53281cb91344c051d262155fbe09e602064f25e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1fbade0e1206e527b84189e162ca03d535268c413a423711eccc39c3b5d222bd"
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
  depends_on "python@3.13"

  uses_from_macos "curl"

  def python3
    "python3.13"
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
