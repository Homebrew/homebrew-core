class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/nco/nco-4.7.6.tar.gz"
  sha256 "c7926163b204573b7bf7b6e3c9bcfa15b2cc04c0f494dbc0c6829ee8c2f015b3"
  revision 2

  bottle do
    cellar :any
    sha256 "b11322a87e6f686782432a9eaaa7578dfbe03eefb0f5c5a3f8aaf8a7936b7f38" => :mojave
    sha256 "759df479d43889368a69640764bfd9a95952db868474d8e8b564e74729825d50" => :high_sierra
    sha256 "8b26a8d3427d1b495697b87e1df8b36068dde5b9252e6699965f35a3637ce5a0" => :sierra
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
