class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.1.tar.gz"
  sha256 "79d23595ef95d61d3d728ae5e60850a3dbfbf58a46953b4fdc8e6e0ffe5748ba"
  license "MIT"
  revision 2

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1ea0b64821453aa8431b3b8488663f08bedf2d216b66ee17cc784721b4110c5a"
    sha256 cellar: :any,                 arm64_monterey: "a70983d3e45e9b7717624167cf7e6cc235447d26f6487e63ed2b8855470b542f"
    sha256 cellar: :any,                 arm64_big_sur:  "b55b97d423a11764784be35ad6cfe9b3707f0f4f695713ca925a645c610a42cf"
    sha256 cellar: :any,                 ventura:        "7eb6a1821e4b21e717bf7d56e8097ac1922122aa43d28523975f92662c16a94b"
    sha256 cellar: :any,                 monterey:       "d206a228175d305685bc2c99d2312018ef89768f3836d84620ac048046b002c3"
    sha256 cellar: :any,                 big_sur:        "a15e31ce5029b7366adc1cf0d8745a272a990098e0da70e178f6a97930321b02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "159647fd054a0ce79750c9ba873ebc4f61c79d16310dd945d3aa0c696a53b66b"
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

    system python3, "-m", "pip", "install", *std_pip_args, "./build/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end
