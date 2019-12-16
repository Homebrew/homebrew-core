class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.0.tar.gz"
  sha256 "21dd53f427793cbc52d1c007e9b7339c83f6944a937a1acfbbe733e49b65378b"

  bottle do
    cellar :any
    sha256 "0bcc7388320bb34ee4071c5ce4d8f70dbdeee0a4f3577043a745f232000b651a" => :catalina
    sha256 "9f3b26f85f0daaf83a61a7666e2ac7a64b951a6c003a32477f4e9ff8af524318" => :mojave
    sha256 "d36794e7e2509865df9b0abd5e8d1a1cee10810ffbcff8d8b7ff10436c5f54a8" => :high_sierra
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
