class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net"
  url "http://download.osgeo.org/postgis/source/postgis-2.4.3.tar.gz"
  sha256 "ea5374c5db6b645ba5628ddcb08f71d3b3d90a464d366b4e1d20d5a268bde4b9"

  bottle do
    cellar :any
    sha256 "d844e20771f16f98b92a229a9726eb6a78d9e3e8cb48093749565ff9ed85d3fc" => :high_sierra
    sha256 "9e85d5e2290eaefac0f8651aba797ed61385f42cbaf7703de7ae21b02ca9d8bb" => :sierra
    sha256 "4f8d9ec067213ba75bec47f38921c5d2564b7d06633a684f7474c114af2c03fd" => :el_capitan
  end

  head do
    url "https://svn.osgeo.org/postgis/trunk/"
  end

  keg_only "conflicts with PostGIS, which also installs liblwgeom.dylib"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "gpp" => :build

  depends_on "proj"
  depends_on "geos"
  depends_on "json-c"

  def install
    # See postgis.rb for comments about these settings
    ENV.deparallelize

    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    args = [
      "--disable-dependency-tracking",
      "--disable-nls",

      "--with-projdir=#{HOMEBREW_PREFIX}",
      "--with-jsondir=#{Formula["json-c"].opt_prefix}",

      # Disable extraneous support
      "--without-pgconfig",
      "--without-libiconv-prefix",
      "--without-libintl-prefix",
      "--without-raster", # this ensures gdal is not required
      "--without-topology",
    ]

    system "./autogen.sh"
    system "./configure", *args

    mkdir "stage"
    cd "liblwgeom" do
      system "make", "install", "DESTDIR=#{buildpath}/stage"
    end

    lib.install Dir["stage/**/lib/*"]
    include.install Dir["stage/**/include/*"]
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <liblwgeom.h>

      int main(int argc, char* argv[])
      {
        printf("%s\\n", lwgeom_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-llwgeom", "-o", "test"
    system "./test"
  end
end
