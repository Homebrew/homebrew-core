class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.5.2.tar.gz"
  sha256 "b6cb286c5016029d984f8c440947bf9178da72e1f6f840ed639270e1c451db5e"
  revision 2
  head "https://git.osgeo.org/gitea/postgis/postgis"

  bottle do
    cellar :any
    sha256 "eb57429e1015f7d99ac3ddcf529168d7b8ed205c9b27845532bd1dcf9988d139" => :catalina
    sha256 "ae9c29245251a22f8a93b751ae13ebb756e32f29f3fcfc18f1908db22fec534d" => :mojave
    sha256 "7fb25efd9d5c9066478b3bfa37eb20fe9067dde08a68d5d0ab71906f16c9b934" => :high_sierra
    sha256 "5f4e4b2b89b59da69a7b0274b6a5db86b14b007a46ad985193fc173f8926ec9e" => :sierra
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

  uses_from_macos "libxml2"

  def install
    # See postgis.rb for comments about these settings
    ENV.deparallelize

    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    args = [
      "--disable-dependency-tracking",
      "--disable-nls",

      "--with-projdir=#{Formula["proj"].opt_prefix}",
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
