class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.6.6.tar.gz"
  sha256 "e908e76b65541042042e9c5e4ae16a131f064cf6d3c76e9542c89b25158968c9"
  license "MIT"

  livecheck do
    url "https://download.osgeo.org/mapserver/"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "852837fcb088138dd062db80b1a77d6a62e60b74e94c249fde8c508626720046"
    sha256 cellar: :any, arm64_tahoe:       "cfa3f2bca5cdf532a8ce65f9281d38336ba105c70a352bdd5972a6eaa8736db3"
    sha256 cellar: :any, arm64_sequoia:     "80545335296608f2291dad55f1963a3b5d4dd1793156feb4fd045caf361c9a45"
    sha256 cellar: :any, arm64_sonoma:      "6096618b999a648f6fe3c2b480818854729016a3e83497251fa4ede7079721a4"
    sha256 cellar: :any, arm64_linux:       "092a6c679dfdc3a4c025d9ea13316f9c891cd3a53495556467634a24b8eb9ac3"
    sha256 cellar: :any, x86_64_linux:      "05279e34eb9514ba580fb2375e954dd975fe9ba962dc273b88649e80b24c603a"
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
                    "-DPython_EXECUTABLE=#{python3}",
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
