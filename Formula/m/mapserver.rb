class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.1.tar.gz"
  sha256 "79d23595ef95d61d3d728ae5e60850a3dbfbf58a46953b4fdc8e6e0ffe5748ba"
  license "MIT"
  revision 4

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "252b429d4ee0456cdfe56cf9b4601262f10798f3572f2e6e9132de28d2b1b7e6"
    sha256 cellar: :any,                 arm64_ventura:  "1e0ba7954886813fe47c42d78910fa8fa94909cdda5ed0048dd1824e2bdf35f9"
    sha256 cellar: :any,                 arm64_monterey: "9c550c439d4532ea7ac74f1fd37816a7366244d660ee76cae7d5538669987910"
    sha256 cellar: :any,                 sonoma:         "0fded9d4327ead0a44b58936f89cf500e26f19f5704b5f278044ed16ecb72195"
    sha256 cellar: :any,                 ventura:        "66d4d92504b87465133acfda0014cdd8fdbb2278c6302d8f24862c7cce465a2b"
    sha256 cellar: :any,                 monterey:       "beb66d71d4014779bc75fdd3587f84e08cbab1048101378d9156790f09739173"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0238f8c273ab240b67e00228d9c4b333ab936f1b55deea7414aa9c78da18f87d"
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
  depends_on "python@3.12"

  uses_from_macos "curl"

  fails_with gcc: "5"

  # Backport fix for libxml2 2.12.
  # Ref: https://github.com/MapServer/MapServer/commit/2cea5a12a35b396800296cb1c3ea08eb00b29760
  patch :DATA

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

__END__
diff --git a/mapows.c b/mapows.c
index f141a7b..5a94ecb 100644
--- a/mapows.c
+++ b/mapows.c
@@ -168,7 +168,7 @@ static int msOWSPreParseRequest(cgiRequestObj *request,
 #endif
     if (ows_request->document == NULL
         || (root = xmlDocGetRootElement(ows_request->document)) == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_OWSERR, "XML parsing error: %s",
                  "msOWSPreParseRequest()", error->message);
       return MS_FAILURE;
diff --git a/mapwcs.cpp b/mapwcs.cpp
index 70e63b8..19afa79 100644
--- a/mapwcs.cpp
+++ b/mapwcs.cpp
@@ -362,7 +362,7 @@ static int msWCSParseRequest(cgiRequestObj *request, wcsParamsObj *params, mapOb
     /* parse to DOM-Structure and get root element */
     if((doc = xmlParseMemory(request->postrequest, strlen(request->postrequest)))
         == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_WCSERR, "XML parsing error: %s",
                  "msWCSParseRequest()", error->message);
       return MS_FAILURE;
diff --git a/mapwcs20.cpp b/mapwcs20.cpp
index b35e803..2431bdc 100644
--- a/mapwcs20.cpp
+++ b/mapwcs20.cpp
@@ -1446,7 +1446,7 @@ int msWCSParseRequest20(mapObj *map,

     /* parse to DOM-Structure and get root element */
     if(doc == NULL) {
-      xmlErrorPtr error = xmlGetLastError();
+      const xmlError *error = xmlGetLastError();
       msSetError(MS_WCSERR, "XML parsing error: %s",
                  "msWCSParseRequest20()", error->message);
       return MS_FAILURE;
