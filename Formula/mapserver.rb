class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.6.0.tar.gz"
  sha256 "12380737ce71d78520ddaad90d1562a7e321436ad78d463923999030a03b4bda"
  revision 2

  bottle do
    cellar :any
    sha256 "f8321382afcf6b0549a3df0dfc3960e40f698a616f1b4a489b8fbd14f7209f8b" => :catalina
    sha256 "7c18f9bd6ef105f345754afb642be0f0a8256fa7debfade157ba5e17869dd0ad" => :mojave
    sha256 "eeb3f79a8c4a8deddeb6b3b2996c871cbbfaa33f9ed38c0fdec82f58fecf27b6" => :high_sierra
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
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.8"

  uses_from_macos "curl"

  def install
    ENV.cxx11

    args = std_cmake_args + %w[
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
    ]
    args << "-DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin/"python3"}"
    args << "-DPHP_EXTENSION_DIR=#{lib}/php/extensions"

    # Install within our sandbox
    inreplace "mapscript/python/CMakeLists.txt" do |s|
      s.gsub! "${PYTHON_LIBRARIES}", "-Wl,-undefined,dynamic_lookup"
    end

    # Using rpath on python module seems to cause problems if you attempt to
    # import it with an interpreter it wasn't built against.
    # 2): Library not loaded: @rpath/libmapserver.1.dylib
    args << "-DCMAKE_SKIP_RPATH=ON"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      cd "mapscript/python" do
        system Formula["python@3.8"].opt_bin/"python3", *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system Formula["python@3.8"].opt_bin/"python3", "-c", "import mapscript"
  end
end
