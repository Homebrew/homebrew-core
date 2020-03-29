class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.2.tar.gz"
  sha256 "1a98c37c946c00232fa7319d00d1d80f77603adda7c9239d10d68a8a3545a4d5"
  revision 1

  bottle do
    cellar :any
    sha256 "35f0438126a52c6ddfbf1f301be740c0589303a8fb61a63c695ca3d06cb2745a" => :catalina
    sha256 "836dde6df4d77bca7a2e8f505241b1f2d0855c6cf5846ab13b2dd6d865fec519" => :mojave
    sha256 "bb8b22c4ae16a13b48ec4f89fe3e521f71fd394d7550222c23762ea32ca9f67a" => :high_sierra
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
