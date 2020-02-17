class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.2.tar.gz"
  sha256 "1a98c37c946c00232fa7319d00d1d80f77603adda7c9239d10d68a8a3545a4d5"

  bottle do
    cellar :any
    sha256 "cae7ab582591c009783f97b0d43ffdbefde0daf8b9dd40c174760f6f7167876d" => :catalina
    sha256 "3eb3e938472cf52b95a26a0ba0f25878f88d9c8658f70976913d7e7a69ae8ada" => :mojave
    sha256 "00dc03f50181256ba6f816e5dce9a387d19e9b77a98f8381d9c695b0e1b1ca6d" => :high_sierra
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
