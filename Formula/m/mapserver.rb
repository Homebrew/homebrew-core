class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.4.0.tar.gz"
  sha256 "b0cb3612cd58458cca0808b117c16b9415b3231af39aefb90d668e8b8b188e2c"
  license "MIT"
  revision 1

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a4e500674e554d55bd55eaf1e02fc5b9e92acc8186249916b7a2580c69d0252f"
    sha256 cellar: :any,                 arm64_sonoma:  "6660cb93a5203442144bf4ca85bfc3c21e6d7bf586375e3095af54d946002cc4"
    sha256 cellar: :any,                 arm64_ventura: "f90d19bd7df3901cce2cd86c0f17c5ea72f864c07461e25e3999a4aef19a51b0"
    sha256 cellar: :any,                 sonoma:        "92d448babff50b7594d87edbe7647422c2eee391385a7578d59a00f738639ebc"
    sha256 cellar: :any,                 ventura:       "2a6c194a77dd8a90c1e891709d75c3126397525853f9bfb8310473a2bbe89807"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6e54d30a20448f15b9c47aac2ce9e6e248e4831f13e9c3dada3ea5e063d7485b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8bdcab5848d320edb7eb9d8dce253e900197f37d89be4246c65b9c786945247d"
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
