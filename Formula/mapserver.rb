class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.6.4.tar.gz"
  sha256 "b46c884bc42bd49873806a05325872e4418fc34e97824d4e13d398e86ea474ac"
  license "MIT"
  revision 5

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "477c3b98cef266210bfa9595d324ed0da0cef4be754888ec5d1da11cc5d3d77a"
    sha256 cellar: :any,                 arm64_big_sur:  "15d25c55cb6a0d8db29a293c523fa7c56b2b274d24413682993b1915fe508e06"
    sha256 cellar: :any,                 monterey:       "807575f997e470030d0f05eee9fded42afc59fde2edbea28e30a41405cbfe713"
    sha256 cellar: :any,                 big_sur:        "dff219470b797278023f5d68231db74d08b1a3c04d0dab0c77d47a51b7bab382"
    sha256 cellar: :any,                 catalina:       "e08713491a56f62f3b5ec16103c55b41b860a84fc13a87f9af70539e7cd58cda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6211abb6f2950be9ac4e5cae4910e65612773968bd0abb3a042eac9d2827de4"
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
  depends_on "postgresql"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.9"

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    args = %W[
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
      -DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin/"python3"}
      -DPHP_EXTENSION_DIR=#{lib}/php/extensions
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    # Install within our sandbox
    inreplace "mapscript/python/CMakeLists.txt" do |s|
      s.gsub! "${PYTHON_LIBRARIES}", "-Wl,-undefined,dynamic_lookup"
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd "build/mapscript/python" do
      system Formula["python@3.9"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import mapscript"
  end
end
