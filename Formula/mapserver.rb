class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.6.4.tar.gz"
  sha256 "b46c884bc42bd49873806a05325872e4418fc34e97824d4e13d398e86ea474ac"
  license "MIT"
  revision 8

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "9e87d21f7740fa2c763fc2fc1580a2d22a007877ad24d4bbf9a49c8ffd9f1acc"
    sha256 cellar: :any,                 arm64_big_sur:  "2ade93a5efb8ef270ae64fc32152c752b76d5ab5c54b97043bc65242f415d78f"
    sha256 cellar: :any,                 monterey:       "24f5913cf017a1c57f71b1e5c4b3bef97b6256d7f39f32913b09699e8dd776ca"
    sha256 cellar: :any,                 big_sur:        "16182606b2a9f065cbdcb395c9a7194352aa6362bd6067ff41b9d521034ac840"
    sha256 cellar: :any,                 catalina:       "0af6a264195a8c9a015236ef4ad923e59370e28980db7600c7bff878595be889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c2051a37d20bf3b10d531ef8cae2f4a0261a6e1204d31ac0d9d3fd56d62a2f"
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
  depends_on "python@3.10"

  uses_from_macos "curl"

  fails_with gcc: "5"

  def python3
    "python3.10"
  end

  def install
    # Install within our sandbox
    inreplace "mapscript/python/CMakeLists.txt", "${PYTHON_LIBRARIES}", "-Wl,-undefined,dynamic_lookup" if OS.mac?

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
