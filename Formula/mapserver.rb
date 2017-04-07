class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "http://mapserver.org/"
  url "http://download.osgeo.org/mapserver/mapserver-7.0.4.tar.gz"
  sha256 "c91d40da5cc242b20ca7e29c41bd9eb23097b98a77908b1d708e9708f6f6cf69"
  revision 1

  bottle do
    cellar :any
    sha256 "ca153f9d18dd67a56243d5e35075912fe2ea64c5cdb7bed48d269c2f0c50c8c0" => :sierra
    sha256 "e3d905a18cd9509733225f01c879aeb2a170406dc5b34dd072252f30dc7db724" => :el_capitan
    sha256 "152152b5084d353299b06dc55c09b8cd64c4607d227a991f7c2de467f5b9c0fc" => :yosemite
  end

  option "with-fastcgi", "Build with fastcgi support"
  option "with-geos", "Build support for GEOS spatial operations"
  option "with-php", "Build PHP MapScript module"
  option "with-postgresql", "Build support for PostgreSQL as a data source"

  depends_on "pkg-config" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "freetype"
  depends_on "libpng"
  depends_on "giflib"
  depends_on "gd"
  depends_on "proj"
  depends_on "gdal"
  depends_on "geos" => :optional
  depends_on "postgresql" => :optional unless MacOS.version >= :lion
  depends_on "cairo" => :optional
  depends_on "fcgi" if build.with? "fastcgi"

  def install
    # Harfbuzz support requires fribidi and fribidi support requires
    # harfbuzz but fribidi currently fails to build with:
    # fribidi-common.h:61:12: fatal error: 'glib.h' file not found
    args = std_cmake_args + %w[
      -DWITH_PROJ=ON
      -DWITH_GDAL=ON
      -DWITH_OGR=ON
      -DWITH_WFS=ON
      -DWITH_FRIBIDI=OFF
      -DWITH_HARFBUZZ=OFF
      -DPYTHON_EXECUTABLE:FILEPATH=#{which("python")}
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

  def caveats; <<-EOS.undent
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
    system "python", "-c", "import mapscript"
  end
end
