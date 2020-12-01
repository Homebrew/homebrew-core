class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.6.tar.gz"
  sha256 "2b3da28e12e873ebf2ae154f1366827adfe51e4d7b65d2e44895b5d8920fbe92"
  license "BSD-3-Clause"

  livecheck do
    url "https://github.com/nco/nco/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any
    sha256 "ec5e54a531809686c28d52576e920cf6a0125662611bdaa10c58c3ad2c2a80ad" => :catalina
    sha256 "f8cf2664b6504fa5b6f120ab3dcb30b05d90a963767e4591c6f08ba87e768dbd" => :mojave
    sha256 "c8912147b9144e59e02dac69965e660c1facbf4659b5f648b90bf20b6e6ecfc2" => :high_sierra
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
