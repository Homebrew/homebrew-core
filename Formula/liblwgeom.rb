class Liblwgeom < Formula
  desc "Allows SpatiaLite to support ST_MakeValid() like PostGIS"
  homepage "https://postgis.net/"
  url "https://download.osgeo.org/postgis/source/postgis-2.5.4.tar.gz"
  sha256 "146d59351cf830e2a2a72fa14e700cd5eab6c18ad3e7c644f57c4cee7ed98bbe"
  license "GPL-2.0-or-later"
  revision 1
  head "https://git.osgeo.org/gitea/postgis/postgis.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "c6e2f39f90827be84a17c7a1bfd7c0043bf3f0a433bfc1e38e2d9094028caad1"
    sha256 cellar: :any,                 arm64_big_sur:  "4f8f0403e973d5e2eafb1b3d49deae54a3cb95a80dc42c50f1f28edcc73da0d8"
    sha256 cellar: :any,                 monterey:       "fe6ef90e0a9026b59e89684f49ad9ddcb25a06fff022168b0b8f1f8d10a92bb7"
    sha256 cellar: :any,                 big_sur:        "e28a391dfb1ccf34656e8169d5eda63bb96c7693508429f7c22b47add8a8bd47"
    sha256 cellar: :any,                 catalina:       "cd5a31ea1b30721f36fcd64285b3150667c4cf30a148ffafa88d4e5c81456f45"
    sha256 cellar: :any,                 mojave:         "79247efadb38c42e631ceeb750a8379fd68a2a5c720ec265f8f11502764be46b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9797785b01201a7eb6c4a2d5ba50e98c0b1c0b89e1671fd5914014a25c90b058"
  end

  keg_only "conflicts with PostGIS, which also installs liblwgeom.dylib"

  # See details in https://github.com/postgis/postgis/pull/348
  deprecate! date: "2020-11-23", because: "liblwgeom headers are not installed anymore, use librttopo instead"

  depends_on "autoconf@2.69" => :build
  depends_on "automake" => :build
  depends_on "gpp" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "geos"
  depends_on "json-c"
  depends_on "proj@7"

  uses_from_macos "libxml2"

  def install
    # See postgis.rb for comments about these settings
    ENV.deparallelize

    args = [
      "--disable-dependency-tracking",
      "--disable-nls",

      "--with-projdir=#{Formula["proj@7"].opt_prefix}",
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
    system ENV.cc, "test.c", "-I#{include}", "-I#{Formula["proj@7"].opt_include}",
                   "-L#{lib}", "-llwgeom", "-o", "test"
    system "./test"
  end
end
