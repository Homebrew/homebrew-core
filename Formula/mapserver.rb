class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.6.4.tar.gz"
  sha256 "b46c884bc42bd49873806a05325872e4418fc34e97824d4e13d398e86ea474ac"
  license "MIT"

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "0f54be3a484bb73ca70be85054ec0a7dab004bec30a9f60b8f12eb2f0181f1a8"
    sha256 cellar: :any, big_sur:       "613314de0ebaeb0df201178f4ee23d36fea4f9302a5ca20d875b356004220cd9"
    sha256 cellar: :any, catalina:      "3f434172773dc3312a3787f5018e7a61849534f036082c45ad285dd2a8f4280d"
    sha256 cellar: :any, mojave:        "aa2236e1cc9e14a965996188bc9c1988f6327266ef62891a70c8f0f6588c38a1"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig@3" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "libpng"
  depends_on "postgresql"
  depends_on "proj@7"
  depends_on "protobuf-c"
  depends_on "python@3.9"

  uses_from_macos "curl"

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
