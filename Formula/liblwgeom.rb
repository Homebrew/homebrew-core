class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.4.4.tar.gz"
  sha256 "0663efb589210d5048d95c817e5cf29552ec8180e16d4c6ef56c94255faca8c2"
  revision 1
  head "https://svn.osgeo.org/postgis/trunk/"

  bottle do
    cellar :any
    sha256 "9d6b721be4984a42861a14ba798dd15deb54f524d5a710c7ad78d2097d309503" => :mojave
    sha256 "61f2cd87123236e471f469467319665664743837a35c5074e868c9908824843e" => :high_sierra
    sha256 "49cff9c152a94004541516365c60decf5dd5107977e300ef9185d1e9bf8d6db6" => :sierra
    sha256 "38054f5facd281c4acbe75597f67bed2133549efe33bef0f6200116dd47605d2" => :el_capitan
  end

  keg_only "conflicts with PostGIS, which also installs liblwgeom.dylib"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gpp" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "geos"
  depends_on "json-c"
  depends_on "proj"

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
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["proj"].opt_include}",
                   "-L#{lib}", "-llwgeom", "-o", "test"
    system "./test"
  end
end
