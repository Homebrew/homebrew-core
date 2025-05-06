class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.4.0.tar.gz"
  sha256 "b0cb3612cd58458cca0808b117c16b9415b3231af39aefb90d668e8b8b188e2c"
  license "MIT"

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "17ae78f050b686530e75191c084c97d10f257f7b19aa5dbe23ac4b363dbd499b"
    sha256 cellar: :any,                 arm64_sonoma:  "8db1bacf84e2327a213e4e0575d7c4a6f8be0a3d236f974fb8d7b60e974d9fd7"
    sha256 cellar: :any,                 arm64_ventura: "61a16800e4037aa30a8ab477329e739f1b7d06e36b224a6eb1786a9ea478f8f0"
    sha256 cellar: :any,                 sonoma:        "ef2895e59bad997d703c1c3707cb709d42a9a4db0d7f737bcef30c5dc4e8af0f"
    sha256 cellar: :any,                 ventura:       "3ddfa1f0e0a1b9fa7fb55a3854f1d389c18df99197fe2e3cfb533e6460ac055d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "44fb64650323c936b893fdde8ab649ac2a35ad59cc440fbdb59baf01de6f9422"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80b59633359597d6eaf50f3471fa8858056122b2eba2b9e17a8ac2320851d763"
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
