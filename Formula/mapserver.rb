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
    sha256 cellar: :any,                 arm64_ventura:  "f6104fd098b5307f3eb005a4fcb3d5cc83c271f4be588a3d1437e0d5c38a41ab"
    sha256 cellar: :any,                 arm64_monterey: "97d63ac9754039e01d51f7c3ad3f659e8a21073960a7f15ebfc66f0d3b4831ac"
    sha256 cellar: :any,                 arm64_big_sur:  "2b344844f9df2e1c15de078bb8b889a3f2eae19015e6534b058edf4b8da7ee85"
    sha256 cellar: :any,                 ventura:        "7104925b01bee5de53062cdf99d31c5e5c720e470617ee4df33107327229b0b7"
    sha256 cellar: :any,                 monterey:       "e2dec2c31410cb2a045c04480d25f5c856db224458c022180f0e484fded5930a"
    sha256 cellar: :any,                 big_sur:        "43dee33cdd1eb3adf11c817797da83ed6deb1993ba16e942705270a016b6aa28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aeab637ff05fd86e8ead6d8a5cd1808befec5f1fe147174c6a7ba821392beb45"
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
