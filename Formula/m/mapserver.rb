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
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "93a36b327ca8f2b294a52d1da4e063e38cea0ee224eaae1d96720fd68ec12b2b"
    sha256 cellar: :any,                 arm64_ventura:  "4dd3e41d3ebe7c5f480e398ecb71d0fac5dd8585d6d0a0ddfe86de0e2a601b01"
    sha256 cellar: :any,                 arm64_monterey: "50787a57f680308f36da5995d3a20a6143e0a824e2bd73b3092e75dc7707b709"
    sha256 cellar: :any,                 sonoma:         "760ef6ac55a8c0bc297ed84481cdc8c8df8f0fbf19fd229116b8e4ff3b1f68b5"
    sha256 cellar: :any,                 ventura:        "1677aa203a9d80add1e941bcbf7be1e996aaee6de3bc7ef93c55dc6541d3b13a"
    sha256 cellar: :any,                 monterey:       "001b417b57b8347091c916d7c61e3edc2a298a895bebe5431355765378917e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99cca4e27830b84491052b9ac2938b79ecaf65a0821cbdb790a466e97b314c14"
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
