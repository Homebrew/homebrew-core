class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.8.1.tar.gz"
  sha256 "ddae3fed46c266798ed1176d6a70b36376d2d320fa933c716a623172d1e13c68"
  revision 2

  bottle do
    cellar :any
    sha256 "2ef631c0349a3106fb90b24c7040f115ba27b28cf912431d0ab7ac53d1fe96d6" => :mojave
    sha256 "d7dc4b9e63085258193b90f8a7af77096c5d32681046e82a93c8764a1de3607e" => :high_sierra
    sha256 "ab8618eb16b8f3eb49010abc9be01d0c56937d15b78d34c21a23e64d81cdccfc" => :sierra
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
