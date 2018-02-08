class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net"
  url "http://download.osgeo.org/postgis/source/postgis-2.4.3.tar.gz"
  sha256 "ea5374c5db6b645ba5628ddcb08f71d3b3d90a464d366b4e1d20d5a268bde4b9"

  bottle do
    cellar :any
    sha256 "a0f1de43d92642fb933e3a5365ad1985e79377f3f47e0f33bc547b73cdcd7267" => :high_sierra
    sha256 "55bc93a06f6981f5aea43764ef2c228a0527187f6127c91c672cf2dd1617bf85" => :sierra
    sha256 "d93db626f97638f2d267444e5fa85222b35673293245d576e0a3ab0020fb187b" => :el_capitan
    sha256 "c793550ab04e4c40a3f3c2dfbb63476e2e1629182a52d6b9e404ca8ca52e5d64" => :yosemite
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
