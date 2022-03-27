class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.6.4.tar.gz"
  sha256 "b46c884bc42bd49873806a05325872e4418fc34e97824d4e13d398e86ea474ac"
  license "MIT"
  revision 2

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "24c6f499e70f85db71413d14883f2f3494b9371dacd9fb6300893833fde7b6e6"
    sha256 cellar: :any,                 arm64_big_sur:  "0902251c20025ed6af54cfa71f08c4fb06aead399c3878134a4c4146b0ba6de0"
    sha256 cellar: :any,                 monterey:       "d1d48ca104ef81e5120a41ccbf8f8cfebc0d85e821d09f2d68977f43787b36e6"
    sha256 cellar: :any,                 big_sur:        "e0e1baf2b111c00a5f9de0c9e053baea19eb49c89e7312696d2034544a58fa95"
    sha256 cellar: :any,                 catalina:       "a781bd8ccfceda8d3f701f0d714e47862536912b917c28c64fad083a49db2419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e52b838eb14c028e2b0162d4b66fa92e56498350c4cbb96e729d74326dd765dd"
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
