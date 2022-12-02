class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.0.tar.gz"
  sha256 "bb7ee625eb6fdce9bd9851f83664442845d70d041e449449e88ac855e97d773c"
  license "MIT"
  revision 2

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "bd051875a34c400c2d1492f02f1e523492f8afe5509e969516aadbf2561ebae5"
    sha256 cellar: :any,                 arm64_monterey: "3adf61a1e151096fc0b17c24eb42ef124c46e26e7d27a2c797b74c14267eccb6"
    sha256 cellar: :any,                 arm64_big_sur:  "96ce7713be52a3a374d6bd6deeff00e298b8940f0afc30bff1558e436dd85a18"
    sha256 cellar: :any,                 ventura:        "a83b90215c5df6edd4d92b742eb556f11f5bbe111259c4a3f2c67d141183f800"
    sha256 cellar: :any,                 monterey:       "8c8c5f8d2f3f186f6bbc6377f80f649c00b6596f2031c0b92abb530aedd5011a"
    sha256 cellar: :any,                 big_sur:        "4d4e9fb039c5bab0a06facb9831c3bba35fbf89d8820ac71da2e84fadb2e9920"
    sha256 cellar: :any,                 catalina:       "1255ef28197145dc8ff7f04f85f8a8d60a7818c6e8de7d9bea3416a8b28d74cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09372b682af248e682c337f8f927e3c00d0ac921eab1b3fdbd733bc23d51bbf0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.11"

  uses_from_macos "curl"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    # Install within our sandbox
    inreplace "mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}", "-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
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
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPHP_EXTENSION_DIR=#{lib}/php/extensions"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd "build/mapscript/python" do
      system python3, *Language::Python.setup_install_args(prefix, python3)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end
