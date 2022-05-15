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
    sha256 cellar: :any,                 arm64_monterey: "eb063e619b10833ecf47eb794e3f2d9e96f9105f9030270d79f03e7bfb302aff"
    sha256 cellar: :any,                 arm64_big_sur:  "4ff7d584fc0c64391f45e8a264e01fb77c742ca77b737c4af8f7a673eaf37d06"
    sha256 cellar: :any,                 monterey:       "c254261912cb57007202ad57480c44212ae8839583be745cda024b2966b644ce"
    sha256 cellar: :any,                 big_sur:        "ed04e8fe8f1da5d91258b8449b60e95f7be592b6d817ad662cb01b629daa5e88"
    sha256 cellar: :any,                 catalina:       "017de885523933e74cffc69391374be105af07e64099681aaef4ea4986922008"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7aa822d4049082c9aecb7100b75d985b62929e0e5a7d4ded45460ca3612dd8c3"
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
