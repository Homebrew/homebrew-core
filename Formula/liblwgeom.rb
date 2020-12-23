class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.5.4.tar.gz"
  sha256 "146d59351cf830e2a2a72fa14e700cd5eab6c18ad3e7c644f57c4cee7ed98bbe"
  revision 1
  head "https://git.osgeo.org/gitea/postgis/postgis.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e28a391dfb1ccf34656e8169d5eda63bb96c7693508429f7c22b47add8a8bd47" => :big_sur
    sha256 "4f8f0403e973d5e2eafb1b3d49deae54a3cb95a80dc42c50f1f28edcc73da0d8" => :arm64_big_sur
    sha256 "cd5a31ea1b30721f36fcd64285b3150667c4cf30a148ffafa88d4e5c81456f45" => :catalina
    sha256 "79247efadb38c42e631ceeb750a8379fd68a2a5c720ec265f8f11502764be46b" => :mojave
  end

  keg_only "conflicts with PostGIS, which also installs liblwgeom.dylib"

  # See details in https://github.com/postgis/postgis/pull/348
  deprecate! date: "2020-11-23", because: "liblwgeom headers are not installed anymore, use librttopo instead"

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
