class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.6.tar.gz"
  sha256 "c7926163b204573b7bf7b6e3c9bcfa15b2cc04c0f494dbc0c6829ee8c2f015b3"
  revision 3

  bottle do
    cellar :any
    sha256 "32ed25d57c795ffb7a56eac923c4b2e908e80cc72cab884524ba242474443be8" => :mojave
    sha256 "dbc34488e46c857ff3ee4e8a805a085b82fb331aa6f502d1c69303a07525307c" => :high_sierra
    sha256 "7e6e460c005e785a0673fe910d455518010d0ae72ead58ff1bf6d972d2887b65" => :sierra
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
