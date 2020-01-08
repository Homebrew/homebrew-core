class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.1.tar.gz"
  sha256 "9592efaf0dfd6ccdefd0b417d990cfccae7e89c20d90fb44ead6263009778834"

  bottle do
    cellar :any
    sha256 "84228732cd53fd0c60fef0734d8a7637f141457501e5efbf26dca3e8bb73896a" => :catalina
    sha256 "731e1f3543a3a896dea9821dc3947ba230dde15806d5a19be9a10312efa0a427" => :mojave
    sha256 "8903dbe7f4a2673e3d2948edacaf676d716072100353eb2f7d949df090fb578e" => :high_sierra
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
