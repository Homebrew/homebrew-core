class Nco < Formula
  desc "Command-line operators for netCDF and HDF files"
  homepage "https://nco.sourceforge.io/"
  url "https://github.com/nco/nco/archive/4.9.3.tar.gz"
  sha256 "eade5b79f3814b11ae3f52c34159567e76a73f05f0ab141eccaac68f0ca94aee"

  bottle do
    cellar :any
    sha256 "9f53ff9c47aa40ee16bffe1e46fa9e6717d7c4ce6e31bafac25b35ad62bc2795" => :catalina
    sha256 "4fa614f82d1192fca1bfae3dcac04a01f6d761dd950bef1382ff78a462e4842a" => :mojave
    sha256 "8383912efae988148e4f80bca1a872c24fdcb04dfc1c0512c43cfd54825d66ed" => :high_sierra
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
