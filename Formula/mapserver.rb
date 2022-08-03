class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.6.4.tar.gz"
  sha256 "b46c884bc42bd49873806a05325872e4418fc34e97824d4e13d398e86ea474ac"
  license "MIT"
  revision 7

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "110c0ee36bc2f8aa8dbedbf496c6b0479e200a937eff1277fc2d61165aedb8ba"
    sha256 cellar: :any,                 arm64_big_sur:  "aeed2ddce2459af490f7bc7abf5fddecdf566b2dbd4b7071f89251f3b476bbbf"
    sha256 cellar: :any,                 monterey:       "883510d93bab9fcd44ff7e751ce1bbf9f112214eca7d7a1f1775efcd6ba43cc8"
    sha256 cellar: :any,                 big_sur:        "7c0c1751f2634e29ba80fce45a7198c4c4cd5c037bbba8a335ede5ac422304b9"
    sha256 cellar: :any,                 catalina:       "8f41cce9065210b616287149cda22a8dd6114301425c3edfd7c506f22194b0f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "742e3c71d41d9b4b82a0107dac3655bc895e9410484259be9f6c973efb71184e"
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
  depends_on "python@3.9"

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    python = which("python3.9")

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
                    "-DPYTHON_EXECUTABLE=#{python}",
                    "-DPHP_EXTENSION_DIR=#{lib}/php/extensions"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    cd "build/mapscript/python" do
      system python, *Language::Python.setup_install_args(prefix, python)
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system "python3.9", "-c", "import mapscript"
  end
end
