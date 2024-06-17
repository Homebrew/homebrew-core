class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.2.tar.gz"
  sha256 "0830c43feefeca132171b429403716a2cbaef0626d439f00e8a3a27a877724fe"
  license "MIT"

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "df083d3f5d77b1e7249efe82c9a5a4bfcac4b8db1f13929f457ec21124d281c5"
    sha256 cellar: :any,                 arm64_ventura:  "dcc078b16c5b88ae71d02cbab742c5305e89a09f693ffa3e74cda590621181cf"
    sha256 cellar: :any,                 arm64_monterey: "a8f9a340f6b553ce137c5e51f2229336f1c2002fe6b31809dfafdad667fb2118"
    sha256 cellar: :any,                 sonoma:         "8c43b03c3d8b9c5435101147778e4973c0fef6cab6ba43e86a83ce02fbd00ad8"
    sha256 cellar: :any,                 ventura:        "b2d9392c5109069c1f0e768259f9ee01ff00edbfa8e775fa810c9e70e66e3e0c"
    sha256 cellar: :any,                 monterey:       "72eeddda6ab14b114187390402277ad5d51d499f40e8260633b311c1d900e971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9fd28f83025099feb0251fea368c489d364ea67dcb36d8914d9f223ac6e7cf5"
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
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "libxml2"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.12"

  uses_from_macos "curl"

  fails_with gcc: "5"

  def python3
    "python3.12"
  end

  def install
    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    if DevelopmentTools.clang_build_version >= 1500
      recursive_dependencies
        .select { |d| d.name.match?(/^llvm(@\d+)?$/) }
        .map { |llvm_dep| llvm_dep.to_formula.opt_lib }
        .each { |llvm_lib| ENV.remove "HOMEBREW_LIBRARY_PATHS", llvm_lib }
    end

    # Workaround for: Built-in generator --c_out specifies a maximum edition
    # PROTO3 which is not the protoc maximum 2023.
    # Remove when fixed in `protobuf-c`:
    # https://github.com/protobuf-c/protobuf-c/pull/711
    inreplace "CMakeLists.txt",
              "COMMAND ${PROTOBUFC_COMPILER}",
              "COMMAND #{Formula["protobuf"].opt_bin/"protoc"}"

    if OS.mac?
      mapscript_rpath = rpath(source: prefix/Language::Python.site_packages(python3)/"mapscript")
      # Install within our sandbox and add missing RPATH due to _mapscript.so not using CMake install()
      inreplace "mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}",
                                                   "-Wl,-undefined,dynamic_lookup,-rpath,#{mapscript_rpath}"
    end

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

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./build/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end
