class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-7.2.1.tar.gz"
  sha256 "9459a7057d5a85be66a41096a5d804f74665381186c37077c94b56e784db6102"

  bottle do
    cellar :any
    sha256 "283f73045165ca1674b10a9e2b9b48aec93c5d097a2fe01c547464cd6213f36f" => :mojave
    sha256 "0dfd0efc69c78bc629dca2afe0f891a2ea0a0835c3c6c3e08449f9ec76defb8d" => :high_sierra
    sha256 "8efdeb9599cbde78e4202c26e8d450a176f46fda7d21ba9806824633a70dbe71" => :sierra
  end

  option "with-fastcgi", "Build with fastcgi support"
  option "with-geos", "Build support for GEOS spatial operations"
  option "with-php", "Build PHP MapScript module"
  option "with-postgresql", "Build support for PostgreSQL as a data source"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "fcgi" if build.with? "fastcgi"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gdal"
  depends_on "giflib"
  depends_on "libpng"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "cairo" => :optional
  depends_on "geos" => :optional
  depends_on "postgresql" => :optional unless MacOS.version >= :lion

  def install
    # Harfbuzz support requires fribidi and fribidi support requires
    # harfbuzz but fribidi currently fails to build with:
    # fribidi-common.h:61:12: fatal error: 'glib.h' file not found
    args = std_cmake_args + %w[
      -DWITH_KML=ON
      -DWITH_CURL=ON
      -DWITH_CLIENT_WMS=ON
      -DWITH_CLIENT_WFS=ON
      -DWITH_SOS=ON
      -DWITH_PROJ=ON
      -DWITH_GDAL=ON
      -DWITH_OGR=ON
      -DWITH_WFS=ON
      -DWITH_FRIBIDI=OFF
      -DWITH_HARFBUZZ=OFF
      -DPYTHON_EXECUTABLE:FILEPATH=/usr/bin/python
    ]

    # Install within our sandbox.
    inreplace "mapscript/php/CMakeLists.txt", "${PHP5_EXTENSION_DIR}", lib/"php/extensions"
    args << "-DWITH_PHP=ON" if build.with? "php"

    # Install within our sandbox.
    inreplace "mapscript/python/CMakeLists.txt" do |s|
      s.gsub! "${PYTHON_SITE_PACKAGES}", lib/"python2.7/site-packages"
      s.gsub! "${PYTHON_LIBRARIES}", "-Wl,-undefined,dynamic_lookup"
    end
    args << "-DWITH_PYTHON=ON"
    # Using rpath on python module seems to cause problems if you attempt to
    # import it with an interpreter it wasn't built against.
    # 2): Library not loaded: @rpath/libmapserver.1.dylib
    args << "-DCMAKE_SKIP_RPATH=ON"

    # All of the below are on by default so need
    # explicitly disabling if not requested.
    if build.with? "geos"
      args << "-DWITH_GEOS=ON"
    else
      args << "-DWITH_GEOS=OFF"
    end

    if build.with? "cairo"
      args << "-WITH_CAIRO=ON"
    else
      args << "-DWITH_CAIRO=OFF"
    end

    if build.with? "postgresql"
      args << "-DWITH_POSTGIS=ON"
    else
      args << "-DWITH_POSTGIS=OFF"
    end

    if build.with? "fastcgi"
      args << "-DWITH_FCGI=ON"
    else
      args << "-DWITH_FCGI=OFF"
    end

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  def caveats; <<~EOS
    The Mapserver CGI executable is #{opt_bin}/mapserv

    If you built the PHP option:
      * Add the following line to php.ini:
        extension="#{opt_lib}/php/extensions/php_mapscript.so"
      * Execute "php -m"
      * You should see MapScript in the module list
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system "python2.7", "-c", "import mapscript"
  end
end
