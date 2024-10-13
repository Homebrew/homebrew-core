class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.2.2.tar.gz"
  sha256 "47d8ee4bd12ddd2f04b24aa84c6e58f8e6990bcd5c150ba42e22f30ad30568e4"
  license "MIT"

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "08fa6d2e815968e98cc2ea69cf5d67c4617b9ad269448fe66fd0c61353658628"
    sha256 cellar: :any,                 arm64_sonoma:   "8156feda4d5a44c24733ed153337f2cde96f78fd9ffaf2a3e498b23fddb7e2e9"
    sha256 cellar: :any,                 arm64_ventura:  "6a21a6a818fba2a07bb000dc9727d89da2ae6bc6ed2e2eef50a7c63667871589"
    sha256 cellar: :any,                 arm64_monterey: "a70bac0f70e22ba880f809f7a9c3d904e1dd4b09eb568e58a997b96b5e92cf0d"
    sha256 cellar: :any,                 sonoma:         "2da3d1923df6bb88a6aac67eabd2a3a619e28ab94895e7efdc4e4db9290f6bc3"
    sha256 cellar: :any,                 ventura:        "e695ab2bb013dbad84505f69c172bc0b606f4b17a916175d3df8193ff1248f82"
    sha256 cellar: :any,                 monterey:       "c9884acce9f4b57ab5371b2a47f173bc16f0e795086c2473a47d993fadbe1de2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2bde7262a28bd5f3a466f948dc6ac9fbdd8bd310ad4b5eac9d722282a3cea0d9"
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
      inreplace "src/mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}",
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

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "./build/src/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end
