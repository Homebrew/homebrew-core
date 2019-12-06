class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.0.tar.gz"
  sha256 "21dd53f427793cbc52d1c007e9b7339c83f6944a937a1acfbbe733e49b65378b"

  bottle do
    cellar :any
    sha256 "14a92c2373cbdf2098264f099348223de2f5a507cd15a75889a8e62b8b82aa3a" => :catalina
    sha256 "80a05916a67070e48074f1f49369d42dacb101dd50940d8f63e2ea16c88e0b8f" => :mojave
    sha256 "cf39e1dc7236401cefc04ba2c59c8cbba2ab7b45f5ae0edb0f9a43c8ab1f3e17" => :high_sierra
    sha256 "8840def4067075738ad92779f1b12069bb211bc3f156ab0f774528d6432535fa" => :sierra
  end

  head do
    url "https://github.com/nco/nco.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "antlr@2" # requires C++ interface in Antlr2
  depends_on "gsl"
  depends_on "netcdf"
  depends_on "texinfo"
  depends_on "udunits"

  resource "example_nc" do
    url "https://www.unidata.ucar.edu/software/netcdf/examples/WMI_Lear.nc"
    sha256 "e37527146376716ef335d01d68efc8d0142bdebf8d9d7f4e8cbe6f880807bdef"
  end

  def install
    system "./autogen.sh" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-netcdf4"
    system "make", "install"
  end

  test do
    testpath.install resource("example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
