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
    sha256 cellar: :any,                 arm64_monterey: "7e62c905331c71a62ec7cfa886e86aa49f59313a4347ada4b4fd8f99f07129f3"
    sha256 cellar: :any,                 arm64_big_sur:  "6fe918f74417fe3d6290472c20d6d3fea2d15fd22ecb881db07bb65b6e362f28"
    sha256 cellar: :any,                 monterey:       "957dc74d6938859b25e88d557db1431b8da4fe1a3aa9bb53295d2226aac3aeb0"
    sha256 cellar: :any,                 big_sur:        "f6ebf38e5f1741223655e4eb57e50d79d779f28ed6c87aed5d9f707eb3e7348a"
    sha256 cellar: :any,                 catalina:       "b2c70beabc7fffe4b00cfdb7ede9ca389494117cbf4f6af85035f450dae3b47c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9a93450d6f376354f9c5770b8469f5db94612bc666a9edaca1e793a4c14fdd"
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
