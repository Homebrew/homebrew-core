class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.0.tar.gz"
  sha256 "bb7ee625eb6fdce9bd9851f83664442845d70d041e449449e88ac855e97d773c"
  license "MIT"
  revision 3

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6bce3a8b5a5bb07774845081ded898fe2bc3626088d219c20cc5fa78f8fa1506"
    sha256 cellar: :any,                 arm64_monterey: "78792e09dcec2c5dbc707212c76e7c11c67baf53937919eaa141a5687b957de7"
    sha256 cellar: :any,                 arm64_big_sur:  "ef3487ecad8109645c7c2f30107bc6ac5f8a84d4442a44a0573f46a20264a579"
    sha256 cellar: :any,                 ventura:        "0143de265647f28ba0cc9cc3815551c67d02ea6cd4ad97e6eff93b2d5d01929e"
    sha256 cellar: :any,                 monterey:       "740ff5746c5bf1e1e7bebe6784fa3cf41f3bf954893920445ff9882fb1d29e8f"
    sha256 cellar: :any,                 big_sur:        "90c669608c7c5cbe5de953d6cfb3619eee4b4f659ba08474df527c872669ac2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2f5154b833f6f8b4dfee59d015e39d278d627e72c81c63ee93cc290300e1fbb"
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
