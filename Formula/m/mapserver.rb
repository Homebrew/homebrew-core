class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.1.tar.gz"
  sha256 "79d23595ef95d61d3d728ae5e60850a3dbfbf58a46953b4fdc8e6e0ffe5748ba"
  license "MIT"
  revision 3

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "417ea23b7db3336eb582692abafc6265015f7f424152f71b7c99aa4d9edc2b51"
    sha256 cellar: :any,                 arm64_ventura:  "4b8bc4020f0e03dc9fc0d64fa7709aa9ce0819d447c91187a7228cffae1249c1"
    sha256 cellar: :any,                 arm64_monterey: "71afffdab237d711e337c3f50a0278c73d0f5b63505bf1bc8c04c38388786506"
    sha256 cellar: :any,                 sonoma:         "470a8bdef57b5fdf5e0c92303d6fa8101f4a9c529a18f410be1dfadba64f6f92"
    sha256 cellar: :any,                 ventura:        "76c47a791f5d43ac446c96f97983fc7a97b7b1c6bf1d7805997d50af50d9b731"
    sha256 cellar: :any,                 monterey:       "fe70e573afd212128b2b0d73534a2b9217a589d34e67a54c5b404fa54a550863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3077bc5846b4ee582907f74a0ad3b74bf27b282b7a1c692b4404280b02d44b12"
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
