class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.4.4.tar.gz"
  sha256 "61385746b4a7755d60efe9bb61e41eee90c9103f6fa4fbbc02d1f993ddba17d8"

  bottle do
    cellar :any
    sha256 "85dea0b3a776407c45b2b62e1d109a56805f29d74ac712f10460599df6e4d8f1" => :catalina
    sha256 "b325e063357bd45611f5214e93ffbc3a6bbdcd58c926fa6675659b5174c2ec82" => :mojave
    sha256 "d0fd9a7514065bfa3f4561d159d494f5c68f448bb107f5ea24126514e22bc5b3" => :high_sierra
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
  depends_on "python"

  uses_from_macos "curl"

  def install
    ENV.cxx11

    python_executable = Utils.popen_read("python3 -c 'import sys;print(sys.executable)'").chomp
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
    args << "-DPYTHON_EXECUTABLE=#{python_executable}"
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
        system "python3", *Language::Python.setup_install_args(prefix)
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system "python3", "-c", "import mapscript"
  end
end
