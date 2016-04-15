class GdalGrass < Formula
  desc "Geospatial Data Abstraction Library"
  homepage "http://www.gdal.org"
  url "http://download.osgeo.org/gdal/gdal-grass-1.4.3.tar.gz"
  sha256 "ea18d1e773e8875aaf3261a6ccd2a5fa22d998f064196399dfe73d991688f1dd"

  bottle do
    sha256 "54446071761bb8453325566649e56680351121dd7ee7b404d8d22034530188e7" => :el_capitan
    sha256 "976fffb23b24d5c8da1c382156e855e5a0a13bb7ee49062faa79d3f70dba2915" => :yosemite
    sha256 "5362ed467fedfaedecd815a1651323ac58dc11ea94f2586334ce4255b566a4ca" => :mavericks
  end

  depends_on "gdal"
  depends_on "grass"

  def install
    gdal = Formula["gdal"]
    grass = Formula["grass"]

    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-gdal=#{gdal.bin}/gdal-config",
                          "--with-grass=#{grass.opt_prefix}/grass-#{grass.version}",
                          "--with-autoload=#{lib}/gdalplugins"

    inreplace "Makefile", "mkdir", "mkdir -p"

    system "make", "install"
  end

  def caveats; <<-EOS.undent
    This formula provides a plugin that allows GDAL and OGR to access geospatial
    data stored using the GRASS vector and raster formats. In order to use the
    plugin, you will need to add the following path to the GDAL_DRIVER_PATH
    enviroment variable:
      #{HOMEBREW_PREFIX}/lib/gdalplugins
    EOS
  end
end
