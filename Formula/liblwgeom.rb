class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.4.4.tar.gz"
  sha256 "0663efb589210d5048d95c817e5cf29552ec8180e16d4c6ef56c94255faca8c2"

  bottle do
    cellar :any
    sha256 "86937c9288bc3954f3884c6cc73bd4289bf0a74aa7da7a84c08d7a4cd50827d8" => :high_sierra
    sha256 "0cf13878c767f7126b61844990317cb3c30898ca9cb52fba966a9b0f065f9c65" => :sierra
    sha256 "94f3335645bf48cadb4069bb57c1c08ec734e8c23dbbe36ec64bcb695807406c" => :el_capitan
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
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["proj"].opt_include}",
                   "-L#{lib}", "-llwgeom", "-o", "test"
    system "./test"
  end
end
