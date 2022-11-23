class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.0.tar.gz"
  sha256 "bb7ee625eb6fdce9bd9851f83664442845d70d041e449449e88ac855e97d773c"
  license "MIT"
  revision 1

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "7d7c71bc119159cab044f63f50efede904260b1399930287566f2a311fd4180b"
    sha256 cellar: :any,                 arm64_monterey: "e12924466fbc2c9f7c53a1ab641c922e11a1fb48f6218cbfd113c1dd3c04059c"
    sha256 cellar: :any,                 arm64_big_sur:  "a8a8486dbbed3ca5a49b386e13a8ff576e94dc7dfe002a129a0573cdd58c4a13"
    sha256 cellar: :any,                 monterey:       "a61635933384249ec62d1fd5df69d15e512d3c80a4b353d222573395764bacb8"
    sha256 cellar: :any,                 big_sur:        "dffd4baf237a429011f44e5c7cb736c4e6755d45b7e17ab06132d38914e1b522"
    sha256 cellar: :any,                 catalina:       "f3e8d7dea2c6be1a4b55d4c45c3a5e12d0b9dd5eb9891dcce0003ef707cc6f4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd7a930d885dc79bec5855e769ff4258c9ad3c44b1f0902d36e18064d067ff3b"
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
