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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e9a959c5c3a3f37231d3e50b7af727ff8798f8cdc83993083bf25bb8cf6a9c5e"
    sha256 cellar: :any, arm64_tahoe:       "6815caf44be786a387bdb9864b6a6cbaaaf706f781dca741eca2066684fb4034"
    sha256 cellar: :any, arm64_sequoia:     "7bb5abe3e6116cfa29011c6d80a9560a7e7da27008df7e0c523b887688ff6ddd"
    sha256 cellar: :any, arm64_linux:       "cf50ac9856f3527b4d8f27851359a6a0d0706529a9dcd9dda0a16f3937680bd6"
    sha256 cellar: :any, x86_64_linux:      "c23ffdd6e6adf4bba5d8e25f83782e6d6c947bfcb653820e1cc0905481cef657"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python-setuptools" => :build
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
  depends_on "python@3.15"

  uses_from_macos "curl"

  deny_network_access!

  def install
    if OS.mac?
      mapscript_rpath = rpath(source: prefix/Language::Python.site_packages(python3)/"mapscript")
      # Install within our sandbox and add missing RPATH due to _mapscript.so not using CMake install()
      inreplace "src/mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}",
                                                       "-Wl,-undefined,dynamic_lookup,-rpath,#{mapscript_rpath}"
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DWITH_CLIENT_WFS=ON
      -DWITH_CLIENT_WMS=ON
      -DWITH_CURL=ON
      -DWITH_FCGI=ON
      -DWITH_FRIBIDI=OFF
      -DWITH_GDAL=ON
      -DWITH_GEOS=ON
      -DWITH_HARFBUZZ=OFF
      -DWITH_KML=ON
      -DWITH_OGR=ON
      -DWITH_POSTGIS=ON
      -DWITH_PYTHON=ON
      -DWITH_SOS=ON
      -DWITH_WFS=ON
      -DPython_EXECUTABLE=#{python3}
      -DPHP_EXTENSION_DIR=#{lib}/php/extensions
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args, "./build/src/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end
