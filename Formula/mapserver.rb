class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.0.tar.gz"
  sha256 "bb7ee625eb6fdce9bd9851f83664442845d70d041e449449e88ac855e97d773c"
  license "MIT"
  revision 4

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "09ef1a8000520cb6d9fe4153649f759e7abbbbeebe6bcdaea2c8cdf66a5265be"
    sha256 cellar: :any,                 arm64_monterey: "3ecfd102747839ec0be5f6bebc545defdd279dc2f6ed4f8fead0191da147e0c1"
    sha256 cellar: :any,                 arm64_big_sur:  "9b37c06c6d83486abc1234936f676d79b655c3aea1eab8e07955210b2e561a5c"
    sha256 cellar: :any,                 ventura:        "ccc0b5eafd4c3895c106897cfceb889a4cc404d5663148711aa32448a4a469a7"
    sha256 cellar: :any,                 monterey:       "95ddfb7dd186cc3c6fa829c4de61ba0cf27a8d49d603679452d8306235dc8706"
    sha256 cellar: :any,                 big_sur:        "827fbddb31b89b3213c69a594f63582a9831e630eed65454cd533edd1bc4ddc8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a3c8156667e08667d5ed71956265d7ba8ce6b6b80208c3260fd9918aa0e9618"
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
