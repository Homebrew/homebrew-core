class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.4.1.tar.gz"
  sha256 "fe60bfdbab69437b5f97bb4ca41f2407e245c90edc2a727bf1d4428edb4a240f"
  license "MIT"
  revision 2

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f37883024eee9db38c8861defb0c618e830400ee738527bf95a31183f7e6d6d9"
    sha256 cellar: :any,                 arm64_sequoia: "427fc8bd638c9eb0fa81fba883f02b7c503f876ecc63b2e90d313112eb83f703"
    sha256 cellar: :any,                 arm64_sonoma:  "4b31ed952e3fdd4418d1a180ac6f89a659bf75e99f242e8cf6b8b84ccdc23114"
    sha256 cellar: :any,                 sonoma:        "c11c8bb01516e066a0715f0cd7ae39cebd9725adbfd7317df5987217b44fa320"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4723bfe1da2ead2b6f5c8ac89848eab194e01988e735ea94b809b6aff394c45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8153e6505b354c2b397607378e73d34ba94639ad0011cf6ae03bf2f5a01c9c96"
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
