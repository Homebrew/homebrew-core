class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/5.0.7.tar.gz"
  sha256 "6ddb397e7de4a7876e7d84ea82d4ee716cfd60ad8ee50ef49716945c505cbc1d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any, arm64_monterey: "969c10367b15f8310e6656162903f55e43a65f1e55b269b3ddc2413e0ce06054"
    sha256 cellar: :any, arm64_big_sur:  "a78efa89eb88eb6df2cc493ccfed637269a2f0eae864ad86ccbed4730a7010d3"
    sha256 cellar: :any, monterey:       "3d9c9aa49c1ccf60e6221757c18685b2808e1621aac1adca951f38666ff44f49"
    sha256 cellar: :any, big_sur:        "4b6615c01fd7fbb64bf1780fcbfcc8a365a00d2e833c2e3346c683c6f98b32c1"
    sha256 cellar: :any, catalina:       "41a6ed161459fce3df960c04741418ffb970f8b68bac4e829858edd0ef42c070"
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

  resource "homebrew-example_nc" do
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
    testpath.install resource("homebrew-example_nc")
    output = shell_output("#{bin}/ncks --json -M WMI_Lear.nc")
    assert_match "\"time\": 180", output
  end
end
