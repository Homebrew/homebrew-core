class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.4.3.tar.gz"
  sha256 "ea5374c5db6b645ba5628ddcb08f71d3b3d90a464d366b4e1d20d5a268bde4b9"
  revision 1

  bottle do
    cellar :any
    sha256 "27deb705d45152887db0b7d4b49ac4cf20b08b419589b86c54827d43f26e767f" => :high_sierra
    sha256 "d295d62000aa81ca61b26b265dbb9ee43104346401c266a2b1566d157646fea4" => :sierra
    sha256 "73371ed890f29ec626a4fac6b73b037d6c9a06e5f79c38a1e7e7343d8cf64d9f" => :el_capitan
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
